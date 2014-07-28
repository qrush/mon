module Mon
  MONSTER_IDS = (1..150).to_a

  class Battle
    attr_reader :visitor, :home

    def initialize
      @visitor = Pokedex.find_by_id(MONSTER_IDS.shuffle.first)
      @ai_battle = true
    end

    def choose_visitor(name)
      @ai_battle = false
      @visitor = Pokedex.find_by_name(name)
    end

    def choose_home(name)
      @home = Pokedex.find_by_name(name)
    end

    def can_use_home?(name)
      home.find_move(name)
    end

    def can_use_visitor?(name)
      visitor.find_move(name)
    end

    def use_home(name)
      @home_name = name

      if @ai_battle || @visitor_name
        use_moves
      end
    end

    def use_visitor(name)
      @visitor_name = name

      if @home_name
        use_moves
      end
    end

    def use_moves
      # http://bulbapedia.bulbagarden.net/wiki/Stats#Speed
      order = if home.speed > visitor.speed
                [:home_attack, :visitor_attack]
              elsif visitor.speed > home.speed
                [:visitor_attack, :home_attack]
              else
                [:home_attack, :visitor_attack].shuffle
              end

      moves = order.map { |move| send(move) }
      @home_name = @visitor_name = nil
      moves
    end

    def home_attack
      home.attack(@home_name, visitor)
    end

    def visitor_attack
      if @ai_battle
        visitor.counterattack(home)
      else
        visitor.attack(@visitor_name, home)
      end
    end

    def other(pokemon)
      if pokemon == home
        visitor
      else
        home
      end
    end

    def started?
      visitor && home
    end

    def battling?
      visitor.hp.nonzero? && home.hp.nonzero?
    end

    def inspect
      "#{home.name} @ #{home.hp} vs #{visitor.name} @ #{visitor.hp}"
    end
  end
end
