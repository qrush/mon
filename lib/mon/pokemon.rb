module Mon
  class Pokemon
    HP      = 1
    ATTACK  = 2
    DEFENSE = 3
    SPATK   = 4
    SPDEF   = 5
    SPEED   = 6
    IV      = 32
    EV      = 255
    MAX_EV  = 510
    LEVEL   = 50
    STATS   = [HP, ATTACK, DEFENSE, SPATK, SPDEF, SPEED]

    attr_accessor :id, :name, :hp, :stats

    def initialize(id, name)
      @id = id
      @name = name.upcase
      @ivs = Hash[STATS.zip(STATS.map { rand(IV) })]

      # EVs sum cannot exceed MAX_EV
      ev_values = []
      while ev_values.size == 0 || ev_values.inject(0, &:+) > MAX_EV
        ev_values = STATS.map { rand(EV) }
      end
      @evs = Hash[STATS.zip(ev_values)]

      @base = Pokedex.stats_for(id).inject({}) do |base, row|
        base[row[:stat_id]] = row[:base_stat]
        base
      end
      @stats = Hash[STATS.zip(STATS.map { |stat| calculate_stat(stat) })]
      @hp = @stats[HP]
    end

    def sprite_url
      "http://pokeapi.co/media/img/#{id}.png"
    end

    def moves
      @moves ||= Pokedex.moves_for(id)
    end

    def move_names
      moves.map { |move| move[:identifier].upcase }.join(", ")
    end

    def attack(name, enemy)
      if move = find_move(name)
        enemy.hp -= calculate_damage(move, enemy)
      else
        false
      end
    end

    private

      # http://bulbapedia.bulbagarden.net/wiki/Stats#In_Generation_III_onward
      def calculate_stat(stat)
        before_bump = (stat == HP) ? 100 : 0
        final_bump  = (stat == HP) ? 10 : 5

        (
          (((@ivs[stat] + (2 * @base[stat]) + (@evs[stat] / 4.0) + before_bump) * LEVEL) / 100.0) + final_bump
        ).floor
      end

      # http://bulbapedia.bulbagarden.net/wiki/Damage#Damage_formula
      def calculate_damage(move, enemy)
        attack_class = move[:damage_class_id]
        defense_class = (attack_class == Pokedex::DAMAGE_CLASS_ATTACK) ? DEFENSE : SPDEF

        # TODO: STAB, Crits, Types
        modifier = rand(0.85..1)

        (
          (
            ((2 * LEVEL + 10) / 250.0) *
            (@stats[attack_class] / enemy.stats[defense_class].to_f) *
            move[:power] +
            2
          ) * modifier
        ).floor
      end

      def find_move(name)
        @moves.find { |move| move[:identifier].upcase == name.upcase }
      end
  end
end
