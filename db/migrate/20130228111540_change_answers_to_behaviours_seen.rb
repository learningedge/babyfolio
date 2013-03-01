class ChangeAnswersToBehavioursSeen < ActiveRecord::Migration
  def up
      categories = {
        "l" => "L",
        "ln" => "N",
        "s" => "S",
        "v" => "V",
        "mv" => "M",
        "e" =>  "E",
        "m" => "MU"
      }

    count = 0;
    Answer.includes(:question).each do |answer|
      question_details = answer.question.mid.split('_')
      behaviour = Behaviour.find_by_age_from_and_category_and_learning_window(question_details[1].to_i, categories[question_details[0]], question_details[2].to_i)
      child = Child.find_by_id(answer.child_id)

      first_family_user_id = nil
      if child && child.family
        first_family_user = child.family.admin_relations.find_by_is_family_admin(true)
        first_family_user ||= child.family.admin_relations.first
        first_family_user ||= child.family.member_relations.first
        first_family_user_id = first_family_user.id if first_family_user
      end
      if child && behaviour
        SeenBehaviour.find_or_create_by_child_id_and_behaviour_id(answer.child_id, behaviour.id, :user_id => first_family_user_id)
      else
        count += 1
      end
    end
    puts "Couldn't find behaviour for #{count} answers/questions"
  end

  def down
  end
end
