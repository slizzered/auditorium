class GroupsController < ApplicationController
	authorize_resource

	def index
		if params[:tag]
			@groups = Group.tagged_with(params[:tag]).order(:title)
		else
			@groups = Group.order(:title)
		end
	end

  def my_groups
    @groups = current_user.groups
  end

	def show
		@group = Group.find(params[:id])

		respond_to do |format|
			format.html
			format.json { render json: @group }
		end
	end

	def new
		@group = Group.new

		respond_to do |format|
			format.html
		end
	end

	def create
		@group = Group.new(params[:group])
		@group.creator = current_user
		
		respond_to do |format|
			if @group.save
				format.html { redirect_to group_path(@group), notice: t('groups.create.success') }
			else
				format.html { render action: :new, error: t('groups.create.failure') }
			end
		end
	end

	def edit
		@group = Group.find(params[:id])
	end

	def update
		@group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to @group, notice: t('groups.update.success') }
        format.json { head :no_content }
      else
        format.html { render action: "edit", error: t('groups.update.failure') }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
	end

	def destroy
		@group = Group.find(params[:id])
		@group.destroy

		respond_to do |format|
			format.html { redirect_to groups_path, notice: t('groups.destroy.success') }
			format.json { head :no_content }
		end
	end

	# for ajax calls
	def change_group_type
		@group = Group.new(group_type: params[:group_type])
		respond_to do |format|
			format.js
		end
	end

	def following
		@group = Group.find(params[:id])
    method = params[:method]

    
		respond_to do |format|	
      if method.eql? 'follow'
        @group.followers << current_user unless @group.followers.include? current_user

        format.html { redirect_to groups_path, flash: { success:  'You now follow the group.' } }
        format.js
      elsif method.eql? 'unfollow' 
        @group.followers.delete current_user if @group.followers.include? current_user

        format.html { redirect_to groups_path, flash: { success:  'You are not follow this group anymore' } }
        format.js
      end
    end
	end

end
