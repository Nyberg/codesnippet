class TeesController < ApplicationController
  before_action :set_tee, only: [:show, :edit, :update, :destroy]

  # GET /tees
  # GET /tees.json
  def index
    @tees = Tee.all
  end

  # GET /tees/1
  # GET /tees/1.json
  def show
  end

  # GET /tees/new
  def new
    @tee = Tee.new
  end

  # GET /tees/1/edit
  def edit
  end

  # POST /tees
  # POST /tees.json
  def create
    @tee = Tee.new(tee_params)

    respond_to do |format|
      if @tee.save
        format.html { redirect_to @tee, notice: 'Tee was successfully created.' }
        format.json { render :show, status: :created, location: @tee }
      else
        format.html { render :new }
        format.json { render json: @tee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tees/1
  # PATCH/PUT /tees/1.json
  def update
    respond_to do |format|
      if @tee.update(tee_params)
        format.html { redirect_to @tee, notice: 'Tee was successfully updated.' }
        format.json { render :show, status: :ok, location: @tee }
      else
        format.html { render :edit }
        format.json { render json: @tee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tees/1
  # DELETE /tees/1.json
  def destroy
    @tee.destroy
    respond_to do |format|
      format.html { redirect_to tees_url, notice: 'Tee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tee
      @tee = Tee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tee_params
      params.require(:tee).permit(:color, :course_id)
    end
end
