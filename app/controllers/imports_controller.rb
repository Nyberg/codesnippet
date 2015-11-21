class ImportsController < ApplicationController
  include ApplicationHelper
  before_action :set_import, only: [:show, :edit, :update, :destroy]

  def index
    @imports = Import.all
  end

  def show
  end

  def new
    @import = Import.new
  end

  def import_tour_part
    @import = Import.find(params[:id])
    @club = Club.find(@import.club)
    @course = Course.find(@import.course)
    @tee = Tee.find(@import.tee)
    @tour_part = TourPart.create(name: @import.tour_name, course_id: @course.id, tee_id: @tee.id, competition_id: @import.comp_name, date: @import.date)

    sheet = Roo::Spreadsheet.open("#{Rails.public_path}#{@import.import_sheet_url}", extension: :xlsx)
    results = []

    sheet.each_with_index do |row, index|
      results.clear
      total_score = 0
      place = row[0]
      full_name = "#{row[1]} #{row[2]}"
      user = User.where(name: full_name).first
      results << row[3..20]
      results = results.flatten
      score = row[21]
      points = row[22]
      @round = Round.create(user_id: user.id, tour_part_id: @tour_part.id, course_id: @tour_part.course_id, competition_id: @tour_part.competition_id, tee_id: @tour_part.tee_id, total: 20, place: place.to_f, points: points )
      @round.tee.holes.each_with_index do |hole, index|
        num = results[index]
        result_type = get_score(num, hole.par)
        result_id = get_result_id(num, hole.par)
        Score.create(round_id: @round.id, hole_id: hole.id, tee_id: hole.tee_id, user_id: @round.user_id, score: num, tour_part_id: @round.tour_part_id, competition_id: @round.competition_id, result_type: result_type, result_id: result_id)
        total_score = total_score + num
      end
      @round.total = total_score
      @round.save!
    end
    redirect_to admin_tours_path, notice: 'Deltävling importerades utan problem!'
  end

  def edit
  end

  def create
    @import = Import.new(import_params)

    respond_to do |format|
      if @import.save
        format.html { redirect_to "/", notice: 'Din import kommer snart ses över.' }
        format.json { render :show, status: :created, location: @import }
      else
        format.html { render :new }
        format.json { render json: @import.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @import.update(import_params)
        format.html { redirect_to @import, notice: 'Import was successfully updated.' }
        format.json { render :show, status: :ok, location: @import }
      else
        format.html { render :edit }
        format.json { render json: @import.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @import.destroy
    respond_to do |format|
      format.html { redirect_to admin_imports_path, notice: 'Import was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_import
      @import = Import.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def import_params
      params.require(:import).permit(:comp_name, :tour_name, :date, :club, :import_sheet, :course, :tee)
    end
end
