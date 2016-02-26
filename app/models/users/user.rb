class User < ActiveRecord::Base
  devise :rememberable, :trackable

  ROLES = {
    STUDENT: :student,
    TEACHER: :teacher,
    ADMINISTRATOR: :administrator
  }

  # Generuje metody User.rola? zo zoznamu roli
  User::ROLES.values.each do |role|
    define_method("#{role}?") do
      self.role == "#{role}"
    end
  end

  has_many :setups_users
  has_many :user_to_lo_relations
  has_many :feedbacks
  has_and_belongs_to_many :setups
  has_many :exercises

  def self.guess_type(login, request)
    # try to find the user in DB (LdapUser/LocalUser) otherwise use LDAP
    u = User.where(login: login.downcase).first
    unless u.nil?
      now = DateTime.now.to_datetime.strftime('%a, %d %b %Y %H:%M:%S')
      logger.info '[INFO] '+ now.to_s + ' DB user ' + login + ' authorization successed from ' + request.remote_ip
    end

    return u ? u.class.model_name.param_key.to_sym : :ldap_user
  end

end
