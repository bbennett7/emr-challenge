class PlansController < ApplicationController
  skip_before_action :verify_authenticity_token

  def get_plans
    plans = Plan.where(approved: true)
    plans_data = []

    plans.each do |plan|
      plan_data_obj = {
        plan: plan,
        provider: plan.provider
      }

      plans_data << plan_data_obj
    end

    respond_to do |format|
      res = { :plans =>  plans_data }
      
      format.json { render json: res}
    end
  end

  def get_pending_plans
    pending_plans_data = []
    pending_plans = Plan.where(approved: false)

    pending_plans.each do |plan|
      plan_map = PlanMapper.find_by(plan_id: plan[:id])
      
      plan_data_obj = {
        plan: plan,
        provider: plan.provider,
        source: plan_map[:source_name]
      }

      pending_plans_data << plan_data_obj
    end

    respond_to do |format|
      res = { :pendingPlans =>  pending_plans_data }
      
      format.json { render json: res}
    end
  end

  def update_plan
    id = params[:id]
    payload = JSON.parse(request.body.string)

    plan = Plan.find_by_id(id)
    plan[:plan_name] = payload["plan_name"]
    plan[:plan_type] = payload["plan_type"]
    plan[:approved] = true
    plan.save

    respond_to do |format|
      res = { :plan =>  plan }
      
      format.json { render json: res}
    end
  end

  def delete_plan
    id = params[:id]
    plan = Plan.delete_by(id: id)

    respond_to do |format|
      res = { :plan =>  plan }
      
      format.json { render json: res}
    end
  end
end
