require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

s.every '6h' do
  Rails.logger.info "Running user verifications on #{Time.now}"
  User.delete_inactive_users!
end