class ProfileController < ApplicationController

skip_before_action :verify_authenticity_token

def buildTree

end
def index
   @search = Profile.ransack(params[:q])
    @products = @search.result
    @search.build_condition
end

  def create
    #logger.debug "#{params[:fname]"
    @profile = Profile.new
    @profile.userid = params[:userid]
    @profile.fname = params[:fname]
    @profile.lname = params[:lname]
    @profile.familyname = params[:familyname]
    @profile.email = params[:email]
    @profile.mobile = params[:mobile]
    @profile.dob = params[:dob]
    @profile.bloodgroup = params[:bloodgroup]
    @profile.nVillage = params[:nVillage]
    @profile.avatar = params[:avatar]
   #@profile.nTaluka = params[:nThaluka]
    #@profile.nDistrict = params[:nDistrict]
    #@profile.nCity = params[:nCity]
    @profile.nState = params[:nState]
   # @profile.nCountry = params[:nCountry]
    @profile.cVillage = params[:cVillage]
    #@profile.cTaluka = params[:cThaluka]
    #@profile.cDistrict = params[:cDistrict]
    @profile.cCity = params[:cCity]
    @profile.cState = params[:cState]
    @profile.cCountry = params[:cCountry]
    # @profile.fatherFname = params[:fatherFname]
    # @profile.fathermidname = params[:fathermidname]
    # @profile.fatherLname = params[:fatherLname]
    # @profile.motherFname = params[:motherFname]
    # @profile.mothermidname = params[:mothermidname]
    # @profile.mothermidname2 = params[:mothermidname2]
    # @profile.motherknownby = params[:motherknownby]
    # @profile.motherLname = params[:motherLname]
    # @profile.gfatherFname = params[:gfatherFname]
    # @profile.grandfathermidname = params[:grandfathermidname]
    # @profile.gfatherLname = params[:gfatherLname]
    # @profile.gmotherFname = params[:gmotherFname]
    # @profile.grandmothermidname = params[:grandmothermidname]
    # @profile.grandmothermidname2 = params[:grandmothermidname2]
    # @profile.gmotherLname = params[:gmotherLname]
    # @profile.gmknownby = params[:gmknownby]
    # @profile.spouseFname = params[:spouseFname]
    # @profile.spousemidname = params[:spousemidname]
    # @profile.spousemidname2 = params[:spousemidname2]
    # @profile.spouseLname = params[:spouseLname]
    # @profile.kid1fn = params[:kid1fn]
    # @profile.kid1midname = params[:kid1midname]
    # @profile.kid1ln = params[:kid1ln]
    # @profile.k1gender = params[:k1gender]
    # @profile.kid1order = params[:kid1order]
    # @profile.kid1married = params[:kid1married]
    # @profile.kid2fn = params[:kid2fn]
    # @profile.kid2midname = params[:kid2midname]
    # @profile.kid2ln = params[:kid2ln]
    # @profile.k2gender = params[:k2gender]
    # @profile.kid2order = params[:kid2order]
    # @profile.kid2married = params[:kid2married]
    # @profile.sib1fn = params[:sib1fn]
    # @profile.sib1midname = params[:sib1midname]
    # @profile.sib1ln = params[:sib1ln]
    # @profile.sib1order = params[:sib1order]
    # @profile.sib1gender = params[:sib1gender]
    # @profile.sib1married = params[:sib1married]
    # @profile.sib2fn = params[:sib2fn]
    # @profile.sib2midname = params[:sib2midname]
    # @profile.sib2ln = params[:sib2ln]
    # @profile.sib2gender = params[:sib2gender]
    # @profile.sib2order = params[:sib2order]
    # @profile.sib2married = params[:sib2married]


    @profile.save

    redirect_to '/confirm'


  #   @user = User.new(user_params)
  # if User.exists?(email: params[:email]) # I think this should be `user_params[:email]` instead of `params[:email]`
  #   flash[:error] = "User already exists." 
  #   redirect_to 'whereever/you/want/to/redirect' and return
  # end
  # if @user.save
  #   session[:user_id] = user.id
  #   flash[:success] = "New User created."
  #   redirect_to '/layouts/application'
  # else
  #   render 'new'
  # end
  end


  def update_details
    redirect_to '/build_tree'
  end

  def search
        if params[:search].blank?
      @profiles=Profile.all
    else
      @profiles=Profile.search(params[:search])
    end
  end

  def searchProfile

  end

  def addtoProfiles
        @user = User.new
    @user.name = params[:fname]
    @user.email = params[:email]
    @user.mobile = params[:mobile]
    @user.password = "password123"
    @user.password_confirmation = "password123"
    @user.save
    @profile = Profile.new
    db = Mongoid::Clients.default
    collection = db[:pidhi_tree]
    @profile.userid = current_user.id
    @profile.regid = @user.id
    @profile.fname = params[:fname]
    @profile.lname = params[:flastname]
    #@profile.middlename = params[:midname]
    #@profile.familyname = current_user.familyname
   # @profile.otherNames = params[:otherNames]
    @profile.email = params[:email]
    @profile.mobile = params[:mobile]
    @profile.dob = params[:dob]
    @profile.avatar = params[:avatar]
    #@profile.isAlive = params[:living]
    #@profile.childOrder = params[:kid1order]
    @profile.relation_id = params[:relation_id]
    @profile.relation_type = params[:relation_type]
    @profile.save

     relation = params[:relation_type]
      @user_details = Profile.find_by(userid:current_user.id.to_s)
      @cuser = Profile.find_by(fname:params[:fname])
       fathername = @user_details.father_name
    case relation
    when "father"
      Profile.find_by(userid:current_user.id.to_s).set(father_name: params[:fname])
       collection.insert_one({'name':params[:fname],class:"man",extra:{image:@cuser.avatar.url(:thumb)}})
    when "mother"
       collection.update_one({'name': fathername},{"$addToSet": {'marriages': {spouse:{name:params[:fname],class: 'woman',extra:{image:@cuser.avatar.url(:thumb)}}} }})
       collection.update_one({'name': fathername},{"$addToSet": {'marriages.0.children':{ name:  @user_details.fname,class: 'man',extra:{image:@user_details.avatar.url(:thumb)}}}})
    when "brother"
         collection.update_one({'name': fathername},{"$addToSet": {'marriages.0.children':{ name:params[:fname],class: 'man',extra:{image:@cuser.avatar.url(:thumb)}}}})
    when "sister"
      collection.update_one({'name': fathername},{"$addToSet":  {'marriages.0.children':{name:params[:fname],class: 'woman',extra:{image:@cuser.avatar.url(:thumb)}}} })
    when "spouse"
        collection.update_one({'name': fathername},{"$addToSet": {'marriages.0.children.0.marriages': {spouse:{name:params[:fname],class: 'woman',extra:{image:@cuser.avatar.url(:thumb)}} }}})
    when "son"
         collection.update_one({'name': fathername},{"$addToSet": {'marriages.0.children.0.marriages.0.children': {name:params[:fname],class: 'man',extra:{image:@cuser.avatar.url(:thumb)}}} })
    when "daughter"
      collection.update_one({'name': fathername},{"$addToSet": { 'marriages.0.children.0.marriages.0.children': {name:params[:fname],class: 'woman',extra:{image:@cuser.avatar.url(:thumb),profile:@profile.id.to_s} } }})
    else  
         logger.debug "==========No input relation"
    end
    logger.debug "========================Saving data"
    if @profile.save 
      @connection = Connection.new
      @connection.user_id = current_user.id
      @connection.relation_id = params[:relation_id]
      @connection.profile_id = @profile.id
      @connection.save
    end
    redirect_to '/build_tree'
  end

    def getTreeData
      db = Mongoid::Clients.default
      collection = db[:pidhi_tree]
      #doc = collection.find(_id: '5e10698070233f3ef84a8c9b').first
       @user_details = Profile.find_by(userid:current_user.id.to_s)
       fathername = @user_details.father_name
      doc = collection.find('name' => fathername)
      #mother = '{marriages: {spouse:{name: "ddd",class: "woman"}}'
      #relation = 'marriages.0.children' 
      #brother = {name:"kkk",class:"man"}
    #collection.update_one({'name': 'Selvaraj'},{"$addToSet": {'marriages': {spouse:{name: 'ddd',class: 'woman'} }}})
    #collection.insert_one({'name':'Selvaraj',class:"man"})
     logger.debug "data=================#{doc.as_json}"
    respond_to do |format|
      format.html 
      format.json {render json: doc}
    end
  end

end






  # def profile_params
  #   devise_parameter_sanitizer.sanitize(:profile)
  # end
