require 'sinatra/base'
require './lib/game'

class Rpsweb < Sinatra::Base
  set :views, proc { File.join(root, '..', 'views') }
  enable :sessions

  get '/' do # your controllers are too fat! consider refactoring to helper methods
    @name = params[:name]
    session[:name] = @name
    if $game
      session[:playername] = "Player 2: #{@name}" # duplicating with the two session variables 'name', and 'playername'
      @playernum = 2
    else
      session[:playername] = "Player 1: #{@name}"
      @playernum = 1
    end
    erb :index
  end

  get '/start' do
    @playername = session[:playername]
    $game = Game.new(Player) unless @playername.include?("Player 2:") # prefer unless over if !etc
    erb :start
  end

  post '/choose' do
    choice = params[:choice]
    if session[:playername].include?("1:") # this might allow player 2 to pretend to be player 1 by including this string in their name
      $game.player1.choose(choice)
    else
      $game.player2.choose(choice)
    end
    redirect '/waiting_room'
  end

  get '/waiting_room' do
    unless $game.player2.choice
      $game.player2.choose(['rock', 'paper', 'scissors'].sample)
    end
    erb :waiting_room
  end

  get '/verdict' do
    @verdict = $game.decider
    erb :verdict
  end

  run! if app_file == $0
end
