require "mechanize"
namespace :goals do
  task :add => :environment do
    active_users = User.includes(:goals, :credential).where(:goals => {:date => Date.today})
    active_users.each do |user|
      print "Processing user: #{user.credential.username}"

      agent = Mechanize.new
      begin
        login_page = agent.get("http://www.ourgoalplan.com/Login.aspx")
      rescue => e
        print e
        next
      end
      print "Trying to loggin"
      login_form = login_page.form
      login_form.field_with(:name => "txtName").value = user.credential.username
      print "\n #{user.credential.username}"
      crypt =  ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
      decrypted_pass = crypt.decrypt_and_verify(user.credential.password)

      login_form.field_with(:name => "txtPassword").value = decrypted_pass

      button = login_form.button_with(:name => "btnLogin")
      print "About to login\n"
      landing_page = login_form.submit(button)
      sleep 5.0

      gps_form = landing_page.form

      if gps_form.field_with(:name => "ucAddGoal$txtAddGoal").present?
        print "Login success!"
      else
        print "Unable to login!"
        next
      end

      #Add Goals here!
      print "Adding Goal now"
      user_goals = ""
      user.goals.map {|goal| user_goals << "#{goal.body}\n" }
      gps_form.field_with(:name => "ucAddGoal$txtAddGoal").value = user_goals
      add_button = gps_form.button_with(:name => "ucAddGoal$btnAddGoal")
      gps_form.submit(add_button)
      print "Everything done!"
      #Done!
    end

  end

  task :update => :environment do
    active_users = User.includes(:goals, :credential).where(:goals => {:date => Date.today})
    active_users.each do |user|
      print "Processing user: #{user.credential.username}"

      agent = Mechanize.new
      begin
        login_page = agent.get("http://www.ourgoalplan.com/Login.aspx")
      rescue => e
        next
      end

      login_form = login_page.form
      login_form.field_with(:name => "txtName").value = user.credential.username

      crypt =  ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
      decrypted_pass = crypt.decrypt_and_verify(user.credential.password)
      login_form.field_with(:name => "txtPassword").value = decrypted_pass

      button = login_form.button_with(:name => "btnLogin")
      landing_page = login_form.submit(button)
      sleep 5.0
      gps_form = landing_page.form

      next unless gps_form.field_with(:name => "ucAddGoal$txtAddGoal").present?
      puts "Logged in, updating goal now"

      target_goal = user.goals.first.body
      target_span_id = landing_page.at("span:contains(\"#{target_goal}\")").present? ? landing_page.at("span:contains(\"#{target_goal}\")").first[1] : ""

      if target_span_id.blank?
        puts "Goal not found!"
        next
      end

      goal_id = target_span_id[/\d\d/]
      print "#{goal_id}"
      checkfield_id = "dgGoals_ctl" + goal_id + "_chkStatus"
      checkfield = gps_form.checkbox_with(:id => checkfield_id)
      print "Check found"
      next unless checkfield.present?
      checkfield.check
      update_form = agent.page.form_with(:name => "Form1")
      update_button = update_form.button_with(:name => "btnUpdate")

      agent.submit(update_form, update_button)

      print "Update done!"
    end
  end
end
