module Mon
  class Pokedex
    ENGLISH = 9

    DAMAGE_CLASS_STATUS  = 1
    DAMAGE_CLASS_ATTACK  = 2
    DAMAGE_CLASS_SPECIAL = 3

    def self.find_by_id(id)
      row = name_scope.where(pokemon_species_id: id).first
      build(id, row[:name])
    end

    def self.find_by_name(name)
      if name =~ /^\d+$/
        find_by_id(name)
      elsif row = name_scope.where(Sequel.ilike(:name, name)).first
        build(row[:pokemon_species_id], row[:name])
      end
    end

    def self.build(id, name)
      types = db[:pokemon_types].where(pokemon_id: id).map { |row| row[:type_id] }

      Pokemon.new(id, name, types)
    end

    def self.moves_for(id)
      pokemon_move_ids = db[:pokemon_moves].where(pokemon_id: id).to_a.map { |pokemon_move| pokemon_move[:move_id] }
      moves = db[:moves].where(id: pokemon_move_ids, damage_class_id: DAMAGE_CLASS_ATTACK).order(Sequel.lit('RANDOM()')).limit(4).to_a

      moves.map { |row| Move.new(row) }
    end

    def self.stats_for(id)
      db[:pokemon_stats].where(pokemon_id: id).to_a
    end

    def self.immune?(damage_type_id, target_types)
      type_scope(damage_type_id, target_types).where(damage_factor: 0).any?
    end

    def self.move_efficacies(damage_type_id, target_types)
      type_scope(damage_type_id, target_types).map { |row| row[:damage_factor] }
    end

    def self.type_scope(damage_type_id, target_types)
      db[:type_efficacy].where(damage_type_id: damage_type_id, target_type_id: target_types)
    end

    def self.name_scope
      db[:pokemon_species_names].where(local_language_id: ENGLISH)
    end

    def self.db
      require 'sequel'
      @db ||= Sequel.sqlite(File.join(File.dirname(__FILE__), "../../share/pokedb.sqlite3"))
    end
  end
end
