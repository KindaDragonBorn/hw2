 class MoviesController < ApplicationController

  #params[:ratings].nil? ? @ratings = Hash[Movie.all_ratings.map {|v| [v,1]}] : @ratings = params[:ratings]    
  #@movies = Movie.where(rating: @ratings.keys).order(@order)
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    redirect = false

    #Do we have order parameter? If yes we set @ order to it and create a session for this parameter
    if params[:order]
      @order = params[:order]
      session[:order] = params[:order]
    #if we do not have order params lets see if there is a saved session of it
    elsif session[:order]
      @order = session[:order]
      redirect = true
    #if no session and no parameters for order set to nil
    else
      @order = nil
    end

   
    if params[:commit] == "Refresh" and params[:ratings].nil?
      @ratings = nil
      session[:ratings] = nil
    elsif params[:ratings]
      @ratings = params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      @ratings = session[:ratings]
      redirect = true
    else
      @ratings = nil
    end
    
    #flash.keep lets us keep the params from before; Sort of like session but for less time
    if redirect
      flash.keep
      redirect_to movies_path order: @order, ratings: @ratings
    end
    
    if @ratings and @order
      @movies = Movie.where(rating: @ratings.keys).order(@order)
    elsif @order
      @movies = Movie.order(@order)
    elsif @ratings
      @movies = Movie.where(rating: @ratings.keys)
    else
      @movies = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end

  


