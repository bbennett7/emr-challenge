class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def gateway
    # byebug
    source = request.headers['Source']
    @body = request.body.first

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
