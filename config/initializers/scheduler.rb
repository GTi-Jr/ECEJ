require 'rufus-scheduler'

singleton = Rufus::Scheduler.singleton
scheduler = Rufus::Scheduler.new

singleton.every('30s') do
  Rails.logger.info "Scheduler is active"
end

singleton.every '4h' do
  Rails.logger.info "Running user verifications on #{Time.now}"
  User.organize_lots!
end
# # The day before lot 2 start date values
day_before_2 = DateTime.new(2016, 1, 14, 0, 1, 0, '-3') - 1.day

year_2 = day_before_2.year
month_2 = day_before_2.month
day_2 = day_before_2.day
hour_2 = day_before_2.hour
minute_2 = day_before_2.min
second_2 = day_before_2.sec
# # Send eligible users an email to register into the second lot a day before it's opening
scheduler.at "#{year_2}/#{month_2}/#{day_2} #{hour_2}:#{minute_2}:#{second_2}" do
  Rails.logger.info "Sending emails to eligible list on #{Time.now}"
  User.send_lot_2_antecipated_emails
end
# # The day before lot 3 start date values
day_before_3 = DateTime.new(2016, 1, 21, 0, 1, 0, '-3') - 1.day

year_3 = day_before_3.year
month_3 = day_before_3.month
day_3 = day_before_3.day
hour_3 = day_before_3.hour
minute_3 = day_before_3.min
second_3 = day_before_3.sec
# # Send eligible users an email to register into the third lot a day before it's opening
scheduler.at "#{year_3}/#{month_3}/#{day_3} #{hour_3}:#{minute_3}:#{second_3}" do
  Rails.logger.info "Sending emails to eligible list on #{Time.now}"
  User.send_lot_3_antecipated_emails
end
