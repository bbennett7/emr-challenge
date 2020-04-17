class PlanMappersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def update_plan_mapper
    payload = JSON.parse(request.body.string)
    plan_mapper= PlanMapper.find_by(plan_id: payload["selected_plan_id"], provider_id: payload["provider_id"])

    plan_mapper[:plan_id] = payload["plan_id"]
    plan_mapper[:provider_id] = payload["provider_id"]
    plan_mapper.save

    respond_to do |format|
      res = { :plan_mapper =>  plan_mapper }
      
      format.json { render json: res}
    end
  end
end
