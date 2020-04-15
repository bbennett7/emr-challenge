class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def gateway
    # byebug
    source = request.headers['Source']
    @body = request.body.first
    
    # default structure of objects to build for db persistence 
    @provider_data = { provider_name: nil, street_address: nil, city: nil, state: nil, zip: nil, county: nil, country: nil, phone_number: nil }

    @plan_data = { provider_id: nil, plan_name: nil, id_type: nil, plan_type: nil, provider_plan_id: nil}

    @group_data = { provider_id: nil, plan_id: nil, group_number: nil, group_name: nil }

    @policy_data = { group_id: nil, effective_date: nil, expiration_date: nil, policy_number: nil }

    @member_data = { policy_id: nil, group_id: nil, plan_id: nil, provider_id: nil, member_number: nil, first_name: nil, last_name: nil, ssn_encrypted: nil, date_of_birth: nil, sex: nil, street_address: nil, city: nil, state: nil, zip: nil, county: nil, country: nil}

    # have each of those functs all call the same one funct to go to the database

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

    # respond_to do |format|
    #   msg = { :status => "ok", :message => "Success!" }
    #   format.json { render json: request}
    # end
  end

  def handle_redox_event
    puts "handling redox event"
    # get provider data

    # get plan data

    # get group data

    # get policy data 

    # get member data

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
