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
    logger.debug "Profileeeeee #{@profile.email}"

    @profile.save
    # Tell the UserMailer to send a welcome email after save
    a = (1000..9999).to_a.shuffle 
    key_value = a.pop
    @genogram = Genogram.new
    db = Mongoid::Clients.default
    collectionfamily = db[:genogram]
    @genogram._id = key_value
    @genogram.key = key_value
    @genogram.familyid = a.pop.to_s
    @genogram.fname = params[:fname]
    @genogram.lname = params[:lname]
    @genogram.email = params[:email]
    @genogram.mobile = params[:mobile]
    @genogram.dob = params[:dob]
    @genogram.s = params[:gender]
    if @genogram.s == 'M'
       @genogram.fillcolor = '#064666'
    end
    if @genogram.s == 'F' 
       @genogram.fillcolor = '#c36cae'
    end
    if params[:risalive] == 'false'
      @genogram.fillcolor = '#c91515'
    end
    @genogram.f = ''
    @genogram.m = ''
    @genogram.ux = []
    @genogram.vir = []
    @genogram.avatar = params[:avatar]
    @genogram.save
    UserMailer.with(genogram: @genogram).welcome_email.deliver_now
    @cuser = Genogram.find_by(_id:@genogram.id)
    logger.debug "666666666666666666666666666#{@cuser.email}"
    db[:genograms].update_one({'_id': @genogram.id},{'$set': {'img': @cuser.avatar.url(:thumb)}},{multi: false})
    db[:users].update_one({'_id': current_user.id},{'$set': {'familyid': @genogram.familyid.to_s }},{multi: false})
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
    redirect_to '/genogram_tree'
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
    @profile = Profile.new
    db = Mongoid::Clients.default
    collection = db[:pidhi_tree]
    @profile.userid = current_user.id
    @profile.regid = @user.id
    @profile.fname = params[:fname]
    @profile.lname = params[:flastname]
    @profile.email = params[:email]
    @profile.mobile = params[:mobile]
    @profile.dob = params[:dob]
    @profile.avatar = params[:avatar]
    @profile.relation_id = params[:relation_id]
    @profile.relation_type = params[:relation_type]
    @profile.save

    respond_to do |format|
  format.js {render inline: "location.reload();" }
end
  end

    def getTreeData
      db = Mongoid::Clients.default
      collection = db[:pidhi_tree]
       @user_details = Profile.find_by(userid:current_user.id.to_s)
       fathername = @user_details.father_name
      doc = collection.find('name' => fathername)
      #mother = '{marriages: {spouse:{name: "ddd",class: "woman"}}'
      #relation = 'marriages.0.children' 
      #brother = {name:"kkk",class:"man"}
    #collection.update_one({'name': 'Selvaraj'},{"$addToSet": {'marriages': {spouse:{name: 'dd4d',class: 'man'} }}})
    #collection.update_one({'name': 'selvaraj'},{"$addToSet": {'marriages.0.children.2.marriages': {spouse:{name:'husband',class: 'man' }}}})
    #collection.update_one({'name': fathername},{"$addToSet": {'marriages.0.children.0.marriages.0.children': {name:params[:fname],class: 'man',extra:{image:@cuser.avatar.url(:thumb)}}} })
    #collection.insert_one({'name':'Selvaraj',class:"man"})
   # jso = doc.as_json
    #logger.debug "data=======count==========#{jso.hash['marriages'].count}"
    
     logger.debug "data=================#{2.times.collect { 'hi' }.join('.')}"
    respond_to do |format|
      format.html 
      format.json {render json: doc}
    end
  end

end






  # def profile_params
  #   devise_parameter_sanitizer.sanitize(:profile)
  # end
