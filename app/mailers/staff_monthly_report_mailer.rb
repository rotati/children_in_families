class StaffMonthlyReportMailer < ApplicationMailer
  def send_report(users, file_name, previous_month)
    @previous_month = previous_month
    emails    = users.map(&:email)
    dev_email = ['sengpirun.rain@gmail.com']
    attachments["#{file_name}"] = File.read(Rails.root.join("tmp/#{file_name}"))
    mail(to: emails, subject: "Subordinates Performence Report of #{@previous_month}", bcc: dev_email)
  end
end
