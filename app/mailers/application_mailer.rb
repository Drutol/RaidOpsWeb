class ApplicationMailer < ActionMailer::Base
  default from: "notifications@raidops.net"
  layout 'mailer'
end
