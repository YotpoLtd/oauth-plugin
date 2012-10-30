require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/oauth_controller_spec_helper'
require 'oauth/client/action_controller_request'

describe OauthClientsController do
  if defined?(Devise)
    include Devise::TestHelpers
  end
  include OAuthControllerSpecHelper
  fixtures :accounts, :oauth_tokens, :users
  before(:each) do
    login_as_application_owner
  end

  describe "index" do
    before do
      @accounts = @user.accounts
    end

    def do_get
      get :index
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should assign accounts" do
      do_get
      assigns[:accounts].should==@accounts
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end
  end

  describe "show" do

    def do_get
      get :show, :id => '1'
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should assign accounts" do
      do_get
      assigns[:account].should==current_client_application
    end

    it "should render show template" do
      do_get
      response.should render_template('show')
    end

  end

  describe "new" do

    def do_get
      get :new
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should assign accounts" do
      do_get
      assigns[:account].class.should==Account
    end

    it "should render show template" do
      do_get
      response.should render_template('new')
    end

  end

  describe "edit" do
    def do_get
      get :edit, :id => '1'
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should assign accounts" do
      do_get
      assigns[:account].should==current_client_application
    end

    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end

  end

  describe "create" do

    def do_valid_post
      post :create, 'client_application'=>{'name' => 'my site', :url=>"http://test.com"}
      @account = Account.last
    end

    def do_invalid_post
      post :create
    end

    it "should redirect to new client_application" do
      do_valid_post
      response.should be_redirect
      response.should redirect_to(:action => "show", :id => @account.id)
    end

    it "should render show template" do
      do_invalid_post
      response.should render_template('new')
    end
  end

  describe "destroy" do

    def do_delete
      delete :destroy, :id => '1'
    end

    it "should destroy client applications" do
      do_delete
      Account.should_not be_exists(1)
    end

    it "should redirect to list" do
      do_delete
      response.should be_redirect
      response.should redirect_to(:action => 'index')
    end

  end

  describe "update" do

    def do_valid_update
      put :update, :id => '1', 'client_application'=>{'name' => 'updated site'}
    end

    def do_invalid_update
      put :update, :id => '1', 'client_application'=>{'name' => nil}
    end

    it "should redirect to show client_application" do
      do_valid_update
      response.should be_redirect
      response.should redirect_to(:action => "show", :id => 1)
    end

    it "should assign accounts" do
      do_invalid_update
      assigns[:account].should == Account.find(1)
    end

    it "should render show template" do
      do_invalid_update
      response.should render_template('edit')
    end
  end
end
