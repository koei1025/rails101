class PostsController < ApplicationController
    before_action :find_group
    before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
    before_action :member_required, only: [:new, :create]
    def new        
        @post = @group.posts.new
    end
    def edit
        #@post = @group.posts.find(params[:id])
        @post = current_user.posts.find(params[:id])
    end
    def create
        @post = @group.posts.build(post_params)
        @post.author = current_user
        if @post.save then
            redirect_to group_path(@group), notice: "新增文章成功~"
        else
            render :new
        end        
    end
    def update
        #@post = @group.posts.find(params[:id])
        @post = current_user.posts.find(params[:id])
        if @post.update(post_params) then 
            redirect_to group_path(@group), notice: "修改文章成功~"
        else
            render :edit
        end        
    end
    def destroy
        #@post = @group.posts.find(params[:id])
        @post = current_user.posts.find(params[:id])
        @post.destroy
        redirect_to group_path(@group), alert: "文章已被刪除！"
    end
    private
    def find_group
        @group = Group.find(params[:group_id])
    end
    def member_required
        if !current_user.is_member_of?(@group) then
            flash[:warning] = "你並不是這個群組的成員，無法發文!!"
            redirect_to group_path(@group)
        end
    end
    def post_params
        params.require(:post).permit(:content)
    end
end
