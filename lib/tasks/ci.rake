task :ci => ['assets:precompile', :spec, :cucumber]
