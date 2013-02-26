class Family < ActiveRecord::Base    
  has_many :children
  has_many :awaiting_relations, :through => :children, :conditions => {"relations.accepted" => 0}, :source => :relations
  has_many :relations, :through => :children, :conditions => {"relations.accepted" => 1}, :source => :relations
  has_many :member_relations, :through => :children, :conditions => { "relations.accepted" => 1, "relations.is_admin" => false}, :source => :relations
  has_many :admin_relations, :through => :children, :conditions => { "relations.accepted" => 1, "relations.is_admin" => true}, :source => :relations
  has_many :members, :through => :member_relations, :source => :user, :uniq => true
  has_many :admins, :through => :admin_relations, :source => :user, :uniq => true
  
  def is_admin? user
    admin = self.admin_relations.find_by_user_id(user.id, :conditions => {"relations.access" => true })
    return admin.present?
  end

  def is_family_admin? user
    f_admin = self.admin_relations.find_by_user_id(user.id)
    return f_admin.present? && (f_admin.is_family_admin || f_admin.member_type == "Father" || f_admin.member_type == "Mother")
  end

  def get_display_name user
    families = user.families.where(["families.id != ?", self.id] ).all
    families = families.reject { |f| self.id == f.id }
    if families.any? { |f| f.name == self.name }
      return self.full_name
    else
      return self.name
    end
  end

  #=================================================
  #================ INVITING USERS =================
  #=================================================
  def self.check_invitation_emails types, emails, invitation_emails
    error = false
    non_empty_emails = emails.reject{|i| i.blank? }
    error = "You can invite same user only once." unless non_empty_emails.length == non_empty_emails.uniq.length
    error = "No email addresses entered" unless emails.any? { |e| e.present? }
    
    types.each_with_index do |t, idx|
      item = { :email => emails[idx].strip, :type => t, :error => nil }
      if item[:email].present? && !item[:email].match(/^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i)
        item[:error] = "should look like an email address"
        error = "Invalid email address entered"
      end
      invitation_emails << item
    end
    
    return error
  end

  def invite_users invitation_emails, users, current_user
        error = false
        family_children = self.children.joins(:relations).where("relations.user_id" => current_user.id).all

        invitation_emails.select{|ie| ie[:email].present? && ie[:error].blank?}.each do |ie|
          user = User.find_or_initialize_by_email(ie[:email], :is_temporary => true, :email_confirmed => false)

          if user.new_record?
            user.reset_password
            user.reset_single_access_token
            user.reset_perishable_token
          end

          belongs_to_family = user.all_children.where('children.family_id' => self.id).any?

          if belongs_to_family
            ie[:error] = "user is already a part of the family"
            error = "User is already a part of the family"
          else
            family_children.each do |child|
              user.relations.build({:child => child, :member_type => ie[:type], :token => current_user.perishable_token, :inviter => current_user, :is_admin => false, :accepted => false, :access => true, :display_name => user.get_user_name})
              current_user.reset_perishable_token!
            end
            users << user
          end
        end

        return error
  end
  #=================================================
  #=================================================
  #=================================================

  #=================================================
  #================ ADDING A CHILD =================
  #=================================================
  def self.user_added_child user, child,relation_type, family_id, family_name      
      family = user.own_families.find_by_id(family_id) if family_id
      
      if family
        family_admin = family.is_family_admin?(user)
      else
        family_name ||= user.last_name
        family_name = family_name.gsub(/'s$/i, '').capitalize
        family_full_name = "#{user.first_name[0,1]}. #{family_name}"
      
        family = Family.create(:name => family_name, :full_name => family_full_name )
        family_admin = true
      end
      
      child.family = family      
      user.relations.create(:child => child, 
                            :member_type => relation_type,
                            :token => user.perishable_token,
                            :display_name => user.get_user_name,
                            :is_admin => true,
                            :is_family_admin => family_admin,
                            :access => true,
                            :accepted => 1)
      
      all_relations = family.relations.includes(:user).where("relations.user_id != ?", user.id).uniq_by{|r| r.user_id}
      Family.add_relations_for_new_child(all_relations, child, user)
      
      UserAction.find_or_create_by_user_id_and_title(user.id, "child_added", :child_id => child.id)
      user.reset_perishable_token!   
  end

  def self.add_relations_for_new_child relations, child, inviter
      relations.each do |relation|
        relation.user.relations.create( :child => child,
                                        :member_type => relation.member_type,
                                        :token => relation.user.perishable_token,
                                        :display_name => relation.display_name,
                                        :is_admin => relation.is_admin,
                                        :is_family_admin => relation.is_family_admin,
                                        :inviter_id => inviter.id,
                                        :access => true,
                                        :accepted => 1)
        relation.user.reset_perishable_token!
      end
  end
  #=================================================
  #=================================================
  #=================================================

end
