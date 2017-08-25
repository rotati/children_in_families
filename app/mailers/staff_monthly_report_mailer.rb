class StaffMonthlyReportMailer < ApplicationMailer
  def send_report(users, file_name, previous_month, org_short_name, receiver)
    @previous_month = previous_month
    @receiver = receiver
    emails    = users.map(&:email)
    dev_email = ENV['DEV_EMAIL']
    ccemail = [ENV['CIF1_EMAIL'], ENV['CIF2_EMAIL']]
    attachments["#{file_name}"] = File.read(Rails.root.join("tmp/#{file_name}"))
    cc_email = ['chris@childreninfamilies.org', 'sam-ol@childreninfamilies.org'] if org_short_name == 'cif'
    mail(to: emails, subject: "Subordinates Performance Report of #{@previous_month}", bcc: dev_email, cc: cc_email)
  end
end
