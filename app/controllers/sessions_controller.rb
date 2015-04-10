class SessionsController < ApplicationController
skip_before_filter :verify_authenticity_token
  def new
  end
  def create
	if session[:user_id]
		check("1",session[:user_id]) 
	end
  	user = User.authenticate(params[:username], params[:password])
  	if user
  	  session[:user_id] = user.id
  	  redirect_to :controller => 'message', :action => 'add' 
  	else
  	  flash[:error] = "Invalid email or password"
  	  redirect_to :controller => 'user', :action => 'login' 
  	end
  end

  def destroy
	@user=User.find_by_id(session[:user_id])
	@user.k=" "
	@user.save
    session[:user_id] = nil
    session[:flag] = nil
    redirect_to :controller => 'user', :action => 'logout' 
  end


  def check(knockval, sessionid)
	@user=User.find_by_id(sessionid)
	temp=" "
	if(@user.count == 0)
		temp=" "
		@user.count = 1
		@user.save
	else 
		temp=@user.k
	end
	
	local_knock=temp + knockval
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
