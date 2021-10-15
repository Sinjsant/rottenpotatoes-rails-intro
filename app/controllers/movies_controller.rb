class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
#     puts "referer: #{request.referer}"
#     if "#{URI(request.referer).path.to_s}" == "/movies"
#       session[:movie_params] = params
#     else
#        params[:ratings] = session[:movie_params]['ratings']
#        params[:sort] = session[:movie_params]['sort']
#     end
    

    if params[:sort]
      session[:sort] = params[:sort]
    end
    if params[:ratings]
      session[:ratings] = params[:ratings]
    end
    if !(params[:sort] or params[:ratings]) and (session[:sort] or session[:ratings])
        params[:sort] = session[:sort]
        params[:ratings] = session[:ratings]
    end
    

    # to build the row of checkboxes
    @all_ratings = Movie.all_ratings
    # to persist the checked boxes to the next screen
    @ratings_to_show = params[:ratings] ? params[:ratings].keys : @all_ratings
    # to display the correct movies according to the checkboxes
    @movies = Movie.with_ratings(@ratings_to_show).order(params[:sort])
    #@movies = Movie.order(params[:sort])
    @sort = params[:sort]
    if params[:sort] == "title" 
      @title_header_style = "hilite bg-warning"
    elsif params[:sort] == "release_date"
      @release_header_style = "hilite bg-warning"
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort)
  end
end
