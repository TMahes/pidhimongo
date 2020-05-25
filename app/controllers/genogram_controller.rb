class GenogramController < ApplicationController

skip_before_action :verify_authenticity_token



  def addtoGenogram
=begin    @user = User.new
    @user.name = params[:firstname]
    @user.email = params[:remail]
    @user.mobile = params[:rmobile]
    @user.password = "password123"
    @user.password_confirmation = "password123"
=end
    #Creating Profile
    if Profile.where(email: params[:remail]).exists?
      @profiles = Profile.where(email: params[:remail])
    respond_to do |format|
     #format.html {render '_mailexist', :locals => { :emailexist => true }}
     #format.json {render :json =>{:email => params[:remail]}}
     format.js {render "mailexist" , :locals => {:profiles => @profiles} }
    end
  else
    #@user.save
     @profile = Profile.new
    db = Mongoid::Clients.default
    @profile.userid = current_user.id
    #@profile.regid = @user.id
    @profile.fname = params[:firstname]
    @profile.familyid = params[:familyid]
    @profile.lname = params[:flastname]
    @profile.email = params[:remail]
    @profile.mobile = params[:rmobile]
    @profile.dob = params[:rdob]
    @profile.avatar = params[:avatar]
    @profile.save
    ProfileMailer.with(profile: @profile).welcome_profile.deliver_now
    #Creating/Adding Family tree
    f = (10000..99999).to_a.shuffle 
    m = (100000..999999).to_a.shuffle 
    b = (1000000..9999999).to_a.shuffle 
    fkey_value= f.pop
    mkey_value= m.pop
    bkey_value= b.pop
    @genogram = Genogram.new
    db = Mongoid::Clients.default
    @genogram._id = fkey_value
    @genogram.key = fkey_value
    @genogram.familyid = params[:familyid]
    @checkInvite = User.find_by(email:params[:remail])
    if (@checkInvite)
    @genogram.invite = false
    else
    @genogram.invite = true
    end 
    @genogram.fname = params[:firstname]
    @genogram.lname = params[:flastname]
    @genogram.email = params[:remail]
    @genogram.mobile = params[:rmobile]
    @genogram.sibling = params[:rsibling]
    @genogram.isalive = params[:risalive]
    @genogram.dob = params[:rdob]
    if params[:relationtype] == 'spouse' && params[:gender] == 'M'
      @genogram.s = 'F'
    elsif params[:relationtype] == 'spouse' && params[:gender] == 'F'
      @genogram.s = 'M'
    else
    @genogram.s = params[:gender]
    end
    if @genogram.s == 'M'
       @genogram.fillcolor = '#064666'
    end
    if @genogram.s == 'F' 
       @genogram.fillcolor = '#c36cae'
    end
    if params[:risalive] == 'false'
      @genogram.fillcolor = '#c91515'
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
      db[:genograms].update_one({'_id': params[:m].to_i},{'$addToSet': {'vir': @genogram._id}},{multi: false})
    end
    if params[:m] == ''
      db[:genograms].insert_one('_id': mkey_value.to_i ,familyid: params[:familyid] ,'key': mkey_value.to_i,'fname': 'Unknown','f':'','m':'','s': 'F','vir': [@genogram._id.to_i],'ux': [],'fillcolor': '#c36cae')
      db[:genograms].update_one({'_id': params[:id].to_i},{'$set': {'m': mkey_value}},{multi: false})
      db[:genograms].update_one({'_id': @genogram.id.to_i},{'$addToSet': {'ux': mkey_value}},{multi: false})
    end
    end
    if params[:relationtype] == 'mother'
    db[:genograms].update_one({'_id': params[:id].to_i},{'$set': {'m': @genogram._id}},{multi: false})
    if params[:f]
      db[:genograms].update_one({'_id': params[:f].to_i},{'$addToSet': {'ux': @genogram._id}},{multi: false})
    end
    if params[:f] == ''
      db[:genograms].insert_one('_id': mkey_value.to_i ,familyid: params[:familyid] ,'key': mkey_value.to_i,'fname': 'Unknown','f':'','m':'','s': 'M','ux': [@genogram._id.to_i],'fillcolor': '#064666')
      db[:genograms].update_one({'_id': params[:id].to_i},{'$set': {'f': mkey_value}},{multi: false})
    end
    end
    if params[:relationtype] == 'brother'
      db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'f': params[:f]}},{multi: false})
      db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'m': params[:m]}},{multi: false})
     if params[:f] == ''
      db[:genograms].insert_one('_id': bkey_value.to_i ,familyid: params[:familyid] ,'key': bkey_value.to_i,'fname': 'Unknown','f':'','m':'','s': 'M','ux': [mkey_value.to_i],'vir': [],'fillcolor': '#064666')
      db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'f': bkey_value }},{multi: false})
      db[:genograms].update_one({'_id': params[:id].to_i},{'$set': {'f': bkey_value }},{multi: false})
     end 
     if params[:m] == ''
      db[:genograms].insert_one('_id': mkey_value.to_i ,familyid: params[:familyid] ,'key': mkey_value.to_i,'fname': 'Unknown','f':'','m':'','s': 'F','vir': [bkey_value.to_i],'ux': [],'fillcolor': '#c36cae')
      db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'m': mkey_value}},{multi: false})
      db[:genograms].update_one({'_id': params[:id].to_i},{'$set': {'m': mkey_value}},{multi: false})
     end
    end
    if params[:relationtype] == 'sister'
      db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'f': params[:f]}},{multi: false})
      db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'m': params[:m]}},{multi: false})
     if params[:f] == ''
      db[:genograms].insert_one('_id': bkey_value.to_i ,familyid: params[:familyid] ,'key': bkey_value.to_i,'fname': 'Unknown','f':'','m':'','s': 'M','ux': [mkey_value.to_i],'vir': [],'fillcolor': '#064666')
      db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'f': bkey_value }},{multi: false})
      db[:genograms].update_one({'_id': params[:id].to_i},{'$set': {'f': bkey_value }},{multi: false})
     end 
     if params[:m] == ''
      db[:genograms].insert_one('_id': mkey_value.to_i ,familyid: params[:familyid] ,'key': mkey_value.to_i,'fname': 'Unknown','f':'','m':'','s': 'F','vir': [bkey_value.to_i],'ux': [],'fillcolor': '#c36cae')
      db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'m': mkey_value}},{multi: false})
      db[:genograms].update_one({'_id': params[:id].to_i},{'$set': {'m': mkey_value}},{multi: false})
     end
    end
    if params[:relationtype] == 'son'
      if params[:rootgender] == 'M'
        db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'f': params[:id]}},{multi: false})
          if params[:ux] != ''
          db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'m': params[:ux]}},{multi: false})
          else
          db[:genograms].insert_one('_id': mkey_value.to_i ,familyid: params[:familyid] ,'key': mkey_value.to_i,'fname': 'Unknown','f':'','m':'','s': 'F','vir': [params[:id].to_i],'ux': [],'fillcolor': '#c36cae')
          db[:genograms].update_one({'_id': params[:id].to_i},{'$addToSet': {'ux': mkey_value}},{multi: false})
          db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'m': mkey_value}},{multi: false})
          end
       end
      if params[:rootgender] == 'F'
        db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'m': params[:id]}},{multi: false})
          if params[:vir] != ''
          db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'f': params[:vir]}},{multi: false})
          else
          db[:genograms].insert_one('_id': mkey_value.to_i ,familyid: params[:familyid] ,'key': mkey_value.to_i,'fname': 'Unknown','f':'','m':'','s': 'M','ux': [params[:id].to_i],'vir': [],'fillcolor': '#064666')
          db[:genograms].update_one({'_id': params[:id].to_i},{'$addToSet': {'vir': mkey_value}},{multi: false})
          db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'f': mkey_value}},{multi: false})
          end
       end
    end
    if params[:relationtype] == 'daughter'
      if params[:rootgender] == 'M'
        db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'f': params[:id]}},{multi: false})
          if params[:ux] != ''
          db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'m': params[:ux]}},{multi: false})
          else
          db[:genograms].insert_one('_id': mkey_value.to_i ,familyid: params[:familyid] ,'key': mkey_value.to_i,'fname': 'Unknown','f':'','m':'','s': 'F','vir': [params[:id].to_i],'ux': [],'fillcolor': '#c36cae')
          db[:genograms].update_one({'_id': params[:id].to_i},{'$addToSet': {'ux': mkey_value}},{multi: false})
          db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'m': mkey_value}},{multi: false})
          end
       end
      if params[:rootgender] == 'F'
        db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'m': params[:id]}},{multi: false})
          if params[:vir] != ''
          db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'f': params[:vir]}},{multi: false})
          else
          db[:genograms].insert_one('_id': mkey_value.to_i ,familyid: params[:familyid] ,'key': mkey_value.to_i,'fname': 'Unknown','f':'','m':'','s': 'M','ux': [params[:id].to_i],'vir': [],'fillcolor': '#064666')
          db[:genograms].update_one({'_id': params[:id].to_i},{'$addToSet': {'vir': mkey_value}},{multi: false})
          db[:genograms].update_one({'_id': @genogram._id.to_i},{'$set': {'f': mkey_value}},{multi: false})
          end
       end
    end
    if params[:relationtype] == 'spouse'
      if @genogram.s == 'M'
     db[:genograms].update_one({'_id': params[:id].to_i},{'$addToSet': {'vir': @genogram._id}},{multi: false})
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
 end

   def showTree
    render 'genogram_tree'
  end
  def readonlygenogram
     respond_to do |format|
    format.html {render "readonly_genogram" , :locals => {:familyid => params[:familyid]} }
  end
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
  def readonlygenogramData
    db = Mongoid::Clients.default
      collection = db[:genograms]
      @doc = collection.find(familyid: params[:familyid].to_s)
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
     if name == "isalive" && value == "false"
      @cuser.update_attributes(fillcolor: '#c91515')
     end
     if name == "isalive" && value == "true"
     if @cuser.s == 'M'
      @cuser.update_attributes(fillcolor: '#064666')
       elsif @cuser.s =='F'
        @cuser.update_attributes(fillcolor: '#c36cae')
    end
     end
    logger.debug "==============================#{name}#{value}#{id}"
     render json: {response: "success"}
  end
  def deleteDocument
    db = Mongoid::Clients.default
    key = params[:key]
    @cuser = Genogram.find_by('_id': key.to_i)
   
    @cuser.vir.each do |p|
       db[:genograms].update_one({'_id': p.to_i},{'$pull': {'ux': key}})
     end
    #db[:genograms].delete_one({'_id': key.to_i});

    render json: {response: "success"}
  end
end






  # def profile_params
  #   devise_parameter_sanitizer.sanitize(:profile)
  # end
