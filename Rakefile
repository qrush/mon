require "bundler/gem_tasks"

namespace :db do
  NAME = "pokedb.sqlite3"

  desc "Create postgres db"
  task :create do
    sh "createdb mon_development"
  end

  desc "Create postgres db"
  task :drop do
    sh "dropdb mon_development"
  end

  desc "Create sqlite db"
  task :sqlite do
    File.unlink("share/#{NAME}")
    Dir.chdir("share") do
      %w(
      moves
      pokemon_moves
      pokemon_species_names
      pokemon_stats
      pokemon_types
      type_efficacy
      ).each do |table|
        sh "./csv2sqlite.py #{table}.csv #{NAME} #{table}"
      end
    end
  end

  desc "Import data from sqlite to postgres"
  task :import do
    sh "sqlite3 share/#{NAME} .dump > /tmp/#{NAME}.sql"
    sh "psql -d mon_development -W < /tmp/#{NAME}.sql"
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
      puts "> #{pokemon.name} used #{pokemon.last_move.name} - CRIT: #{pokemon.last_move.critical? ? "YES" : "NO"}"
    end
  end

  p battle
end

task :default => :battle
