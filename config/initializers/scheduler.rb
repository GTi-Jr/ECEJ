require 'rufus-scheduler'

singleton = Rufus::Scheduler.singleton
scheduler = Rufus::Scheduler.new

singleton.every '4h' do
  Rails.logger.info "Running user verifications on #{Time.now}"
  User.organize_lots!
end

day_before_2 = Lot.find(2).start_date - 1.day
year_2 = day_before_2.year
month_2 = day_before_2.month
day_2 = day_before_2.day
hour_2 = day_before_2.hour
minute_2 = day_before_2.minute
second_2 = day_before_2.second

scheduler.at "#{year_2}/#{month_2}/#{day_2} #{hour_2}:#{minute_2}:#{second_2}" do
  #User.send_lot_2_antecipated_emails
end

day_before_3 = Lot.find(3).start_date - 1.day
year_3 = day_before_3.year
month_3 = day_before_3.month
day_3 = day_before_3.day
hour_3 = day_before_3.hour
minute_3 = day_before_3.minute
second_3 = day_before_3.second

scheduler.at "#{year_3}/#{month_3}/#{day_3} #{hour_3}:#{minute_3}:#{second_3}" do
  #User.send_lot_3_antecipated_emails
end
