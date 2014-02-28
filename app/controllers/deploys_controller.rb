class DeploysController < ApplicationController

  before_action :load_stack
  before_action :load_deploy, only: :show
  before_action :load_until_commit, only: :create

  def show
    respond_with(@deploy)
  end

  def create
    @deploy = @stack.trigger_deploy(@until_commit)
    respond_with([@deploy.stack, @deploy])
  end

  private

  def load_deploy
    @deploy = @stack.deploys.find(params[:id])
  end

  def load_stack
    @stack ||= Stack.find(params[:stack_id])
  end

  def load_until_commit
    @until_commit = @stack.commits.find(deploy_params[:until_commit_id])
  end

  def deploy_params
    @deploy_params ||= params.require(:deploy).permit(:until_commit_id)
  end

end
