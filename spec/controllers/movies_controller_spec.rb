require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
   it 'should call the model method that performs TMDb search' do
      fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
    it 'should select the Search Results template for rendering' do
      allow(Movie).to receive(:find_in_tmdb).and_call_original
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(response).to render_template('search_tmdb')
    end  
    it 'should make the TMDb search results available to that template' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(assigns(:movies)).to eq(fake_results)
    end 
    it 'should show a flash message when the search terms are emtpy' do
      post :search_tmdb, {:search_terms => ''}
      expect(flash[:notice]).to eq('Invalid search term')
      expect(response).to redirect_to(movies_path)
    end
    it 'should show a flash message when the movie doesn\'t exist' do
      post :search_tmdb, {:search_terms => 'bviqoqoidfhfaasl,gnhgboqo'}
      expect(flash[:notice]).to eq('No matching movies were found on TMDb')
      expect(response).to redirect_to(movies_path)
    end
  end
  
  
  describe 'adding to Rotten Potatoes' do
    it 'should call the model method that creates from tmdb' do
      fake_results = [double('movie')]
      allow(Movie).to receive(:create_from_tmdb).with('941').
        and_return(fake_results)
      post :add_tmdb, {:checkbox => {'941':'1'}}
    end
    it 'should redirect to home page when submit button is hit' do
      post :add_tmdb
      expect(response).to redirect_to movies_path
    end
    it 'should successfully add movies and redirect to home page' do
        fake_results = {double("key") => 1, double("key") => 1}
        allow(Movie).to receive(:create_from_tmdb)
        post :add_tmdb, {:tmdb_movies => fake_results}
        expect(flash[:notice]).to eq('Movies successfully added to Rotten Potatoes')
        expect(response).to redirect_to(movies_path)
    end
  end
end
