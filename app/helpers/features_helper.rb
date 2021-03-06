module FeaturesHelper
	def tab_feature_defs
		{ invite_attendance: "<b>Event Invites and Attendance</b> - Plan events within your Drop and keep track of who's attending",
		post_repopulation: "<b>Auto Repost</b> - Keep your posts at the top of the feed with repopulation",
		rank_feedback: "<b>Ranking and Feedback</b> - See what people think of you and your content",
		popularity_float: "<b>Popularity Float</b> - Sort posts by the number of likes and comments",
		custom_loading: "<b>Custom Load</b> - Upload your own image for a custom load wheel",
		post_expiration: "<b>Self Destruct</b> - Make sure your post is deleted at an appropriate time",
		sales_dialogue: "<b>Sales Talk</b> - Post items for sale and discuss them with potential buyers",
		question_tree: "<b>Question tree</b> - Ask questions that can branch off to more specific ones",
		invite_only: "<b>By Invite</b> - Make this Drop invitation only",
		list_format: "<b>List View</b> - Get need to know info only, with a more concise format",
		photosets: "<b>Photo Gallery</b> - Post multiple photos to the feed and view them in the gallery",
		articles: "<b>Articles</b> - Write articles specific to your Drop",
		tagged: "<b>Quantum Hash</b> - Specify hashtags to funnel content to your Drop",
		global: "<b>Global</b> - Let anyone in any area see this Drop",
		sports: "<b>Sports</b> - Plan matches and organize teams.",
    polls: "<b>Polls</b> - Anonymous voting and decision making" }
	end
  
  def tab_feature_titles
    titles = {}
    tab_feature_defs.each do |title, definition|
      titles[title] = definition.split("<b>")[1].split("</b>")[0]
    end
    return titles
  end
  
  def user_feature_titles
    titles = { user_feedback: "Ranking and Feedback", photo_gallery: "Photo Gallery" }
    tab_feature_titles.each do |key, title|
      titles[key] = title if [:polls, :custom_loading].include? key
    end
    return titles
  end
  
  def user_has_feature? action
    if @user and current_user.features.exists? action: action
      return true
    else
      return false
    end
  end
  
  def has_any? actions
    if (@tab and @tab.features.where(action: actions).present?) \
      or (@subtab and @subtab.features.where(action: actions).present?)
      return true
    else
      return false
    end
  end
	
  def has_feature? action
    unless action.is_a? Array
      if (@tab and @tab.features.exists? action: action) \
        or (@subtab and @subtab.features.exists? action: action)
        return true
      else
        return false
      end
    else
      has_all = true
      actions = action
      for action in actions
        unless (@tab and @tab.features.exists? action: action) \
          or (@subtab and @subtab.features.exists? action: action)
          has_all = false
        end
      end
      return has_all
    end
  end
end
