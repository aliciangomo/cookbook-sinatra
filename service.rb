require 'open-uri'
require 'nokogiri'
require 'pry'
require_relative 'recipe'

class Service
  def initialize(ingredient)
    @ingredient = ingredient
  end

  def scrappe
    @loaded_recipes = []

    # Make an HTTP request to the recipe's website with our keyword
    # Parse the HTML document to extract the first 5 recipes suggested and store them in an Array
    # Display them in an indexed list
    # url = "http://www.letscookfrench.com/recipes/find-recipe.aspx?s=#{ingredient}"

    # file = './strawberry.html'
    # html_doc = Nokogiri::HTML(File.open(file), nil, 'utf-8')

    url = "http://www.letscookfrench.com/recipes/find-recipe.aspx?s=#{@ingredient}"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    html_doc.search('.m_contenu_resultat').first(5).each do |element|
      name = element.css('.m_titre_resultat').text.strip
      description = element.css('.m_texte_resultat').text.strip
      time = element.css('.m_detail_time > div').text
      prep_time = time.strip.split(' ').first
      @loaded_recipes << Recipe.new(name, description, prep_time.to_i, false)
    end

    # html_doc.search('.m_detail_recette').each do |element|
    #   @content_recipes << element.text.strip
    # end

    # html_doc.search('.m_detail_time m_prep_time').each do |element|
    #   @prep_time << element.text.strip
    # end
    return @loaded_recipes
  end
end

# service = Service.new('strawberry')
# service.scrappe


