require 'forwardable'

module Mon
  class Pokemon
    extend Forwardable

    attr_accessor :id, :name, :hp, :stats, :last_move, :types
    def_delegators :@stats, :speed, :level, :attack_for, :defense_for

    def initialize(id, name, types)
      @id    = id
      @name  = name.upcase
      @types = types
      @stats = Stats.new(id)
      @hp    = @stats.hp
    end

    def sprite_url
      "http://pokeapi.co/media/img/#{id}.png"
    end

    def moves
      @moves ||= Pokedex.moves_for(id)
    end

    def move_names
      moves.map(&:name).join(", ")
    end

    def find_move(name)
      @moves.find { |move| move.name == name.upcase }
    end

    def attack(name, enemy)
      self.last_move = find_move(name)
      perform_damage(last_move, enemy)
      self
    end

    def counterattack(enemy)
      self.last_move = moves.shuffle.first
      perform_damage(last_move, enemy)
      self
    end

    private

      def perform_damage(move, enemy)
        enemy.hp -= move.damage(self, enemy)
        enemy.hp = 0 if enemy.hp < 0
      end
  end
end
