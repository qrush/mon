require "bundler/gem_tasks"

task :pokedb do
  name = "pokedb.sqlite3"
  File.unlink("share/#{name}")
  Dir.chdir("share") do
    %w(
      moves
      pokemon_moves
      pokemon_species_names
      pokemon_stats
      pokemon_types
      type_efficacy
    ).each do |table|
      sh "./csv2sqlite.py #{table}.csv #{name} #{table}"
    end
  end
end

task :console do
  exec "irb -Ilib -r./lib/mon"
end

task :battle do
  $:.unshift "lib"
  require './lib/mon'

  include Mon

  battle = Battle.new
  battle.choose("Charizard")

  while battle.battling?
    p battle
    move = battle.home.moves.shuffle.first
    moves = battle.use move.name
    moves.each do |pokemon|
      puts "> #{pokemon.name} used #{pokemon.last_move.name}"
    end
  end

  p battle
end

task :default => :battle
