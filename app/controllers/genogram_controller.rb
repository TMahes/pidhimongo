class GenogramController < ApplicationController

skip_before_action :verify_authenticity_token



  def addtoFamily
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
    a = (100..999).to_a.shuffle 
    b = (1000..1999).to_a.shuffle 
    c = (100..999).to_a.shuffle 
    tag_value = b.pop
    @genogram = Genogram.new
    db = Mongoid::Clients.default
    collectionfamily = db[:genogram]
    @genogram._id = a.pop
    @genogram.familyid = params[:familyid]
    @genogram.sfamilyid = params[:familyid]
    @genogram.fname = params[:fname]
    @genogram.lname = params[:flastname]
    @genogram.email = params[:email]
    @genogram.mobile = params[:mobile]
    @genogram.dob = params[:dob]
    @genogram.gender = params[:gender]
    @genogram.avatar = params[:avatar]
    @genogram.save
    @cuser = Genogram.find_by(_id:@genogram.id.to_i)
    Genogram.where(id: @genogram.id).add_to_set("tags" => tag_value.to_s)
    db[:tags].insert_one('_id':tag_value,'template': 'familyGroupTag')
     db[:genogram].update_one({'_id': @genogram.id.to_i},{'$set': {'img': @cuser.avatar.url(:thumb)}},{multi: false})

    if params[:relationtype] == 'father'
    db[:genogram].update_one({'_id': params[:id].to_i},{'$set': {'pid': @genogram._id}},{multi: false})
    end
    
    if params[:relationtype] == 'mother'
     @spouse = Family.find_by(_id: params[:pid].to_i)
     Family.where(id: @family.id).add_to_set("tags" => @spouse.tags)
     db[:families].update_one({'_id': @family.id.to_i,'tags':tag_value.to_s},{'$set': {'tags.$': @spouse.tags.to_s}},{multi: false})
    end
    if params[:relationtype] == 'brother'
      db[:families].update_one({'_id': @family.id.to_i},{'$set': {'pid': params[:pid]}},{multi: false})
    end
    if params[:relationtype] == 'sister'
      db[:families].update_one({'_id': @family.id.to_i},{'$set': {'pid': params[:pid]}},{multi: false})
    end
    if params[:relationtype] == 'son'
      db[:families].update_one({'_id': @family.id.to_i},{'$set': {'pid': params[:id]}},{multi: false})
    end
    if params[:relationtype] == 'daughter'
      db[:families].update_one({'_id': @family.id.to_i},{'$set': {'pid': params[:id]}},{multi: false})
    end
    if params[:relationtype] == 'spouse'
     @spouse = Family.find_by(_id: params[:id].to_i)
     Family.where(id: @family.id).add_to_set("tags" => @spouse.tags)
     db[:families].update_one({'_id': @family.id.to_i,'tags':tag_value.to_s},{'$set': {'tags.$': @spouse.tags.to_s}},{multi: false})
     db[:families].update_one({'_id': @family.id.to_i},{'$set': {'sfamilyid': c.pop}},{multi: false})
    end
    respond_to do |format|
  format.js {render inline: "location.reload();" }
end
  end
 
   def showTree
    render 'genogram_tree'
  end

      def getFamilyData
      db = Mongoid::Clients.default
      collection = db[:families]
       @user_details = Profile.find_by(userid:current_user.id.to_s)
       fathername = @user_details.father_name
      @doc = collection.find(familyid: current_user.familyid.to_s)
      @tags = db[:tags].find()
      #mother = '{marriages: {spouse:{name: "ddd",class: "woman"}}'
      #relation = 'marriages.0.children' 
      #brother = {name:"kkk",class:"man"}
    #collection.update_one({'name': 'Selvaraj'},{"$addToSet": {'marriages': {spouse:{name: 'dd4d',class: 'man'} }}})
    #collection.update_one({'name': 'selvaraj'},{"$addToSet": {'marriages.0.children.2.marriages': {spouse:{name:'husband',class: 'man' }}}})
    #collection.update_one({'name': fathername},{"$addToSet": {'marriages.0.children.0.marriages.0.children': {name:params[:fname],class: 'man',extra:{image:@cuser.avatar.url(:thumb)}}} })
    #collection.insert_one({'name':'Selvaraj',class:"man"})
   # jso = doc.as_json
    #logger.debug "data=======count==========#{jso.hash['marriages'].count}"
    #format.json  { render :json => {:moulding => @moulding, :material_costs => @material_costs }}
    # logger.debug "data=================#{@doc}"
    #respond_to do |format|
     # format.html 
     # format.json {render :json =>{:doc => @doc, :tags => @tags}}
     render :json =>{:doc => @doc, :tags => @tags}
   # end
  end
  def getFamilyJsonData
      db = Mongoid::Clients.default
      collection = db[:families]
      @user_details = Profile.find_by(userid:current_user.id.to_s)
      fathername = @user_details.father_name
      @doc = collection.find(familyid: current_user.familyid.to_s)
      @tags = db[:tags].find()
      #mother = '{marriages: {spouse:{name: "ddd",class: "woman"}}'
      #relation = 'marriages.0.children' 
      #brother = {name:"kkk",class:"man"}
    #collection.update_one({'name': 'Selvaraj'},{"$addToSet": {'marriages': {spouse:{name: 'dd4d',class: 'man'} }}})
    #collection.update_one({'name': 'selvaraj'},{"$addToSet": {'marriages.0.children.2.marriages': {spouse:{name:'husband',class: 'man' }}}})
    #collection.update_one({'name': fathername},{"$addToSet": {'marriages.0.children.0.marriages.0.children': {name:params[:fname],class: 'man',extra:{image:@cuser.avatar.url(:thumb)}}} })
    #collection.insert_one({'name':'Selvaraj',class:"man"})
   # jso = doc.as_json
    #logger.debug "data=======count==========#{jso.hash['marriages'].count}"
    #format.json  { render :json => {:moulding => @moulding, :material_costs => @material_costs }}
    # logger.debug "data=================#{@doc}"
    #respond_to do |format|
     # format.html 
     # format.json {render :json =>{:doc => @doc, :tags => @tags}}
     render :json =>{:doc => @doc}
   # end
  end
end






  # def profile_params
  #   devise_parameter_sanitizer.sanitize(:profile)
  # end
