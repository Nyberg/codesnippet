class HolesController < ApplicationController
  before_action :set_hole, only: [:show, :edit, :update, :destroy]
  before_filter :stats

  def stats
    @stats ||= Stats::StatsCommon.new
    @stats
  end

  # GET /holes
  # GET /holes.json
  def index
    @holes = Hole.all
  end

  # GET /holes/1
  # GET /holes/1.json
  def show
    @holes = Hole.where(tee_id: @hole.tee_id).order(:number)
    @graphs = stats.graph_types
    @graph_type = params[:graph] || "spline"
    @data_type = params[:data_type] || "result"
    @course = Course.find(@hole.course_id)
    @tee = Tee.find(@hole.tee_id)

    if @data_type == "user"
      data = Score.hole_result_stats(@hole.id).by_user(current_user.id).group_by_result
      results = stats.get_hole_result_stats(data)
    else
      data = Score.hole_result_stats(@hole.id).group_by_result
      results = stats.get_hole_result_stats(data)
    end

    result_types = stats.get_result_types(data)
    @chart = stats.build_hole_chart(@hole.number, results, @graph_type, result_types)
  end

  # GET /holes/new
  def new
    @hole = Hole.new
  end

  # GET /holes/1/edit
  def edit
  end

  # POST /holes
  # POST /holes.json
  def create
    @hole = Hole.new(hole_params)

    respond_to do |format|
      if @hole.save
        format.html { redirect_to tee_path(@hole.tee_id), notice: 'Hole was successfully created.' }
        format.json { render :show, status: :created, location: @hole }
      else
        format.html { render :new }
        format.json { render json: @hole.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /holes/1
  # PATCH/PUT /holes/1.json
  def update
    respond_to do |format|
      if @hole.update(hole_params)
        format.html { redirect_to @hole, notice: 'Hole was successfully updated.' }
        format.json { render :show, status: :ok, location: @hole }
      else
        format.html { render :edit }
        format.json { render json: @hole.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /holes/1
  # DELETE /holes/1.json
  def destroy
    @hole.destroy
    respond_to do |format|
      format.html { redirect_to holes_url, notice: 'Hole was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hole
      @hole = Hole.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hole_params
      params.require(:hole).permit(:course_id, :number, :par, :length, :tee_id)
    end
end
