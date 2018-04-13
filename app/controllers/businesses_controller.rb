class BusinessesController < ApplicationController
  before_action :set_business, only: [:show, :edit, :update, :destroy]

  # GET /businesss
  # GET /businesss.json
  def index
    # TODO: replace sort_order with acts_as_votable
    @businesss = Business.all.order("created_at desc")

    respond_to do |format|
      format.html
      format.json { render json: @businesss }
    end

  end

  # GET /businesss/1
  # GET /businesss/1.json
  def show
  end

  # GET /businesss/new
  def new
    @business = Business.new
  end

  # GET /businesss/1/edit
  def edit
  end

  # POST /businesss
  # POST /businesss.json
  def create
    @business = Business.new(business_params)

    respond_to do |format|
      if @business.save
        format.html { redirect_to @business, notice: 'Business was successfully created.' }
        format.json { render :show, status: :created, location: @business }
      else
        format.html { render :new }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /businesss/1
  # PATCH/PUT /businesss/1.json
  def update
    respond_to do |format|
      if @business.update(business_params)
        format.html { redirect_to @business, notice: 'Business was successfully updated.' }
        format.json { render :show, status: :ok, location: @business }
      else
        format.html { render :edit }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /businesss/1
  # DELETE /businesss/1.json
  def destroy
    @business.destroy
    respond_to do |format|
      format.html { redirect_to businesss_url, notice: 'Business was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private ##################################################################################################################################

    # Use callbacks to share common setup or constraints between actions.
    def set_business
      @business = Business.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def business_params
      params.require(:business).permit(:name, :description, :image1, :image2, :hotel_ids => [])
    end
end
