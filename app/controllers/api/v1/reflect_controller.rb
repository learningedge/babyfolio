class Api::V1::ReflectController < ApplicationController
  layout false
  before_filter :require_user

  def show
    @page = Page.find_by_slug("reflect")
    seen_behaviours = current_child.max_seen_by_cat

    uniq_ages = seen_behaviours.map{ |b| b.age_from }.uniq.sort
    @lengths = Hash.new
    if uniq_ages.size == 1
      @lengths[uniq_ages[0]] = 125
    else
      uniq_ages.each_with_index.map { |i, index| @lengths[i] =  200/(uniq_ages.size).to_f * (index +1) }
    end    

    @avg_answers = seen_behaviours

    @empty_answers = []
    Behaviour::CATEGORIES_ORDER.each do |cat|      
      @empty_answers << cat unless seen_behaviours.any?{|sb| sb.category == cat}
    end

    if false && @avg_answers.first.age_from != @avg_answers.last.age_from
      @weak_answers = [@avg_answers.pop]
      @str_answers = [@avg_answers.shift]
    else
      @weak_answers = Array.new
      @str_answers = Array.new
    end    

    @str_text = current_child.replace_forms("
                  <h4><WTitle>: #{current_child.first_name}'s Most Important <INTELLIGENCE> Development</h4>
                  <p>Current Strength - <span class='bold'>#{current_child.first_name}</span> is developing more quickly at <INTELLIGENCE> development based on the actual behaviors #he/she# has already exhibited. Continue to strengthen this strength.</p>
                  <p>TIP: Recently <span class='bold'>#{current_child.first_name}</span> <WTitlePast>. Watch for this behavior and exercise it as much as possible. Here is a parenting tip to take advantage of this \"Learning Window\" and help build a strong <INTELLIGENCE> foundation:</p>
                  <p><PTip></p>
                  <p><ParentingTip></p>
                  <h5>Here are specific examples and play activities we recommend:</h5>")
      
    @avg_text = current_child.replace_forms("
                  <h4><WTitle>: #{current_child.first_name}'s Most Important <INTELLIGENCE> Development</h4>
                  <p>TIP: Recently <span class='bold'>#{current_child.first_name}</span> <WTitlePast>. So watch for this behavior and exercise it as much as possible. Here is a parenting tip to take advantage of this \"Learning Window\" and help build a strong <INTELLIGENCE> foundation:</p>
                  <p><PTip></p>
                  <h5>Here are specific examples and play activities we recommend:</h5>")

    @weak_text = current_child.replace_forms("
                  <h4><WTitle>: #{current_child.first_name}'s Most Important <INTELLIGENCE> Development</h4>
                  <p>Current Area for Improvement: <span class='bold'>#{current_child.first_name}</span> is developing less quickly in <INTELLIGENCE> development based on the actual behaviors #he/she# has already exhibited. Development naturally spurts and lags in all areas. Keep watching for opportunities to bolster #his/her# <INTELLIGENCE> development.</p>
                  <p>TIP: Recently <span class='bold'>#{current_child.first_name}</span> <WTitlePast>. So watch for this behavior and exercise it as much as possible. Here is a parenting tip to take advantage of this \"Learning Window\" and help build a strong <INTELLIGENCE> foundation:</p>
                  <p><PTip></p>
                  <h5>Here are specific examples and play activities we recommend:</h5>")

    @reflect_visited = current_user.done_action?('reflect_visited')
    current_user.do_action!('reflect_visited')

    @cat = params[:cat].downcase
    cat_behaviours = seen_behaviours.select{ |b| b.category.downcase == @cat }
    @behaviour = cat_behaviours.first

    if @str_answers.include? @answer
      @type = "str"
    elsif @weak_answers.include? @answer
      @type = "weak"
    elsif @empty_answers.include? @answer
      @type = "empty"
    else
      @type = "avg"
    end

  end

=begin
  def show

    categorized_qs = current_child.max_seen_by_category.group_by{|q| q.category}
    categorized_qs.each do |k,v|
      categorized_qs[k] = v.first
    end

    uniq_ages = categorized_qs.map{ |k,v| v.age }.uniq.sort
    @lengths = Hash.new
    if uniq_ages.size == 1
      @lengths[uniq_ages[0]] = 125
    else
      uniq_ages.each_with_index.map { |i, index| @lengths[i] =  200/(uniq_ages.size).to_f * (index +1) }
    end

    first_str = categorized_qs.values[0]
    last_weak = categorized_qs.values[-1]
    
    @str_answers = categorized_qs.reject{ |k,v| v.age != first_str.age } unless first_str.nil?
    @weak_answers = categorized_qs.reject{ |k,v| v.age != last_weak.age } unless last_weak.nil?
    @avg_answers = categorized_qs
    @avg_answers = categorized_qs.reject{|k,v| @str_answers.keys.include?(k)} if @str_answers.present?
    @avg_answers = @avg_answers.reject{|k,v| @weak_answers.keys.include?(k)} if @weak_answers.present?

    @empty_answers = ActiveSupport::OrderedHash.new
    Question::CATS.each do |k,v|
      @empty_answers[k] = nil if categorized_qs[k].nil?
    end
    
    @str_text = current_child.replace_forms("
                  <h4><WTitle>: #{current_child.first_name}'s Most Important <INTELLIGENCE> Development</h4>
                  <p>Current Strength - #{current_child.first_name} is developing more quickly at <INTELLIGENCE> development based on the actual behaviors #he/she# has already exhibited. Continue to strengthen this strength.</p>
                  <p>TIP: Recently #{current_child.first_name} <WTitlePast>. Watch for this behavior and exercise it as much as possible. Here is a parenting tip to take advantage of this \"Learning Window\" and help build a strong <INTELLIGENCE> foundation:</p>
                  <p><PTip></p>
                  <p><ParentingTip></p>
                  <h5>Here are specific examples and play activities we recommend:</h5>")
      
    @avg_text = current_child.replace_forms("
                  <h4><WTitle>: #{current_child.first_name}'s Most Important <INTELLIGENCE> Development</h4>
                  <p>TIP: Recently #{current_child.first_name} <WTitlePast>. So watch for this behavior and exercise it as much as possible. Here is a parenting tip to take advantage of this \"Learning Window\" and help build a strong <INTELLIGENCE> foundation:</p>
                  <p><PTip></p>
                  <h5>Here are specific examples and play activities we recommend:</h5>")

    @weak_text = current_child.replace_forms("
                  <h4><WTitle>: #{current_child.first_name}'s Most Important <INTELLIGENCE> Development</h4>
                  <p>Current Area for Improvement: #{current_child.first_name} is developing less quickly in <INTELLIGENCE> development based on the actual behaviors #he/she# has already exhibited. Development naturally spurts and lags in all areas. Keep watching for opportunities to bolster #his/her# <INTELLIGENCE> development.</p>
                  <p>TIP: Recently #{current_child.first_name} <WTitlePast>. So watch for this behavior and exercise it as much as possible. Here is a parenting tip to take advantage of this \"Learning Window\" and help build a strong <INTELLIGENCE> foundation:</p>
                  <p><PTip></p>
                  <h5>Here are specific examples and play activities we recommend:</h5>")


    @cat = params[:cat]
    @answer = categorized_qs[params[:cat]]

    if @str_answers.keys.include? @cat
      @type = "strong"
    elsif @weak_answers.keys.include? @cat
      @type = "weak"
    else
      @type = "average"
    end
  end
=end

end

