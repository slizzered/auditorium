class QuestionsController < ApplicationController
  # load_and_authorize_resource :group
  # load_and_authorize_resource :question, :through => :group
  before_filter :get_group, only: ['new', 'create', 'index']

  def get_group
    @group = Group.find(params[:group_id])
  end

  def index 
    @questions = @group.questions.order(:created_at)
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = @group.questions.build(post_type: 'question')
  end

  def create
    @question = @group.questions.new(params[:question])
    @question.post_type = 'question'
    @question.author = current_user

    respond_to do |format|
      if @question.save!
        format.html { redirect_to @question, notice: t('question.action.created') }
        format.json { render json: @question, status: :created, location: [@group, @question] }
      else
        format.html { render action: 'new' }
        format.json { render json: @question.errors, status: :unprecessable_entity }
      end
    end
  end

  def edit 
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to question_path(@question), flash: { success:  'question was successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action: "edit", flash: { error: "question couldn't be updated!" } }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @group = @question.group
    @question.destroy

    respond_to do |format|
      format.html { redirect_to @group, notice: t('questions.flash.destroyed') }
      format.json { head :no_content }
    end
  end

end