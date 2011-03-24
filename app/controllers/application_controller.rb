class ApplicationController < ActionController::Base
  protect_from_forgery

  def meshcomplete
    items = MeshEntryTerm.autocomplete(params[:term])
    render :json => items
  end
end
