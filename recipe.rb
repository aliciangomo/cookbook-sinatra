class Recipe
  attr_reader :name, :description, :prep_time, :state
  def initialize(name, description, prep_time, state = false)
    @name = name
    @description = description
    @prep_time = prep_time
    @state = state
  end

  def done?
    @state = true
  end
end
