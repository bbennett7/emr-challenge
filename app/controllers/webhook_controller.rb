class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def gateway
    # byebug
    source = request.headers['Source']
    @payload = JSON.parse(request.body.string)

    # default structure of objects to build for db persistence 
    @provider_data = { provider_name: nil, street_address: nil, city: nil, state: nil, zip: nil, county: nil, country: nil, phone_number: nil }

    @plan_data = { provider_id: nil, plan_name: nil, id_type: nil, plan_type: nil, provider_plan_id: nil}

    @group_data = { provider_id: nil, plan_id: nil, group_number: nil, group_name: nil }

    @policy_data = { group_id: nil, effective_date: nil, expiration_date: nil, policy_number: nil }

    @member_data = { policy_id: nil, group_id: nil, plan_id: nil, provider_id: nil, member_number: nil, first_name: nil, last_name: nil, ssn_encrypted: nil, date_of_birth: nil, sex: nil, street_address: nil, city: nil, state: nil, zip: nil, county: nil, country: nil}

    # switch case to determine where post request is coming from
    # call handler based on source
    case source.downcase
      when "redox"
        handle_redox_event
      when "cedar sanai"
        puts "cedar sanai"
      when "providence healthcare"
        puts "providence healthcare"
      when "abm healthcare"
        puts "abm healthcare"
      else
        # persists to a redis database of pending data
    end

    # Will need to handle getting relations - like provider ID for plan's provider_id
    # persists variables to db after being assigned correct values, do work to account for typos, mismatches etc

    # respond_to do |format|
    #   msg = { :status => "ok", :message => "Success!" }
    #   format.json { render json: request}
    # end
  end

  def handle_redox_event
    puts "handling redox event"
    plan = @payload["Plan"]
    provider = @payload["Company"]
    provider_address = provider["Address"]
    member = @payload["Insured"]
    member_address = member["Address"]

    # get provider data
    @provider_data = { provider_name: provider["Name"], street_address: provider_address["StreetAddress"], city: provider_address["City"], state: provider_address["State"], zip: provider_address["Zip"], county: provider_address["County"], country: provider_address["Country"], phone_number: provider["PhoneNumber"] }

    # get plan data
    @plan_data = { provider_id: nil, plan_name: plan["Name"], id_type: plan["IDType"], plan_type: plan["Type"], provider_plan_id: plan["ID"]}
    
    # get group data
    @group_data = { provider_id: nil, plan_id: nil, group_number: @payload["GroupNumber"], group_name: @payload["GroupName"] }

    # get policy data
    # manipulate effective date and expiration date
    @policy_data = { group_id: nil, effective_date: @payload["EffectiveDate"].to_datetime, expiration_date: @payload["ExpirationDate"].to_datetime, policy_number: @payload["PolicyNumber"] }

    # get member data
    # encrypt SSN, manipulate DOB
    @member_data = { policy_id: nil, group_id: nil, plan_id: nil, provider_id: nil, member_number: @payload["MemberNumber"], first_name: member["FirstName"], last_name: member["LastName"], ssn_encrypted: nil, date_of_birth: member["DOB"], sex: member["Sex"], street_address: member_address["StreetAddress"], city: member_address["City"], state: member_address["State"], zip: member_address["Zip"], county: member_address["County"], country: member_address["Country"]}

  end

  def create_or_update_provider
    @provider = Provider.new
  end

  def create_or_update_plan
    @plan = Plan.new
  end

  def create_or_update_group
    @group = Group.new
  end
  
  def create_or_update_policy
    @policy = Policy.new
  end

  def create_or_update_member
    @member = Member.new
  end
end
