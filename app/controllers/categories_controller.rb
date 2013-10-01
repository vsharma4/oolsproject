class CategoriesController < ApplicationController
  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.json
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      #checks to disallow naming a category as anonymous
      if @category.category =~ /^anonymous$/i
        @category.errors.add(:category,"-anonymous is a reserved category")
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      else
        if @category.save
          format.html { redirect_to @category, notice: 'Category was successfully created.' }
          format.json { render json: @category, status: :created, location: @category }
        else
          format.html { render action: "new" }
          format.json { render json: @category.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.json
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category = Category.find(params[:id])
    anon = Category.find_by_category("anonymous")

    ###### Update related Posts ######
    temp = Post.find_all_by_category_id(@category.id)
    temp.each do |post|
      post.category_id = anon.id
      post.save
    end
    respond_to do |format|
      if @category.destroy
        format.html { redirect_to categories_path, notice: 'Category was successfully deleted.' }
        format.json { head :no_content }
      else
        format.html { redirect_to categories_path, notice: "-Category couldn't be deleted." }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end
end
