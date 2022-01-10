require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Example User', email: 'user@example.com',
                     password: 'foobar', password_confirmation: 'foobar')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    # um usuario com o nome vazio nao deve passar nesse teste
    # dessa forma ele nao deve ser valido, se for valido nossos
    # validators estao com problema
    @user.name = '      '
    assert_not @user.valid? # espera que seja false
    # se der true eh pq a validacao nao esta funcionando
  end

  test 'email should be present' do
    @user.email = '      '
    assert_not @user.valid?
  end

  test 'name should not be so long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email should not be so long' do
    @user.email = 'a' * 270
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[luser@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    p valid_addresses
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid? # o teste passa se o duplicate.user nao for valido
  end

  test 'email addresses should be saved as lower-case' do
    mixed_case_email = 'Foo@ExAMPle.CoM'
    # @user is an in-memory ruby object. You set it's email to "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email

    # You persist that objects attributes to the database.
    # The database stores the email as downcase probably due to a database constraint or active record callback.
    @user.save # aqui o callback before_save foi chamado

    # While the database has the downcased email, your in-memory object
    # has not been refreshed with the corresponding values in the database.
    # In other words, the in-memory object @user still has the email "Foo@ExAMPle.CoM".
    # use reload to refresh @user with the values from the database.
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.authenticated?('password', '')
    assert_not @user.authenticated?('remember', '')
    assert_not @user.authenticated?('activation', '')
  end
end
