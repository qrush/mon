module Mon
  MONSTER_IDS = (1..150).to_a

  class Battle
    attr_reader :visitor, :home

    def initialize
      @visitor = Pokedex.find_by_id(MONSTER_IDS.shuffle.first)
    end

    def choose(name)
      @home = Pokedex.find_by_name(name)
    end

    def use(name)
      @home.attack(name, @visitor)
    end

    def visitor_defeated?
      @visitor.hp.zero?
    end

    def home_defeated?
      @home.hp.zero?
    end

    def started?
      @visitor && @home
    end
  end
end
