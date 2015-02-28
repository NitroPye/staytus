# == Schema Information
#
# Table name: subscribers
#
#  id                 :integer          not null, primary key
#  email_address      :string(255)
#  verification_token :string(255)
#  verified_at        :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Subscriber < ActiveRecord::Base

  validates :email_address, :presence => true, :email => true

  random_string :verification_token, :type => :uuid, :unique => true

  scope :verified, -> { where.not(:verified_at => nil) }

  florrick do
    string :email_address
    string :verification_token
  end

  def verified?
    !!self.verified_at
  end

  def verify!
    self.verified_at = Time.now
    self.save!
  end

  def send_verification_email
    Staytus::Email.deliver(self.email_address, :subscribed, :subscriber => self)
  end

end
