ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address   => "smtp.mandrillapp.com",
  :port      => 587,
  :user_name => 'dogier140@poczta.fm',
  :password  => 'SgajFCY9dOt6wJcJgL7dKw'
}
