require "mechanize"
namespace :goals do
  task :add => :environment do

    active_users = User.includes(:goals, :credential).where(:goals => {:date => Date.today})
    active_users.each do |user|
      byebug
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

      #Add Goals here!

      gps_form.field_with(:name => "ucAddGoal$txtAddGoal").value = user.goals.first.body
      add_button = gps_form.button_with(:name => "ucAddGoal$btnAddGoal")
      gps_form.submit(add_button)

      #Done!
    end

  end

  task :update => :environment do
    active_users = User.includes(:goals, :credential).where(:goals => {:date => Date.today})
    active_users.each do |user|
      byebug
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
      p "logged in"
      checkfield = gps_form.checkbox_with(:id => "dgGoals_ctl02_chkStatus")
      checkfield.check

      update_button = gps_form.button_with(:name => "btnUpdate")

      agent.submit(gps_form, update_button)
  end
end
end
