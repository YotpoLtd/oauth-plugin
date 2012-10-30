require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../oauth_controller_test_helper'
require 'oauth/client/action_controller_request'

class OauthClientsController; def rescue_action(e) raise e end; end

class OauthClientsControllerIndexTest < ActionController::TestCase
  include OAuthControllerTestHelper
  tests OauthClientsController

  def setup
    @controller = OauthClientsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    login_as_application_owner
  end

  def do_get
    get :index
  end

  def test_should_be_successful
    do_get
    assert @response.success?
  end

  def test_should_query_current_users_accounts
    @user.expects(:accounts).returns(@accounts)
    do_get
  end

  def test_should_assign_accounts
    do_get
    assert_equal @accounts, assigns(:accounts)
  end

  def test_should_render_index_template
    do_get
    assert_template 'index'
  end
end

class OauthClientsControllerShowTest < ActionController::TestCase
  include OAuthControllerTestHelper
  tests OauthClientsController

  def setup
    @controller = OauthClientsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    login_as_application_owner
  end

  def do_get
    get :show, :id=>'3'
  end

  def test_should_be_successful
    do_get
    assert @response.success?
  end

  def test_should_query_current_users_accounts
    @user.expects(:accounts).returns(@accounts)
    @accounts.expects(:find).with('3').returns(@account)
    do_get
  end

  def test_should_assign_accounts
    do_get
    assert_equal @account, assigns(:account)
  end

  def test_should_render_show_template
    do_get
    assert_template 'show'
  end

end

class OauthClientsControllerNewTest < ActionController::TestCase
  include OAuthControllerTestHelper
  tests OauthClientsController

  def setup
    @controller = OauthClientsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    login_as_application_owner
    Account.stubs(:new).returns(@account)
  end

  def do_get
    get :new
  end

  def test_should_be_successful
    do_get
    assert @response.success?
  end

  def test_should_assign_accounts
    do_get
    assert_equal @account, assigns(:account)
  end

  def test_should_render_show_template
    do_get
    assert_template 'new'
  end

end

class OauthClientsControllerEditTest < ActionController::TestCase
  include OAuthControllerTestHelper
  tests OauthClientsController

  def setup
    @controller = OauthClientsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    login_as_application_owner
  end

  def do_get
    get :edit, :id=>'3'
  end

  def test_should_be_successful
    do_get
    assert @response.success?
  end

  def test_should_query_current_users_accounts
    @user.expects(:accounts).returns(@accounts)
    @accounts.expects(:find).with('3').returns(@account)
    do_get
  end

  def test_should_assign_accounts
    do_get
    assert_equal @account, assigns(:account)
  end

  def test_should_render_edit_template
    do_get
    assert_template 'edit'
  end

end

class OauthClientsControllerCreateTest < ActionController::TestCase
  include OAuthControllerTestHelper
  tests OauthClientsController

  def setup
    @controller = OauthClientsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    login_as_application_owner
    @accounts.stubs(:build).returns(@account)
    @account.stubs(:save).returns(true)
  end

  def do_valid_post
    @account.expects(:save).returns(true)
    post :create,'client_application'=>{'name'=>'my site'}
  end

  def do_invalid_post
    @account.expects(:save).returns(false)
    post :create,:account=>{:name=>'my site'}
  end

  def test_should_query_current_users_accounts
    @accounts.expects(:build).returns(@account)
    do_valid_post
  end

  def test_should_redirect_to_new_client_application
    do_valid_post
    assert_response :redirect
    assert_redirected_to(:action => "show", :id => @account.id)
  end

  def test_should_assign_accounts
    do_invalid_post
    assert_equal @account, assigns(:account)
  end

  def test_should_render_show_template
    do_invalid_post
    assert_template('new')
  end
end

class OauthClientsControllerDestroyTest < ActionController::TestCase
  include OAuthControllerTestHelper
  tests OauthClientsController

  def setup
    @controller = OauthClientsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    login_as_application_owner
    @account.stubs(:destroy)
  end

  def do_delete
    delete :destroy,:id=>'3'
  end

  def test_should_query_current_users_accounts
    @user.expects(:accounts).returns(@accounts)
    @accounts.expects(:find).with('3').returns(@account)
    do_delete
  end

  def test_should_destroy_accounts
    @account.expects(:destroy)
    do_delete
  end

  def test_should_redirect_to_list
    do_delete
    assert_response :redirect
    assert_redirected_to :action => 'index'
  end

end

class OauthClientsControllerUpdateTest < ActionController::TestCase
  include OAuthControllerTestHelper
  tests OauthClientsController

  def setup
    @controller = OauthClientsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as_application_owner
  end

  def do_valid_update
    @account.expects(:update_attributes).returns(true)
    put :update, :id => '1', 'client_application' => {'name'=>'my site'}
  end

  def do_invalid_update
    @account.expects(:update_attributes).returns(false)
    put :update, :id=>'1', 'client_application' => {'name'=>'my site'}
  end

  def test_should_query_current_users_accounts
    @user.expects(:accounts).returns(@accounts)
    @accounts.expects(:find).with('1').returns(@account)
    do_valid_update
  end

  def test_should_redirect_to_new_client_application
    do_valid_update
    assert_response :redirect
    assert_redirected_to :action => "show", :id => @account.id
  end

  def test_should_assign_accounts
    do_invalid_update
    assert_equal @account, assigns(:account)
  end

  def test_should_render_show_template
    do_invalid_update
    assert_template('edit')
  end
end
