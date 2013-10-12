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
    debugger
    #restore the ratings settings if all are unchecked
    if(params[:ratings] == {})
      params[:ratings] = session[:ratings]
    end

    
    
    #overwrite all session parameters that were passed in params
    params.each {|elt, value| session[elt] = value}
    
    #clean up params so URL doesn't get crowded
    if(params.keys.length >2)
      flash.keep
      
      redirect_to movies_path
      return
    end
    @all_ratings = Movie.ratings

    #if the session has no stored ratings, set up session[:ratings]
    #this is necessary because the view relies on this for the checkboxes
    if(!session[:ratings])
      session[:ratings] = {}
      @all_ratings.each {|elt| session[:ratings][elt] = nil} 
    end
    
    #sorting by title or release
    if(session.has_key?(:sorting))
    	@movies = Movie.order("#{session[:sorting]}")
    else
	    @movies = Movie.all
    end 

    

    #filtering by rating (there will always be atleast one)
    @ratings = session[:ratings].keys
    @movies = @movies.keep_if{|elem| @ratings.include?(elem.rating)}
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
