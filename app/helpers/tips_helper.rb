module TipsHelper
	def inline_position(top=nil, right=nil, bottom=nil, left=nil)
		position = ""
		if top.present?
			position << "top:#{top}px;"
		elsif bottom.present?
			position << "bottom:#{bottom}px;"
		end
		if right.present?
			position << "right:#{right}px;"
		elsif left.present?
			position << "left:#{left}px;"
		end
		return position
	end
  
  def correct_order? kind
    case kind
    when :welcome
      return true
    when :elheroe_button
      return current_user.tips.exists? kind: :welcome
    when :tab_features_button
      return current_user.tips.exists? kind: :elheroe_button
    end
  end
  
  # shows each tip 5 times per user
  def still_learning? kind
    current_user and current_user.tips.where(kind: kind).size < 5
  end
  
  # checks for privilege if necessary to see tip
  def tip_auth? kind
    case kind
    when :tab_features_button
      return privileged?
    when :welcome, :elheroe_button
    	return current_user
    end
  end
end