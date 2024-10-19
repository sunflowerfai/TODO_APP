class TodosController < ApplicationController
    before_action :set_category
    before_action :set_todo, only: [:update, :destroy, :toggle]
  
    def create
      @todo = @category.todos.new(todo_params)
      if @todo.save
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to @category, notice: 'Todo was successfully created.' }
        end
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    def update
      if @todo.update(todo_params)
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to @category, notice: 'Todo was successfully updated.' }
        end
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @todo.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @category, notice: 'Todo was successfully destroyed.' }
      end
    end
  
    def toggle
      @todo.update(completed: !@todo.completed)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @category }
      end
    end
  
    private
  
    def set_category
      @category = Category.find(params[:category_id])
    end
  
    def set_todo
      @todo = @category.todos.find(params[:id])
    end
  
    def todo_params
      params.require(:todo).permit(:title, :completed)
    end
  end