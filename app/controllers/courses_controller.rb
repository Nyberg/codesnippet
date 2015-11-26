class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_filter :stats

  def stats
    @stats ||= Stats::StatsCommon.new
    @stats
  end

  def index
    @courses = Course.all
    @search = params[:term] || nil

    if @search
      @courses = Course.search(@search)
    else
      @courses = @courses.paginate(page: params[:page], per_page: 10 )
    end
  end

  def show
    @course = Course.find(params[:id])
    @page_title = @course.name
    @heading = @course.name
    @tees = @course.tees
  end

  def statistics
    @course = Course.find(params[:id])
    @tees = @course.tees
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = nil
    end

    if params[:tee_id]
      @tee = Tee.find(params[:tee_id])
    else
      @tee = @course.tees.first
    end

    @page_title = t(:Statistics)
    @heading = t(:Statistics)
    @graphs = stats.graph_types
    @graph_type = params[:graph] || "spline"
    @data_type = params[:data_type] || "avg"
    @holes = Hole.where(tee_id: @tee.id)

    numbers = stats.holes(@holes)
    avg = Score.tee_avg(@tee.id)
    avg = stats.tour_part_avg_score(avg)

    if @user
      user_scores = Score.user_tee_avg(@tee.id, @user.id)
      data = stats.tour_part_avg_score(user_scores)
      @chart = stats.tee_line_chart(@tee, numbers, @graph_type, avg, data, @user.name)
    else
      @chart = stats.tee_line_chart(@tee, numbers, @graph_type, avg)
    end
  end

  def new
    @course = Course.new
  end

  def edit
  end

  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_course
      @course = Course.find(params[:id])
    end

    def course_params
      params.require(:course).permit(:name, :content, :club_id, :holes)
    end
end
