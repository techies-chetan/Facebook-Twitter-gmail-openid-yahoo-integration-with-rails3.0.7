class User < ActiveRecord::Base
  # To use devise-twitter don't forget to include the :twitter_oauth module:
  # e.g. devise :database_authenticatable, ... , :twitter_oauth

  # IMPORTANT: If you want to support sign in via twitter you MUST remove the
  #            :validatable module, otherwise the user will never be saved
  #            since it's email and password is blank.
  #            :validatable checks only email and password so it's safe to remove

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
	has_many :authentications
	validates_uniqueness_of :email
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  



	 def self.new_with_session(params, session)
		 super.tap do |user|
		   if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["user_hash"]
		     user.email = data["email"]
		   end
		   if data = session["devise.twitter_data"] && session["devise.twitter_data"]["extra"]["user_hash"]
		     user.email = data["email"]
		   end
		   if data = session["devise.google_data"] && session["devise.google_data"]["extra"]["user_hash"]
		     user.email = data["email"]
		   end
			 if data = session['devise.googleapps_data'] && session['devise.googleapps_data']['user_info']
				user.email = data['email']
			 end
			 if data = session['devise.linkedin_data'] && session['devise.linkedin_data']['user_info']
				user.email = data['email']
			 end
		 end
	  end  
	
end
