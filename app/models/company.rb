class Company < ApplicationRecord

  def add_admin(user)
    Employment.create(company: self, user: user, role: :admin)
  end
end
