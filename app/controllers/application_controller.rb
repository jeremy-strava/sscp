class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from ActiveRecord::RecordNotFound,ActionController::RoutingError, 
             ActionController::UnknownController, ActionController::UnknownAction, :with => :rescue_not_found

  protected
  def rescue_not_found
    render :template => 'shared/error'
  end
end
