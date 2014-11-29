class TranslationsController < ApplicationController
  def requests
    @requests = Translation.where(requested: true)
    Activity.log_action(current_user, request.remote_ip.to_s, "posts_translation_requests")
  end
  
  def index
    reset_page
    @translation = Translation.new
    @translations = Translation.where(requested: [nil, false]).reverse.
      # drops first several posts if :feed_page
      drop((session[:page] ? session[:page] : 0) * page_size).
      # only shows first several posts of resulting array
      first(page_size)
    Activity.log_action(current_user, request.remote_ip.to_s, "translations_index")
  end
  
  def edit
    @translation = Translation.find(params[:id])
    Activity.log_action(current_user, request.remote_ip.to_s, "translations_edit", @translation.id)
  end
  
  def update
    @translation = Translation.find(params[:id])
    if @translation.update(params[:translation].permit(:english, :spanish))
      @translation.update(requested: false) if @translation.requested
      flash[:notice] = translate("The translation was successfully updated.")
      Activity.log_action(current_user, request.remote_ip.to_s, "translations_update", @translation.id)
      redirect_to translations_path
    else
      flash[:error] = translate("Invalid input.")
      Activity.log_action(current_user, request.remote_ip.to_s, "translations_update_fail", @translation.id)
      redirect_to :back
    end
  end
  
  def create
    @translation = Translation.new(params[:translation].permit(:english, :spanish))
    if @translation.save
      flash[:notice] = translate("Translation saved successfully.")
      Activity.log_action(current_user, request.remote_ip.to_s, "translations_create", @translation.id)
    else
      flash[:error] = translate("Translation could not be saved.")
      Activity.log_action(current_user, request.remote_ip.to_s, "translations_create_fail")
    end
    redirect_to :back
  end
  
  def destroy
    
  end
end
