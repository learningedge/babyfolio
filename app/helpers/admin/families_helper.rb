module Admin::FamiliesHelper

  def moment_count moments
    count = moments.count
    if count == 0
      "Has no moments."
    elsif count == 1
      "Has 1 moment."
    else
      "Has #{count} moments."
    end
  end

end
