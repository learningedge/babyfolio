class Api::V1::SettingsController < ApplicationController
  before_filter :settings_vars
  layout false

  def info
  end

  def family
  end

  def invite
    @invitation_emails = []
    Relation::TYPE_KEYS.each do |k|
      @invitation_emails << {:email => '', :type => k, :error => nil }
    end
 
  end

  def f_and_f

  end


  private

  def settings_vars
    @page = Page.find_by_slug("settings")
    @very_own_family = current_user.get_first_very_own_family

    unless params[:is_about_me]
      @family = current_user.families.find_by_id(params[:family_id])
      @family = current_user.select_first_family unless @family
      @is_admin = @family.is_admin?(current_user)
      @is_family_admin = @very_own_family && @family.id == @very_own_family.id      
    else
      @family = @very_own_family
      @is_family_admin = true if @family
    end
  end


end
