class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def gateway
    @source = request.headers['Source']
    @payload = JSON.parse(request.body.string)

    # default structure of objects to build for db persistence 
    @provider_data = { provider_name: nil, street_address: nil, city: nil, state: nil, zip: nil, county: nil, country: nil, phone_number: nil }

    @plan_data = { provider_id: nil, plan_name: nil, plan_type: nil }

    @group_data = { provider_id: nil, plan_id: nil, group_number: nil, group_name: nil }

    @policy_data = { group_id: nil, effective_date: nil, expiration_date: nil, policy_number: nil }

    @member_data = { policy_id: nil, group_id: nil, plan_id: nil, provider_id: nil, member_number: nil, first_name: nil, last_name: nil, ssn_encrypted: nil, date_of_birth: nil, sex: nil, street_address: nil, city: nil, state: nil, zip: nil, county: nil, country: nil }

    # switch case determines where post request is coming from, calls handler based on source
    case @source.downcase
      when "redox"
        handle_redox_event
      when "providence health"
        handle_providence_event
      when "abm health"
        handle_abm_event
      else
        # persists to a redis database of pending data
    end

    @new_provider = create_or_get_provider

    @plan_data[:provider_id] = @new_provider[:id]
    @new_plan = create_or_get_plan

    @group_data[:provider_id] = @new_provider[:id]
    @group_data[:plan_id] = @new_plan[:id]
    @new_group = create_or_get_group

    @policy_data[:group_id] = @new_group[:id]
    @new_policy = create_or_get_policy

    if @member_data[:member_number] != nil 
      @member_data[:provider_id] = @new_provider[:id]
      @member_data[:plan_id] = @new_plan[:id]
      @member_data[:group_id] = @new_group[:id]
      @member_data[:policy_id] = @new_policy[:id]
      @new_member = create_or_get_member
    else 
      @new_member = @member_data
    end 

    byebug 

    respond_to do |format|
      res = { :status => 200, :data => {
        :provider =>  @new_provider,
        :plan => @new_plan,
        :group => @new_group,
        :policy => @new_policy,
        :member => @new_member
      } }
      format.json { render json: res}
    end
  end

  # returns id of matching object, accounting for nicknames and typos
  def get_object_with_spellcheck(term, table, field, model, and_statement)
    match_id = ActiveRecord::Base.connection.execute("SELECT id FROM #{table} WHERE #{and_statement} (#{field} ILIKE '%#{term}' OR #{field} ILIKE '#{term}%')").values
    match = nil

    if match_id.empty?
      # checks for spelling errors
      # needs additional logic to account for instances of multiple matches - persist to Redis db
      model.all.each do |o|
        if o[:provider_id] == @plan_data[:provider_id]
          mismatch_count = 0
          to_compare = o[field].downcase.split('')
          
          term.downcase.split('').each_with_index do |l, i|
            # accounts for missing letter or extra letter in string
            mismatch_count += 1  if l != to_compare[i] && l != to_compare[i + 1] && l != to_compare[i - 1]
          end
  
          # allows for one letter difference out of every 10 letters in length
          match = o if mismatch_count <= 1 || mismatch_count <= term.length / 10
        end
      end
    else
      match = model.find_by_id(match_id)
    end

    match
  end



  # CREATION METHODS
  def create_or_get_provider
    # removes any additional data separated by characters
    name = @provider_data[:provider_name].split(/[^A-Za-z0-9 ]/).first.strip
    @provider = Provider.find_by provider_name: name

    #if no exact match, checks for match account with spelling errors
    if @provider.nil? || @provider == []
      @provider = get_object_with_spellcheck(name, "providers", "provider_name", Provider, '')
    end

    # if no provider found, creates new Provider
    if @provider.nil? || @provider == []
      @provider = Provider.create(@provider_data)
    end 

    @provider
  end

  def create_or_get_plan
    @plan_mapper = PlanMapper.find_by source_name: @source, source_plan_name: @plan_data[:plan_name], source_plan_id: @plan_data[:source_plan_id]

    and_statement = "source_name = '#{@source}' AND "

    if @plan_mapper.nil? || @plan_mapper == []
      @plan_mapper = get_object_with_spellcheck(@plan_data[:plan_name], "plan_mappers", "source_plan_name", PlanMapper, and_statement)
    end 

    if @plan_mapper.nil? || @plan_mapper == []
      source_plan_id = @plan_data[:source_plan_id]
      @plan_data.delete(:source_plan_id)

      @plan = Plan.create(@plan_data)

      @plan_mapper = PlanMapper.create(plan_id: @plan[:id], provider_id: @provider[:id], source_name: @source, source_plan_name: @plan_data[:plan_name], source_plan_id: source_plan_id)
    end

    @plan = Plan.find_by_id(@plan_mapper[:plan_id])
    @plan
  end

  def create_or_get_group
    name = @group_data[:group_name].split(/[^A-Za-z0-9 ]/).first.strip
    @group = Group.find_by group_name: name

    and_statement = "provider_id = #{@plan_data[:provider_id]} AND "

    if @group.nil? || @group == [] || @group[:provider_id] != @provider[:id]
      @group = get_object_with_spellcheck(name, "groups", "group_name", Group, and_statement)
    end

    if @group.nil? || @group == []
      @group = Group.create(@group_data)
    end

    @group
  end
  
  def create_or_get_policy
    number = @policy_data[:policy_number]
    @policy = Policy.find_by policy_number: number, group_id: @policy_data[:group_id]

    byebug
    if @policy.nil? || @policy == [] 
      @policy = Policy.create(@policy_data)
    end

    @policy
  end

  def create_or_get_member
    ssn_encrypted = @member_data[:ssn_encrypted]
    @member = Member.find_by ssn_encrypted: ssn_encrypted

    and_statement = "member_number = #{@member_data[:member_number]} AND provider_id = #{@member_data[:provider_id]} AND "

    if @member.nil? || @member == []
      @member = get_object_with_spellcheck(ssn_encrypted, "members", "ssn_encrypted", Member, and_statement)
    end

    if @member.nil? || @member == []
      @member = Member.create(@member_data)
    end

    @member
  end



  # SOURCE HANDLERS
  def handle_redox_event
    puts "handling redox event"
    plan = @payload["Plan"]
    provider = @payload["Company"]
    provider_address = provider["Address"]
    member = @payload["Insured"]
    member_address = member["Address"]

    # get provider data
    @provider_data = { provider_name: provider["Name"], street_address: provider_address["StreetAddress"], city: provider_address["City"], state: provider_address["State"], zip: provider_address["ZIP"], county: provider_address["County"], country: provider_address["Country"], phone_number: provider["PhoneNumber"] }

    # get plan data
    @plan_data = { provider_id: nil, plan_name: plan["Name"], plan_type: plan["Type"], source_plan_id: plan["ID"] }
    
    # get group data
    @group_data = { provider_id: nil, plan_id: nil, group_number: @payload["GroupNumber"], group_name: @payload["GroupName"] }

    # get policy data, manipulate effective date and expiration date
    effective_date = @payload["EffectiveDate"].nil? ? nil : @payload["EffectiveDate"].to_datetime
    expiration_date = @payload["ExpirationDate"].nil? ? nil : @payload["ExpirationDate"].to_datetime

    @policy_data = { group_id: nil, effective_date: effective_date, expiration_date: expiration_date, policy_number: @payload["PolicyNumber"] }

    # get member data, encrypt SSN (encryption mechanism needed), manipulate DOB
    dob = member["DOB"].nil? ? nil : member["DOB"].to_datetime

    @member_data = { policy_id: nil, group_id: nil, plan_id: nil, provider_id: nil, member_number: @payload["MemberNumber"], first_name: member["FirstName"], last_name: member["LastName"], ssn_encrypted: member["SSN"], date_of_birth: dob, sex: member["Sex"], street_address: member_address["StreetAddress"], city: member_address["City"], state: member_address["State"], zip: member_address["ZIP"], county: member_address["County"], country: member_address["Country"]}
  end

  def handle_providence_event
    puts "handling providence event"
    @provider_data[:provider_name] = @payload["CompanyName"]

    @plan_data[:plan_name] = @payload["PlanName"]
    @plan_data[:source_plan_id] = @payload["PlanID"]

    @group_data[:group_number] = @payload["GroupNumber"]
    @group_data[:group_name] = @payload["GroupName"]

    @policy_data[:policy_number] = @payload["PolicyNumber"]

    @member_data[:member_number] = @payload["MemberNumber"]
    @member_data[:first_name] = @payload["InsuredFirstName"]
    @member_data[:last_name] = @payload["InsuredLastName"]
    @member_data[:ssn_encrypted] = @payload["InsuredSSN"]
    @member_data[:date_of_birth] = @payload["InsuredDOB"].to_datetime
  end

  def handle_abm_event
    puts "handling abm event"
    account = @payload["account"]

    @provider_data[:provider_name] = @payload["provider_name"]

    @plan_data[:plan_name] = @payload["plan_name"]
    @plan_data[:source_plan_id] = @payload["plan_id"]

    @group_data[:group_number] = @payload["group_number"]
    @group_data[:group_name] = @payload["group_name"]

    @policy_data[:policy_number] = account["policy_number"]

    @member_data[:member_number] = account["account_number"]
    @member_data[:first_name] = account["first"]
    @member_data[:last_name] = account["last"]
    @member_data[:ssn_encrypted] = account["ssn"]
    @member_data[:date_of_birth] = account["date_of_birth"].to_datetime
  end 
end