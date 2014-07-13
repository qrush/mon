require "bundler/gem_tasks"

task :pokedb do
  name = "pokedb.sqlite3"
  File.unlink("share/#{name}")
  Dir.chdir("share") do
    %w(moves pokemon_moves pokemon_species_names pokemon_stats).each do |table|
      sh "./csv2sqlite.py #{table}.csv #{name} #{table}"
    end
  end
end

task :console do
  exec "irb -Ilib -r./lib/mon"
end
