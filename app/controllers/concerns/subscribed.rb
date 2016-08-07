# Ability to vote for something
module Subscribed
  extend ActiveSupport::Concern

  included do
    before_action :set_subscribable, :set_subscription, only: [:subscribe, :unsubscribe]
    authorize_resource
  end

  def subscribe
    flash[:success] = 'You are successfully subscribed'
    redirect_to @question
  end

  def unsubscribe
    @subscription.delete if @subscription
    flash[:success] = 'You are successfully unsubscribed'
    redirect_to @question
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_subscribable
    @subscribable = model_klass.find(params[:id])
    instance_variable_set("@#{controller_name.singularize}", @subscribable)
  end

  def set_subscription
    @subscription = Subscription.find_or_create_by(user: current_user, question: @subscribable)
  end
end