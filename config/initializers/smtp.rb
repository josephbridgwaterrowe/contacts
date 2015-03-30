ActionMailer::Base.smtp_settings = {
  :address => ENV.fetch('SMTP_SERVER'),
  :authentication => :plain
}
ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings ||= {}
ActionMailer::Base.default_url_options[:host] = ENV.fetch('DOMAIN')
