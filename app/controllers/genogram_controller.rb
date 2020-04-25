class GenogramController < ApplicationController

skip_before_action :verify_authenticity_token



  def addtoGenogram
        @user = User.new
    @user.name = params[:fname]
    @user.email = params[:email]
    @user.mobile = params[:mobile]
    @user.password = "password123"
    @user.password_confirmation = "password123"
    @user.save
    #Creating Profile
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
    @profile.save

    #Creating/Adding Family tree
    a = (10000..99999).to_a.shuffle 
    key_value= a.pop
    @genogram = Genogram.new
    db = Mongoid::Clients.default
    @genogram._id = key_value
    @genogram.key = key_value
    @genogram.familyid = params[:familyid]
    @checkInvite = User.find_by(email:params[:email])
    if (@checkInvite)
    @genogram.invite = false
    else
    @genogram.invite = true
    end 
    @genogram.fname = params[:fname]
    @genogram.lname = params[:flastname]
    @genogram.email = params[:email]
    @genogram.mobile = params[:mobile]
    @genogram.dob = params[:dob]
    if params[:relationtype] == 'spouse' && params[:gender] == 'M'
      @genogram.s = 'F'
    elsif params[:relationtype] == 'spouse' && params[:gender] == 'F'
      @genogram.s = 'M'
    else
    @genogram.s = params[:gender]
    end
    @genogram.m = ''
    @genogram.f = ''
    @genogram.ux = []
    @genogram.vir = []
    @genogram.avatar = params[:avatar]
    @genogram.save
    @cuser = Genogram.find_by(_id:@genogram.id.to_i)
    #update image path 
     db[:genograms].update_one({'_id': @genogram.id.to_i},{'$set': {'img': @cuser.avatar.url(:thumb)}},{multi: false})

    if params[:relationtype] == 'father'
    db[:genograms].update_one({'_id': params[:id].to_i},{'$set': {'f': @genogram._id}},{multi: false})
    if params[:m]
      db[:genograms].update_one({'_id': params[:m].to_i},{'$set': {'vir': @genogram._id}},{multi: false})
    end
    end
    if params[:relationtype] == 'mother'
    db[:genograms].update_one({'_id': params[:id].to_i},{'$set': {'m': @genogram._id}},{multi: false})
    if params[:f]
      db[:genograms].update_one({'_id': params[:f].to_i},{'$set': {'ux': @genogram._id}},{multi: false})
    end
    end
    if params[:relationtype] == 'brother'
      db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'f': params[:f]}},{multi: false})
      db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'m': params[:m]}},{multi: false})
    end
    if params[:relationtype] == 'sister'
      db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'f': params[:f]}},{multi: false})
      db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'m': params[:m]}},{multi: false})
    end
    if params[:relationtype] == 'son'
      if params[:rootgender] == 'M'
      db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'f': params[:id]}},{multi: false})
      db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'m': params[:ux]}},{multi: false})
      end
      if params[:rootgender] == 'F'
      db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'f': params[:vir]}},{multi: false})
      db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'m': params[:id]}},{multi: false})
      end
    end
    if params[:relationtype] == 'daughter'
      if params[:rootgender] == 'M'
      db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'f': params[:id]}},{multi: false})
      db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'m': params[:ux]}},{multi: false})
      end
      if params[:rootgender] == 'F'
      db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'f': params[:vir]}},{multi: false})
      db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'m': params[:id]}},{multi: false})
      end
    end
    if params[:relationtype] == 'spouse'
      if @genogram.s == 'M'
     db[:genograms].update_one({'_id': params[:id].to_i},{'$addToSet': {'vir': @genogram._id.to_i}},{multi: false})
     db[:genograms].update_one({'_id': @genogram.id.to_i},{'$addToSet': {'ux': params[:id]}},{multi: false})
   end
   if @genogram.s == 'F'
    db[:genograms].update_one({'_id': params[:id].to_i},{'$addToSet': {'ux': @genogram._id}},{multi: false})
     db[:genograms].update_one({'_id': @genogram.id.to_i},{'$addToSet': {'vir': params[:id]}},{multi: false})
   end
    end
    respond_to do |format|
  format.js {render inline: "location.reload();" }
end
  end
 
   def showTree
    render 'genogram_tree'
  end

  def getGenogramData
      db = Mongoid::Clients.default
      collection = db[:genograms]
      @doc = collection.find(familyid: current_user.familyid.to_s)
    logger.debug "data=================#{@doc}"
    respond_to do |format|
     format.html 
     format.json {render :json =>{:doc => @doc}}
   end
  end
  def updateImage
    db = Mongoid::Clients.default
    avatar = params[:file]
    key = params[:key]
    logger.debug "==============================#{avatar}#{key}"
    @cuser = Profile.find_by(email: params[:email])
    @cuser.update_attributes(avatar: params[:file])
    db[:genograms].update_one({'_id': params[:key].to_i},{'$set': {'img': @cuser.avatar.url(:thumb)}},{multi: false})
     render json: {response: @cuser.avatar.url(:thumb)}
  end
    def edit_field
    db = Mongoid::Clients.default
    name = params[:name]
    value = params[:value]
    id = params[:pk]
     @cuser = Genogram.find_by(key: params[:pk].to_i)
     @cuser.update_attributes(name => params[:value])
    logger.debug "==============================#{name}#{value}#{id}"
     render json: {response: "success"}
  end
end






  # def profile_params
  #   devise_parameter_sanitizer.sanitize(:profile)
  # end
