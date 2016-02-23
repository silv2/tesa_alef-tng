class ExercisesController < ApplicationController
  load_and_authorize_resource
  def show
    @setup= Setup.take
    @exercise = Exercise.find_by_id(params[:id])
  end

  def refresh
    unless params[:id].blank?
      @counter = UserToLoRelation.where(exercise_id: params[:id]).group(:user_id).count.count
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    if(params[:stats])
      redirect_to statistics_path(id: @exercise.id)
    else
      if(!@exercise.real_start)
        @exercise.real_start = Time.current
      elsif(!@exercise.real_end)
        @exercise.real_end = Time.current
      else
        @exercise.real_end = nil
      end
      respond_to do |format|
        if @exercise.update(exercise_params)
          format.html { redirect_to @exercise}
          format.json { head :no_content }
        end
      end
    end

  end

  private

  def exercise_params
    params.require(:exercise).permit(:start, :user_id, :week_id, :code)
  end

end
