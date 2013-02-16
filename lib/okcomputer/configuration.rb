module OKComputer
  # Public: Configure HTTP Basic authentication
  #
  # username - Username required to view checks
  # password - Password required to view checks
  def self.require_authentication(username, password)
    self.username = username
    self.password = password
  end

  # attr_accessor isn't doing what I want inside a module, so here we go.

  # Public: The username configured for access to checks
  def self.username
    @username
  end

  # Private: Configure the username to access checks
  def self.username=(username)
    @username = username
  end
  private_class_method :username=

  # Public: The password configured for access to checks
  def self.password
    @password
  end

  # Private: Configure the password to access checks
  def self.password=(password)
    @password = password
  end
  private_class_method :password=
end
