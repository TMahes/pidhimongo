class BuildTreeController < ApplicationController

skip_before_action :verify_authenticity_token


  def buildTree
=begin @search = Profile.ransack(params[:q])
  @profiles = @search.result
  if params[:q].blank?
    @profiles = Profile.where(:userid => params[:user_id])

end
  end
=end
    session[:conversations] ||= []
    @users = User.all
    @conversations = Conversation.includes(:recipient, :messages)
                                 .find(session[:conversations])
end


  def getTreeData
    #@profiles = Profile.select("id, fname,email, mobile,relation_id").where(:userid => current_user.id) 
     @profile = Profile.find_by(:userid => current_user.id)
     @familyId = @profile.family_id
    @families = Family.select("id,relation_ship_id,relation_profile_id,profile_id,parent_id,level").where(:family_id => @familyId).order( 'level ASC' )

    respond_to do |format|
      format.html 
      format.json {render json: @families}
    end
  end


  def showTree
    
    render 'show_tree'
  end


  def listProfiles

  end

  def viewProfile()
    @profile = Profile.where(:id =>params[:id])
  end

  # def addDetailsssss
  #   #@user_details = Profile.find_by(userid:current_user.id)
  #   @relation = RelationDetail.new
  # #  RelationDetail.new(allowed_params)
  #   @relation.fname = params[:fname]
  #   @relation.lname = params[:flastname]
  #   @relation.mname = params[:midname]
  #   @relation.othername = params[:otherNames]
  #   @relation.email = params[:email]
  #   @relation.mobile = params[:mobile]
  #   @relation.dob = params[:dob]
  #   @relation.bgroup = params[:bloodgroup]
  #   @relation.isalive = params[:living]
  #   @relation.childorder = params[:kid1order]
  #   @relation.relation_id = params[:relation_id]
  #   @relation.user_id = current_user.id
  #   @relation.save
  #   # respond_to do |format|
  #   #       if @comment.save
  #   #         format.html { redirect_to @comment.post, notice: 'Comment was successfully created.' }
  #   #         #format.js   { }
  #   #         #format.json { render :show, status: :created, location: @comment }
  #   #
  #   #       else
  #   #         format.html { render :new }
  #   #         format.json { render json: @comment.errors, status: :unprocessable_entity }
  #   #       end
  #   #     end
  #   respond_to do |format|
  #     format.json {
  #       render :json => RelationDetail.all
  #     }
  #      end
  #   #redirect_to '/build_tree'
  # end

#add relation details of user to profiles table
  def addtoProfiles
    @profile = Profile.new
    @profile.userid = current_user.id
    @profile.fname = params[:fname]
    @profile.lname = params[:flastname]
    #@profile.middlename = params[:midname]
    #@profile.familyname = current_user.familyname
   # @profile.otherNames = params[:otherNames]
    @profile.email = params[:email]
    @profile.mobile = params[:mobile]
    @profile.dob = params[:dob]
    #@profile.isAlive = params[:living]
    #@profile.childOrder = params[:kid1order]
    @profile.relation_id = params[:relation_id]
    @profile.relation_type = params[:relation_type]
    @profile.save

    if @profile.save 
      @connection = Connection.new
      @connection.user_id = current_user.id
      @connection.relation_id = params[:relation_id]
      @connection.profile_id = @profile.id

      @connection.save
    end
    redirect_to '/build_tree'
  end

  def allowed_params
    params.permit(:authenticity_token, :fname, :flastname ,:midname, :othername, :email, :mobile,:dob,:bgroup,:isalive,:childorder,:relation_id)
  end

end
