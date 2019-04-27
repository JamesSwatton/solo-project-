require( 'sinatra' )
require( 'sinatra/contrib/all' )
require( 'pry-byebug' )
require_relative( './models/album.rb' )
require_relative( './models/artist.rb' )
require_relative( './models/stock.rb' )
also_reload( './models/*' )

get '/artists' do
  @artists = Artist.sort_all()
  @recently_added_artist = Artist.all.pop
  erb(:"artists/index")
end

get '/artists/new' do
  erb(:"artists/new")
end

post '/artists' do
  all_artists = Artist.all()
  artist_names = all_artists.map { |artist| artist.name }

  if artist_names.include?(swap_the(params['name']))
      redirect to '/artists/new'
  end

  Artist.new(params).save()
  redirect to '/artists'
end


def swap_the(string)
  if string.start_with?("The") || string.end_with?("The")
    string = string.split.reverse.join(" ")
    return string
  end
  return string
end