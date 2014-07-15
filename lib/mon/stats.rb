module Mon
  class Stats
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

    def initialize(id)
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

      @current = Hash[STATS.zip(STATS.map { |stat| calculate_stat(stat) })]
    end

    def attack_for(attack_class)
      @current[attack_class]
    end

    def defense_for(attack_class)
      defense_class = (attack_class == Pokedex::DAMAGE_CLASS_ATTACK) ? DEFENSE : SPDEF
      @current[defense_class]
    end

    def level
      LEVEL
    end

    def hp
      @current[HP]
    end

    def attack
      @current[ATTACK]
    end

    def special_attack
      @current[SPATK]
    end

    def defense
      @current[DEFENSE]
    end

    def special_defense
      @current[SPDEF]
    end

    def speed
      @current[SPEED]
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
  end
end
