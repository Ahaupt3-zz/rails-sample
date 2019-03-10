# frozen_string_literal: true

class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      ActionCable.server.broadcast "feed_channel",
                                   id: @micropost.id,
                                   userid: @micropost.user.id,
                                   name: @micropost.user.name,
                                   emaildigest: Digest::MD5.hexdigest(@micropost.user.email.downcase),
                                   content:  @micropost.content,
                                   time: @micropost.created_at
    else
      @feed_items = []
      render "static_pages/home"
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

    private

      def get_microposts
        @microposts = micropost.for_display
        @micropost  = current_user.microposts.build
      end

      def micropost_params
        params.require(:micropost).permit(:content, :picture)
      end

      def correct_user
        @micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_url if @micropost.nil?
      end
end
