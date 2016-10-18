class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
class Movie::InvalidKeyError < StandardError ; end
  
  def self.find_in_tmdb(string)
    begin
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    tmdbmovies = []
    tmdbSearchResults = Tmdb::Movie.find(string)
    if tmdbSearchResults != nil
      tmdbSearchResults.each do |x|
        tmdbmovies << {:tmdb_id => x.id, :title => x.title, :rating => self.get_tmdb_rating(x.id), :release_date => x.release_date}
      end
    end
    return tmdbmovies
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end
  
  def self.get_tmdb_rating(tmdbmovieid)
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    rating = ''
    Tmdb::Movie.releases(tmdbmovieid)["countries"].each do |x|
      if x["iso_3166_1"] == "US"
        if x["certification"] != ''
        rating = x["certification"]
        break
        end
      end
    end
    if rating == ''
      rating = 'NR'
    end
    return rating
  end
  
  def self.create_from_tmdb(id)
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    moviefromtmdb = Tmdb::Movie.detail(id)
    movietoadd = [:title => moviefromtmdb['title'], :rating => self.get_tmdb_rating(id), :release_date => moviefromtmdb['release_date'], :description => moviefromtmdb['overview']]
    Movie.create!(movietoadd)
  end
end
