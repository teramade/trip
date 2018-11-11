class HomeController < ApplicationController
  def index
    if params[:tag]
      @trips = Trip.tagged_with(params[:tag])
      render action: :index
    else
      @trips = Trip.all.order(created_at: :desc)
    end
  end

  # /tags?tags=京都 奈良
  def tags

    @tags_params = params[:tags]
    
    if @tags_params
      tags = @tags_params.split(' ')
      @trips = Trip.tagged_with(tags)
      render action: :index
    else
      redirect_to action: :index
    end
  end

end
