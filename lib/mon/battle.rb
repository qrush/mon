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

    def can_use?(name)
      @home.find_move(name)
    end

    def use(name)
      @name = name

      # http://bulbapedia.bulbagarden.net/wiki/Stats#Speed
      p moves = if @home.speed > @visitor.speed
                [:attack, :counterattack]
              elsif @visitor.speed > @home.speed
                [:counterattack, :attack]
              else
                [:attack, :counterattack].shuffle
              end

      moves.map { |move| send(move) }
    end

    def attack
      @home.attack(@name, @visitor)
    end

    def counterattack
      @visitor.counterattack(@home)
    end

    def other(pokemon)
      if pokemon == @home
        @visitor
      else
        @home
      end
    end

    def started?
      @visitor && @home
    end
  end
end
