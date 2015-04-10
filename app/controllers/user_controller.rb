class UserController < ApplicationController
#skip_before_filter :verify_authenticity_token
  def register
	if session[:user_id]
		check("0",session[:user_id]) 
	end
	@user=User.new
  end

  def login
	if session[:user_id]
		check("1",session[:user_id]) 
	end
  end

  def logout
	if(session[:user_id])
		@user=User.find_by_id(session[:user_id])
		@user.k=" "
		@user.save
	end
    session[:user_id] = nil
    session[:flag] = nil
  end

  def create
	if session[:user_id]
		check("0",session[:user_id]) 
	end	
	name_hash=Digest::MD5.hexdigest(params[:username])
	k1=(name_hash[0].to_i(16))%4
	k2=(name_hash[1].to_i(16))%4
	k3=(name_hash[2].to_i(16))%4
	k4=(name_hash[3].to_i(16))%4
	kval=k1.to_s + k2.to_s + k3.to_s + k4.to_s
  	@user = User.new(:username => params[:username], :password=> params[:password], :knockseq => kval , :count => 0 , :k =>"" )
  	if (params[:password] === params[:password_confirm]) && @user.save
  	  redirect_to :controller => 'user', :action => 'register' 
  	  flash[:notice] = "You have successfully signed up. Cheers!."
  	else
	  if (params[:password] != params[:password_confirm])
		flash[:error1] = "Password and password confirmation don't match."
	  end
	unless @user.save
		flash[:error] = "Username has already been taken!!!" 
	end
  	  redirect_to :controller => 'user', :action => 'register' 
  	end
  end

  def check(knockval, sessionid)
	@user=User.find_by_id(sessionid)
	temp=" "
	if(@user.count == 0)
		temp=""
		@user.count = 1
		@user.save
	else 
		temp=@user.k
	end
	local_knock=temp +  knockval
	if( local_knock.length >=4)
		checkval=local_knock[(local_knock.length-4),(local_knock.length-1)]
		if(@user.knockseq == checkval)
			session[:flag]=1;
		end
	end
	@user.k = local_knock
	@user.save
  end	
	
	
end
