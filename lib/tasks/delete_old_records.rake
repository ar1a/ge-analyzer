namespace :delete do
  desc 'Delete old price updates'
  task :price_updates => :environment do
    PriceUpdate.where('created_at < ?', 35.days.ago).each do |m|
      m.destroy
    end
  end
end
