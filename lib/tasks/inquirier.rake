namespace :inquirer do
  task inquire: :environment do
    InquisitionScheduler.perform_async
    InquisitionInitiator.perform_async
  end
end
