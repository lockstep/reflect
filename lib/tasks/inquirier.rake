namespace :inquirer do
  task inquire: :environment do
    InquisitionInitiator.perform_async
  end
end
