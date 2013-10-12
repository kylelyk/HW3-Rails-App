class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route  
    begin 
      @movie = Movie.find(id) # look up movie by unique ID
    rescue
      notice = "Movie with id #{id} could not be found."
      flash.keep
      
      redirect_to movies_path
      return
    end
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #restore the ratings settings if all are unchecked
    if(params[:ratings] == {})
      params[:ratings] = session[:ratings]
    end
    
    #overwrite all session parameters that were passed in params
    params.each {|elt, value| session[elt] = value}

    @all_ratings = Movie.ratings
    
    #sorting by title or release
    if(session.has_key?(:sorting))
    	@movies = Movie.order("#{session[:sorting]}")
    else
	    @movies = Movie.all
    end

    #filtering by rating
    if(session.has_key?(:ratings))
      @ratings = session[:ratings].keys
      @movies = @movies.keep_if{|elem| @ratings.include?(elem.rating)}
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    #debugger
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
