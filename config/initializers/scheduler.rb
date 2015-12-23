require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

s.every '4h' do
  Rails.logger.info "Running user verifications on #{Time.now}"
  User.organize_lots!
end