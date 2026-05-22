class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_FROM", "noreply@caixaflow.com.br")
  layout "mailer"
end
