require 'csv'
# file = File.read(Rails.root.join('lib', 'seeds', 'sheet.csv'))
file = File.read('sheet.csv')
people = CSV.parse(file)

people.each do |row|
  p row[0]
end
