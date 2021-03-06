require( 'sinatra' )
require( 'sinatra/contrib/all' )
require( 'pry-byebug' )
require_relative( '../models/album.rb' )
require_relative( '../models/artist.rb' )
require_relative( '../models/stock.rb' )
also_reload( '../models/*' )

get '/artists' do
  @first_char_from_names = Artist.first_char_from_names()
  @artists = Artist.sort_all()
  @recently_added_artist = Artist.all.pop
  erb(:"artists/index")
end

get '/artists/new' do
  erb(:"artists/new")
end

post '/artists' do
  artist = Artist.new(params)
  artist.name = artist.swap_the()

  if Artist.exists?(artist.name)
    redirect to '/artists/new'
  end
  Artist.new(params).save()
  redirect to '/artists'
end

get '/artists/filter/:char' do
  @first_char_from_names = Artist.first_char_from_names()
  @artists = Artist.filter_by_char(params[:char].upcase)
  @recently_added_artist = Artist.all.pop
  erb(:'artists/index')
end

get '/artists/:id' do
  @artist = Artist.find(params['id'])
  erb(:"artists/show")
end

get '/artists/:id/edit' do
  @artist = Artist.find(params['id'])
  erb(:"artists/edit")
end

post '/artists/:id/edit' do
  artist = Artist.new(params)
  artist.update()
  redirect to "/artists/#{params['id']}"
end

post '/artists/:id/delete' do
  Artist.delete(params['id'])
  redirect to '/artists'
end
