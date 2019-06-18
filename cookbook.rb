require 'csv'
require_relative 'recipe'

class Cookbook
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = []
    load_csv
  end

  def all
    return @recipes
  end

  def find(index)
    @recipes[index]
  end

  def add_recipe(recipe)
    @recipes << recipe
    save_csv
  end

  def remove_recipe(index)
    @recipes.delete_at(index)
    save_csv
  end

  def save_csv
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    filepath = @csv_file_path
    CSV.open(filepath, 'wb', csv_options) do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name.to_s, recipe.description.to_s, recipe.prep_time.to_s]
      end
    end
  end

  def load_csv
    csv_options = { col_sep: ',', quote_char: '"' }
    filepath = @csv_file_path
    CSV.foreach(filepath, csv_options) do |row|
      @recipes << Recipe.new(row[0], row[1], row[3])
    end
    return @recipes
  end
end

