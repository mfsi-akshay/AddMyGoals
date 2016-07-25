set :output, "#{path}/log/cron.log"

every :weekday, at: "9.00AM" do
  runner 'Task.add_goals'
end

every :weekday, at: "7.59PM" do
  runner 'Task.update_goals'
end
