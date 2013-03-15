class QuestionsController < ApplicationController
  before_filter :require_child

  def initial_questionnaire    
    @behaviours = Behaviour.get_by_age(current_child.months_old).group_by{|b| b.category}
    @behaviours.each do |k,v|
      @behaviours[k] = [v.first, current_child.behaviours.exists?("behaviours.category" => v.first.category)]
    end
    @q_age = @behaviours.first[1][0].age_from
    @behaviours = @behaviours.sort_by{|k,v| Behaviour::CATEGORIES_ORDER.index(k) }
  end

  def update_seen
    behaviour = Behaviour.find_by_id(params[:behaviour])
    @q_age = params[:start_age].to_i
    
    ###############################################################
    # UPDATE ALL EARLIR SeenBehaviours WHEN USER GO TO NEXT CATEGORY
    
    if params[:value].to_i == 1 and !current_child.has_behaviours_for_cateogry?(behaviour.category)
      
      behaviours = Behaviour.find(:all, 
                                  :select => "id, min(id) AS min_id, age_from",
                                  :order => "age_from DESC",
                                  :group => "age_from",
                                  :conditions => ["age_from < ? AND category = ?", behaviour.age_from, behaviour.category])
      
      behaviours.each do |beh|
        SeenBehaviour.find_or_create_by_child_id_and_behaviour_id(current_child.id, beh.min_id, :user => current_user)
      end
    end
    
    next_args = {
      :order => "age_from ASC, id ASC",
      :limit => 1}    

    if params[:value].to_i == 1
      SeenBehaviour.find_or_create_by_child_id_and_behaviour_id(current_child.id, behaviour.id, :user => current_user)      
      unless @q_age > behaviour.age_from
        next_behaviour = Behaviour.find_by_category(behaviour.category, :order => "age_from ASC, id ASC", :limit => 1, :conditions => ["age_from > ?", behaviour.age_from] )
      end      
    else
      unless @q_age < behaviour.age_from
        next_behaviour = Behaviour.find_by_category(behaviour.category, :order => "age_from DESC, id ASC", :limit => 1, :conditions => ["age_from < ?", behaviour.age_from] )
      end
    end
    
    gray_out = true unless next_behaviour
    next_behaviour ||= behaviour
           
    respond_to do |format|
        format.html { render :partial => 'single_question', :locals => { :behaviour => next_behaviour, :category => behaviour.category, :completed => gray_out } }
    end
  end

  def update_watched
    beh = Behaviour.find_by_id(params[:bid])
    current_child.seen_behaviours.find_or_create_by_behaviour_id(beh.id, :user => current_user)
    respond_to do |format|
        format.html { render :text => 'success' }
    end
  end

  def delete_watched
    beh = Behaviour.find_by_id(params[:bid])
    seen_behaviour = current_child.seen_behaviours.find_by_behaviour_id(beh.id)
    seen_behaviour.destroy
    respond_to do |format|
      format.html { render :text => 'deleted' }
    end
  end

  def initial_questionnaire_completed
    @behaviours = current_child.max_seen_by_category
    @behaviours.each do |b|
      te = TimelineEntry.build_entry("watch",
                                      current_child.replace_forms(b.title_past),
                                      current_child,
                                      current_user,
                                      nil,
                                      b.category,
                                      nil,
                                      current_user.id,
                                      b
                                    )
      te.is_auto = true
      te.save
    end

    current_user.user_actions.find_or_create_by_title('initial_questionnaire_completed')

    unless current_user.user_emails.find_by_title('initial_questionnaire_completed')
      UserMailer.registration_completed(current_user, current_child, @behaviours.first).deliver if current_user.user_option.subscribed
      current_user.user_emails.create(:title => 'initial_questionnaire_completed')
    end

    if params[:add_child].present?
      redirect_to registration_new_child_path
    else
      redirect_to child_reflect_children_path
    end
  end

end
