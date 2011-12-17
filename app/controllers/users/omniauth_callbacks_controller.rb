class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def action_name
		case params[:action]
			when "facebook"
				data = request.env["omniauth.auth"].extra.raw_info
			   @email = data.email
			when "open_id","google","google_apps" 
				data = request.env["omniauth.auth"].info
				@email = data.email
			when "linkedin"
				data = request.env["omniauth.auth"].extra.raw_info
				@email = data.publicProfileUrl
			when "twitter"
				@email = request.env["omniauth.auth"].info.nickname
				@secret = request.env["omniauth.auth"]['credentials']['secret']
				@token = request.env["omniauth.auth"]['credentials']['token']
		end
		if @user = User.find_by_email(@email)
			@user
		else # Create a user with a stub password. 
			@user = User.new
			@user.email = @email
			if params[:action] == "twitter"
				@user.twitter_oauth_token = @token
				@user.twitter_oauth_secret = @secret
			end
			@user.encrypted_password = Devise.friendly_token[0,20]
			@user.save(:validate => false)  	
		end

		if @user.persisted?
			flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "#{params[:action]}".capitalize
			sign_in_and_redirect @user, :event => :authentication
		else
			session["devise.#{params[:action]}_data"] = request.env["omniauth.auth"]
			redirect_to new_user_registration_url
		end
	end


	  

	 def method_missing(provider)
		 if !User.omniauth_providers.index(provider).nil?
		   #omniauth = request.env["omniauth.auth"]
		   omniauth = env["omniauth.auth"]
		 
		   if current_user #or User.find_by_email(auth.recursive_find_by_key("email"))
		     current_user.user_tokens.find_or_create_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
		      flash[:notice] = "Authentication successful"
		      redirect_to edit_user_registration_path
		   else
		 
		   authentication = UserToken.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
		
		     if authentication
		       flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth['provider']
		       sign_in_and_redirect(:user, authentication.user)
		       #sign_in_and_redirect(authentication.user, :event => :authentication)
		     else
		       
		       #create a new user
		       unless omniauth.recursive_find_by_key("email").blank?
		         user = User.find_or_initialize_by_email(:email => omniauth.recursive_find_by_key("email"))
		       else
		         user = User.new
		       end
		       
		       user.apply_omniauth(omniauth)
		       #user.confirm! #unless user.email.blank?

		       if user.save
		         flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth['provider']
		         sign_in_and_redirect(:user, user)
		       else
		         session[:omniauth] = omniauth.except('extra')
		         redirect_to new_user_registration_url
		       end
		     end
		   end
		 end
	  end

end

