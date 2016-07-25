require "mechanize"
namespace :goals do
  task :add => :environment do

    active_users = User.includes(:goals, :credential).where(:goals => {:date => Date.today})
    active_users.each do |user|
      agent = Mechanize.new
      login_page = agent.get("http://www.ourgoalplan.com/Login.aspx")

      login_form = login_page.form
      login_form.field_with(:name => "txtName").value = user.credential.username
      login_form.field_with(:name => "txtPassword").value = user.credential.password

      button = login_form.button_with(:name => "btnLogin")

      landing_page = login_form.submit(button)
      sleep 5.0
      gps_form = landing_page.form
      #Add Goals here!

      gps_form.field_with(:name => "ucAddGoal$txtAddGoal").value = user.goals.first.body
      add_button = gps_form.button_with(:name => "ucAddGoal$btnAddGoal")
      gps_form.submit(add_button)

      #Done!
    end

  end
end
