class GroupsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy] 
    def index
        @groups = Group.all
    end
    def new
        @group = Group.new
    end
    def create
        #@group = Group.new(group_params)
        @group = current_user.groups.new(group_params)
        if @group.save then
            current_user.join!(@group)
            redirect_to groups_path
        else
            render :new
        end        
    end
    def show
        @group = Group.find(params[:id])
        @posts = @group.posts
    end
    def edit
        #@group = Group.find(params[:id])
        @group = current_user.groups.find(params[:id])
    end
    def update
        #@group = Group.find(params[:id])
        @group = current_user.groups.find(params[:id])
        if @group.update(group_params) then
            redirect_to groups_path, notice: "修改討論版成功"
        else
            render :edit
        end        
    end
    def destroy
        #@group = Group.find(params[:id])
        @group = current_user.groups.find(params[:id])
        @group.destroy
        redirect_to groups_path, alert: "刪除討論版成功"
    end
    def join
        @group = Group.find(params[:id])
        if !current_user.is_member_of?(@group) then
            current_user.join!(@group)
            flash[:notice] = "加入本討論版成功"
        else
            flash[:warning] = "你已經是本討論版成員了"
        end
        redirect_to group_path(@group)
    end
    def quit
        @group = Group.find(params[:id])
        if current_user.is_member_of?(@group)
            current_user.quit!(@group)
            flash[:alert] = "已退出本討論版"
        else
            flash[:warning] = "你不是本討論版成員，無法退出"
        end
        redirect_to group_path(@group)
    end  
    
    private
    def group_params
        params.require(:group).permit(:title, :description)
    end
end
