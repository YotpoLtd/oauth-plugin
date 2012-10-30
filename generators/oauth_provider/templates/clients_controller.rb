class OauthClientsController < ApplicationController
  before_filter :login_required
  before_filter :get_client_application, :only => [:show, :edit, :update, :destroy]
  
  def index
    @accounts = current_user.accounts
    @tokens = current_user.tokens.find :all, :conditions => 'oauth_tokens.invalidated_at is null and oauth_tokens.authorized_at is not null'
  end

  def new
    @account = Account.new
  end

  def create
    @account = current_user.accounts.build(params[:account])
    if @account.save
      flash[:notice] = "Registered the information successfully"
      redirect_to :action => "show", :id => @account.id
    else
      render :action => "new"
    end
  end
  
  def show
  end

  def edit
  end
  
  def update
    if @account.update_attributes(params[:account])
      flash[:notice] = "Updated the client information successfully"
      redirect_to :action => "show", :id => @account.id
    else
      render :action => "edit"
    end
  end

  def destroy
    @account.destroy
    flash[:notice] = "Destroyed the client application registration"
    redirect_to :action => "index"
  end
  
  private
  def get_client_application
    unless @account = current_user.accounts.find(params[:id])
      flash.now[:error] = "Wrong application id"
      raise ActiveRecord::RecordNotFound
    end
  end
end
