class PlansController < ApplicationController
  skip_before_action :verify_authenticity_token

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
      res = { :status => 200, :data => {
        :pendingPlans =>  pending_plans_data
      } }
      format.json { render json: res}
    end
  end
end
