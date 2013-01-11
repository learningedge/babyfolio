class QuestionSerializer < ActiveModel::Serializer
  attributes :age, :category, :mid, :milestone_title, :text, :parent_tip, :activity_1_title, :activity_2_title

  def text
    original = object.text
    return scope.api_replace_forms(original)
  end

  def parent_tip
    tip = object.milestone.get_parenting_tip
    return scope.api_replace_forms(tip)
  end

  def activity_1_title
    title = object.milestone.activity_1_title
    return scope.api_replace_forms(title)
  end

  def activity_2_title
    title = object.milestone.activity_2_title
    return scope.api_replace_forms(title)
  end

end


