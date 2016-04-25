require "rails_helper"

RSpec.describe Event, type: :model do
	it "days should return days of the events" do
		event_1 = FactoryGirl.create(:event, start: DateTime.now + 1.day, 
																				 end: DateTime.now + 1.day + 2.hours)
		event_2 = FactoryGirl.create(:event, start: DateTime.now, 
																				 end: DateTime.now + 3.hours)
		event_3 = FactoryGirl.create(:event, start: DateTime.now, 
																				 end: DateTime.now + 3.hours)

		expect(Event.days).to eq([
															Date.today, 
															Date.tomorrow
														])
	end

	it 'should save its users' do
		event = FactoryGirl.create(:event)

		user_1 = FactoryGirl.create(:user)
		user_2 = FactoryGirl.create(:user)

		event.add user_1
		event.add user_2

		expect(Event.find(event.id).users).to eq([user_1, user_2])
	end

	it 'should generate subscription when user register into events' do
		event = FactoryGirl.create(:event)

		user_1 = FactoryGirl.create(:user)
		user_2 = FactoryGirl.create(:user)

		event.add user_1
		event.add user_2

		expect(Subscription.all.count).to eq(2)
	end

	it 'should generate subscription when user register into events matching its users' do
		event = FactoryGirl.create(:event)

		user_1 = FactoryGirl.create(:user)
		user_2 = FactoryGirl.create(:user)

		event.add user_1

		expect(Subscription.first.user).to eq(user_1)
	end

	it 'should remove its users properly' do
		event = FactoryGirl.create(:event)

		user_1 = FactoryGirl.create(:user)
		user_2 = FactoryGirl.create(:user)

		event.add user_1
		event.add user_2

		expect(event.users.first).to eq(user_1)

		event.remove user_1

		expect(event.users.first).to eq(user_2)
	end

	it 'user can\'t go to concurrent events' do
		user = FactoryGirl.create(:user)

		event = FactoryGirl.create(:event, name: 'test',
																				 start: 2.hour.from_now, 
																				 end:   4.hours.from_now)
		# Evento equivalente
		event_eq = FactoryGirl.create(:event, name: 'test',
																				 start: 8.hours.from_now, 
																				 end:   10.hours.from_now)

		# Antes e no meio do evento
		event_1 = FactoryGirl.create(:event, start: 1.hours.from_now, 
																				 end:   3.hours.from_now)
		# Entre o evento
		event_2 = FactoryGirl.create(:event, start: 3.hours.from_now, 
																				 end:   3.hours.from_now + 30.minutes)
		# No meio e depois do evento
		event_3 = FactoryGirl.create(:event, start: 3.hours.from_now, 
																				 end:   5.hours.from_now)
		
		# Antes e no meio do eq
		event_4 = FactoryGirl.create(:event, start: 7.hours.from_now, 
																				 end:   9.hours.from_now)
		# Entre o equivalente
		event_5 = FactoryGirl.create(:event, start: 9.hours.from_now, 
																				 end:   9.hours.from_now + 30.minutes)
		# No meio e depois do equivalente
		event_6 = FactoryGirl.create(:event, start: 9.hours.from_now, 
																				 end:   11.hours.from_now)

		########################################## Non conflicting events. These below should return false
		# Antes do evento
		event_7  = FactoryGirl.create(:event, start: 1.second.from_now, 
																				  end:   event.start - 1.second)
		# Após o evento
		event_8 = FactoryGirl.create(:event, start: event.end + 1.second, 
																				  end:   event.end + 1.hour)
		# Antes do equivalente
		event_9 = FactoryGirl.create(:event, start: event_eq.start - 1.hour,
																				  end:   event_eq.start - 1.second)
		# Após o equivalente
		event_10 = FactoryGirl.create(:event, start: event_eq.end + 1.second,
																				  end:   event_eq.end + 1.hour)


		expect(user.has_concurrent_event? event_1).to eq(false)

		user.events << event

		# expect(user.has_concurrent_event? event_eq).to  eq(true)

		expect(user.has_concurrent_event? event_1).to  eq(true)
		expect(user.has_concurrent_event? event_2).to  eq(true)
		expect(user.has_concurrent_event? event_3).to  eq(true)
		expect(user.has_concurrent_event? event_4).to  eq(true)
		expect(user.has_concurrent_event? event_5).to  eq(true)
		expect(user.has_concurrent_event? event_6).to  eq(true)
		expect(user.has_concurrent_event? event_7).to  eq(false)
		expect(user.has_concurrent_event? event_8).to  eq(false)
		expect(user.has_concurrent_event? event_9).to  eq(false)
		expect(user.has_concurrent_event? event_10).to eq(false)
	end

	it 'user can go to consecutive events' do
		user = FactoryGirl.create(:user)

		event = FactoryGirl.create(:event, name: 'test#2',
																			 start: 2.hour.from_now, 
																			 end:   4.hours.from_now)
		# Evento equivalente ao 1
		event_eq = FactoryGirl.create(:event, name: 'test#2',
																			    start: 8.hours.from_now, 
																				  end:   10.hours.from_now)

		# Antes do evento
		event_1 = FactoryGirl.create(:event, start: event.start - 1.hour, 
																				 end:  event.start,
																				 name: 'evento loko')
		# Após o evento
		event_2 = FactoryGirl.create(:event, start: event.end, 
																				 end:  event.end + 1.hour)
		# Antes do equivalente
		event_3 = FactoryGirl.create(:event, start: event_eq.start - 1.hour,
																				 end:  event_eq.start,
																				 name: 'event 3')
		# Após o equivalente
		event_4 = FactoryGirl.create(:event, start: event_eq.end,
																				 end:  event_eq.end + 1.hour)

		user.events << event
		user.events << event_eq

		expect(user.has_concurrent_event?(event_1)).to eq(false)
		expect(user.has_concurrent_event?(event_2)).to eq(false)
		expect(user.has_concurrent_event?(event_3)).to eq(false)
		expect(user.has_concurrent_event?(event_4)).to eq(false)
	end

	# it 'should return its days' do
	# 	event_1 = FactoryGirl.create(:event, start: 1.second.from_now, 
	# 																			 end:   3.seconds.from_now)
	# 	event_2 = FactoryGirl.create(:event, start: 1.second.from_now, 
	# 																			 end:   50.hours.from_now)

	# 	expect(event_1.occurring_days.to_a).to eq([Date.today])
	# 	expect(event_2.occurring_days).to eq(Date.today..Date.tomorrow.tomorrow)
	# end

	# it 'should return its hours by day' do
	# 	event_1 = FactoryGirl.create(:event, start: 1.second.from_now, 
	# 																			 end:   3.seconds.from_now)
	# 	event_2 = FactoryGirl.create(:event, start: 1.second.from_now, 
	# 																			 end:   50.hours.from_now)
	# 	event_3 = FactoryGirl.create(:event, start: 1.second.from_now, 
	# 																			 end:   30.hours.from_now)

	# 	expect(event_1.occurring_hours).to eq([{ day: Date.today, hours: [event_1.start.hour] }])

	# 	expect(event_2.occurring_hours).to eq([{ day: Date.today,             hours: (event_2.start.hour..23).to_a },
	# 																				 { day: Date.tomorrow,          hours: (0..23).to_a },
	# 																				 { day: Date.tomorrow.tomorrow, hours: (0..(event_2.end.hour)).to_a }
	# 																			  ])
	# 	if Time.zone.now.hour < 19 #hours
	# 		expect(event_3.occurring_hours).to eq([{ day: Date.today,             hours: (event_3.start.hour..23).to_a },
	# 																					 { day: Date.tomorrow, hours: (0..(event_3.end.hour)).to_a}
	# 																				  ])
	# 	else
	# 		expect(event_3.occurring_hours).to eq([{ day: Date.today,             hours: (event_3.start.hour..23).to_a },
	# 																					 { day: Date.tomorrow,          hours: (0..23).to_a },
	# 																					 { day: Date.tomorrow.tomorrow, hours: (0..(event_3.end.hour)).to_a}
	# 																				  ])
	# 	end
	# end

	# it 'sould separate events by days' do
	# 	# It should return something like this
	# 	# [
	# 	# 	{
	# 	# 		date: DATA,
	# 	# 		hours:  [
	# 	# 							{
	# 	# 								10: [
	# 	# 											evento1,
	# 	# 											evento1
	# 	# 										]
	# 	# 							}
	# 	# 					  ]
	# 	# 	}
	# 	# ]

	# 	event_1 = FactoryGirl.create(:event, start: 1.second.from_now, 
	# 																			 end:   1.hour.from_now)

	# 	event_2 = FactoryGirl.create(:event, start: 1.second.from_now, 
	# 																			 end:   2.hours.from_now)

	# 	event_3 = FactoryGirl.create(:event, start: 24.hours.from_now, 
	# 																			 end:   26.hours.from_now)

	# 	expect(Event.join_events_by_time)
	# 	.to eq([
	# 						{
	# 							date:  event_1.start.to_date,
	# 							hours: [
	# 										 		{
	# 										 			time:   event_1.start.hour,
	# 										 			events: [event_1, event_2]
	# 										 		},
	# 										 		{
	# 										 			time:   event_2.start.hour+1,
	# 										 			events: [event_2]
	# 										 		}
	# 										 ]
	# 						},
	# 						{
	# 							date:  event_3.start.to_date,
	# 							hours: [
	# 												{
	# 													time:   event_3.start.hour,
	# 													events: [event_3]
	# 												},
	# 												{
	# 													time:   event_3.start.hour+1,
	# 													events: [event_3]
	# 												}
	# 										 ]
	# 						}
	# 				 ])
	# end

	it 'should return its equivalents' do
		event_1 = FactoryGirl.create(:event, name:  'test#1',
																				 limit: 2,
																				 start: 1.second.from_now, 
																				 end:   1.hour.from_now)

		event_2 = FactoryGirl.create(:event, name:  'test#1',
																				 limit: 3,
																				 start: 1.second.from_now, 
																				 end:   2.hours.from_now)

		event_3 = FactoryGirl.create(:event, start: 24.hours.from_now, 
																				 end:   26.hours.from_now)

		expect(event_1.equivalents).to eq([event_2])
		expect(event_2.equivalents).to eq([event_1])
	end

	it 'should check if its equivalents are full' do
		event_1 = FactoryGirl.create(:event, name:  'test#1',
																				 limit: 2,
																				 start: 1.second.from_now, 
																				 end:   1.hour.from_now)

		event_2 = FactoryGirl.create(:event, name:  'test#1',
																				 limit: 2,
																				 start: 1.second.from_now, 
																				 end:   2.hours.from_now)

		event_3 = FactoryGirl.create(:event, start: 24.hours.from_now, 
																				 end:   26.hours.from_now)

		user_1 = FactoryGirl.create(:user)
		user_2 = FactoryGirl.create(:user)
		user_3 = FactoryGirl.create(:user)

		user_1.events << event_1
		user_2.events << event_1

		event_3.users << user_1
		event_3.users << user_2
		event_3.users << user_3

		expect(event_1.full?).to eq(true)
		expect(event_2.full?).to eq(true)
		expect(event_3.full?).to eq(false)
	end

	it 'should contain users from equivalent events' do
		event_1 = FactoryGirl.create(:event, name:  'test#1',
																				 limit: 2,
																				 start: 1.second.from_now, 
																				 end:   1.hour.from_now)

		event_2 = FactoryGirl.create(:event, name:  'test#1',
																				 limit: 2,
																				 start: 1.second.from_now, 
																				 end:   2.hours.from_now)

		event_3 = FactoryGirl.create(:event, start: 24.hours.from_now, 
																				 end:   26.hours.from_now)

		user_1 = FactoryGirl.create(:user)
		user_2 = FactoryGirl.create(:user)
		user_3 = FactoryGirl.create(:user)

		event_1.users << user_1
		event_2.users << user_2
		event_3.users << user_3

		expect(event_1.contains?(user_2)).to eq(true)
		expect(event_2.contains?(user_1)).to eq(true)
		expect(event_3.contains?(user_3)).to eq(true)

		expect(event_1.contains?(user_3)).to eq(false)
		expect(event_2.contains?(user_3)).to eq(false)
		expect(event_3.contains?(user_1)).to eq(false)
		expect(event_3.contains?(user_2)).to eq(false)
	end

	it 'should know if there are any equivalent event' do
		event_1 = FactoryGirl.create(:event, name:  'test#1',
																				 limit: 2,
																				 start: 1.second.from_now, 
																				 end:   1.hour.from_now)

		event_2 = FactoryGirl.create(:event, name:  'test#1',
																				 limit: 2,
																				 start: 1.second.from_now, 
																				 end:   2.hours.from_now)

		event_3 = FactoryGirl.create(:event, start: 24.hours.from_now, 
																				 end:   26.hours.from_now)

		expect(event_1.has_any_equivalent?).to eq(true)
		expect(event_2.has_any_equivalent?).to eq(true)
		expect(event_3.has_any_equivalent?).to eq(false)

	end

	it 'should list its equivalents events' do
		event_1 = FactoryGirl.create(:event, name:  'test#1',
																				 limit: 2,
																				 start: 1.second.from_now, 
																				 end:   1.hour.from_now)

		event_2 = FactoryGirl.create(:event, name:  'test#1',
																				 limit: 2,
																				 start: 1.second.from_now, 
																				 end:   2.hours.from_now)

		event_3 = FactoryGirl.create(:event, start: 24.hours.from_now, 
																				 end:   26.hours.from_now)
		event_4 = FactoryGirl.create(:event, name:  'test#1',
																				 start: 24.hours.from_now, 
																				 end:   26.hours.from_now)



		expect(event_1.equivalents).to eq([event_2, event_4])
		expect(event_2.equivalents).to eq([event_1, event_4])
	end

	it 'should list its concurrents events' do
		event_1 = FactoryGirl.create(:event, name:  'test#1',
																				 limit: 2,
																				 start: 1.hour.from_now, 
																				 end:   2.hour.from_now)

		event_2 = FactoryGirl.create(:event, name:  'test#1',
																				 limit: 2,
																				 start: 1.second.from_now, 
																				 end:   2.hours.from_now)

		event_3 = FactoryGirl.create(:event, start: 1.second.from_now, 
																				 end:   26.hours.from_now)
		event_4 = FactoryGirl.create(:event, name:  'test#1',
																				 start: 24.hours.from_now, 
																				 end:   26.hours.from_now)

		user_1 = FactoryGirl.create(:user)

		user_1.events << event_1
		user_1.events << event_4

		expect(event_1.concurrents).to eq([event_2, event_3])
		expect(event_2.concurrents).to eq([event_1, event_3])
		expect(event_3.concurrents).to eq([event_1, event_2, event_4])
		expect(event_4.concurrents).to eq([event_3])

		expect(event_3.concurrents(user_1)).to eq([event_1, event_4])
		expect(event_4.concurrents(user_1)).to eq([])
	end
end
