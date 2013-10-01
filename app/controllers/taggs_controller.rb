class TaggsController < ApplicationController
  # GET /taggs
  # GET /taggs.json
  def index
    @taggs = Tagg.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @taggs }
    end
  end

  # GET /taggs/1
  # GET /taggs/1.json
  def show
    @tagg = Tagg.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tagg }
    end
  end

  # GET /taggs/new
  # GET /taggs/new.json
  def new
    @tagg = Tagg.new
    @tagg.post_id = params[:id]
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tagg }
    end
  end

  # GET /taggs/1/edit
  def edit
    @tagg = Tagg.find(params[:id])
  end

  # POST /taggs
  # POST /taggs.json
  def create
    if params["theme"].eql? "Existing Tags"
      @temp = Tagg.find(params[:tagg][:id])
      params[:tagg][:name] = @temp.name
    end

    @tagg = Tagg.new(params[:tagg])
    @tagg.post_id = params["post_id"]
    @post = Post.find(params["post_id"])


    respond_to do |format|
      @arr = Tagg.where( "post_id = ? AND name = ?", params["post_id"], params[:tagg][:name] )
      if @arr.empty?
        if @tagg.save
          format.html { redirect_to @post, notice: 'Tag was successfully created.' }
          format.json { render json: @post, status: :created, location: @post }
        else
          format.html { render action: "new" }
          format.json { render json: @tagg.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @post, notice: 'Tag already exists.' }
        format.json { render json: @post, status: :created, location: @post }
      end
    end
  end

  # PUT /taggs/1
  # PUT /taggs/1.json
  def update
    @tagg = Tagg.find(params[:id])

    respond_to do |format|
      if @tagg.update_attributes(params[:tagg])
        format.html { redirect_to @tagg, notice: 'Tag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tagg.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /taggs/1
  # DELETE /taggs/1.json
  def destroy
    @tagg = Tagg.find(params[:id])
    @tagg.destroy

    respond_to do |format|
      format.html { redirect_to taggs_url }
      format.json { head :no_content }
    end
  end
end
