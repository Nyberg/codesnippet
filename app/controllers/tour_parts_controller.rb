class TourPartsController < ApplicationController
  before_action :set_tour_part, only: [:show, :edit, :update, :destroy]

  # GET /tour_parts
  # GET /tour_parts.json
  def index
    @tour_parts = TourPart.all
  end

  # GET /tour_parts/1
  # GET /tour_parts/1.json
  def show
  end

  # GET /tour_parts/new
  def new
    @tour_part = TourPart.new
  end

  # GET /tour_parts/1/edit
  def edit
  end

  # POST /tour_parts
  # POST /tour_parts.json
  def create
    @tour_part = TourPart.new(tour_part_params)

    respond_to do |format|
      if @tour_part.save
        format.html { redirect_to @tour_part, notice: 'Tour part was successfully created.' }
        format.json { render :show, status: :created, location: @tour_part }
      else
        format.html { render :new }
        format.json { render json: @tour_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tour_parts/1
  # PATCH/PUT /tour_parts/1.json
  def update
    respond_to do |format|
      if @tour_part.update(tour_part_params)
        format.html { redirect_to @tour_part, notice: 'Tour part was successfully updated.' }
        format.json { render :show, status: :ok, location: @tour_part }
      else
        format.html { render :edit }
        format.json { render json: @tour_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tour_parts/1
  # DELETE /tour_parts/1.json
  def destroy
    @tour_part.destroy
    respond_to do |format|
      format.html { redirect_to tour_parts_url, notice: 'Tour part was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour_part
      @tour_part = TourPart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tour_part_params
      params.require(:tour_part).permit(:name, :content, :course_id, :competition_id, :tee_id)
    end
end
