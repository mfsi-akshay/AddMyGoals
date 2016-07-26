set :output, "#{path}/log/cron.log"

every :weekday, at: "9.00AM" do
  rake "goals:update"
end

every :weekday, at: "5.59PM" do
  rake "goals:add"
end
