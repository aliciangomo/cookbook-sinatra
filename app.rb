require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require 'csv'
require 'open-uri'
require 'nokogiri'
set :bind, '0.0.0.0'
require_relative 'cookbook'
require_relative 'recipe'
require_relative 'service'
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

csv_file   = File.join(__dir__, 'recipes.csv')
cookbook = Cookbook.new(csv_file)

get '/' do
  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

post '/create' do
  recipe = Recipe.new(params[:name], params[:description], params[:prep_time].to_i, false)
  cookbook.add_recipe(recipe)
  @recipes = cookbook.all
  erb :index
end

get '/destroy/:index' do
  index = params[:index]
  cookbook.remove_recipe(index.to_i)
  @recipes = cookbook.all
  # erb :index
  redirect "/"
end

get '/scrape' do
  erb :scrape
end

post '/import' do
  @loaded_recipes = []
  ingredient = params[:ingredient].to_s
  service = Service.new(ingredient)
  @loaded_recipes = service.scrappe
  erb :ideas
end

get '/mark/:index' do
  index = params[:index]
  recipe = cookbook.find(index.to_i)
  recipe.done?
  @recipes = cookbook.all
  erb :index
end

get '/add/:index' do
  index = params[:index]
  recipe = @loaded_recipes[index]
  cookbook.add_recipe(recipe)
  erb :index
end
