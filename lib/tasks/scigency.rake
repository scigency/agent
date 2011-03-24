namespace :scigency do
  desc "Create database, load the schema, and initialize with data"
  task :setup => :environment do
    Rake::Task["db:create"].invoke
    Rake::Task["db:schema:load"].invoke
    Rake::Task["meshcomplete:data"].invoke
  end

  desc "Recreate database, load the schema, and initialize with data"
  task :reset => :environment do
    Rake::Task["db:drop"].invoke
    Rake::Task["scigency:setup"].invoke
  end

  desc "load Scigency data"
  task :load, :file, :needs => :environment do |task, args|
    file = args[:file]
    model = Object.const_get( File.basename(file, ".dat").classify )
    File.open(file, "r") do |f|
      records = []
      columns = []
      f.each_line do |line|
        if f.lineno == 1
          columns = line.strip.split(/\t/).map {|a| a.to_sym}
        else
          records << line.strip.split(/\t/)
        end
      end
      model.import columns, records, :validate => false
    end
  end
  
end