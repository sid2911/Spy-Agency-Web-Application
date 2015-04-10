class MessageController < ApplicationController
skip_before_filter :verify_authenticity_token
 def list
    if session[:user_id] == nil
  	redirect_to :controller => 'user', :action => 'login'
	flash.now.alert = "You are not logged in." 
    else
	if session[:user_id]
		check("3",session[:user_id]) 
	end
	if(session[:flag] == 1)
    		@messages = Message.where("flag = 1")
	else
		@messages = Message.where("flag = 0")
	end
    end
  end
  
  def add
    if session[:user_id] == nil
  	redirect_to :controller => 'user', :action => 'login' 
		flash[:error1] = "You are not logged in."
    else
	if session[:user_id]
		check("2",session[:user_id]) 
	end
	
	if(session[:flag]==1)
		@messages=Message.new(:title => params[:title], :message => params[:message], :flag => 1)
		@messages.save
	else
		@messages=Message.new(:title => params[:title], :message => params[:message], :flag => 0)
		@messages.save
	end

	unless params[:title] && params[:message]
		flash[:error]="Title or message missing" 
	else
		
        end
 
    end
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
