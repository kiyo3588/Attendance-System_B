class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:show, :edit, :update]
  before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show
  
  def index
    @users = User.all
    if params[:search].present?
      search_keywords = params[:search].split('').join('%') # 一文字ごとに%を追加していく
      search_query = "%#{search_keywords}%"
      @users = @users.where("name LIKE ?", search_query)
      @search_title = "検索結果"
    else
      @search_title = "ユーザー覧"
    end
    @users = @users.paginate(page: params[:page])
  end
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user 
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params) && @user.update(basic_info_params)
       flash[:success] = "ユーザー情報を更新しました。"
       redirect_to @user
    else
       render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
    User.transaction do
      errors = []
      User.find_each do |user|
        unless user.update(basic_info_params)
          errors << user.errors.full_messages.join(", ")
        end
      end

      if errors.empty?
        flash[:success] = "全ユーザーの基本情報を更新しました。"
      else
        flash[:danger] = "基本情報の更新に失敗しました。<br>" + errors.join("<br>")
        raise ActiveRecord::Rollback
      end
  end
    redirect_to users_url
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:department, :basic_time, :work_time)
    end
end
