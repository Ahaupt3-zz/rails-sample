# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "noreply@rubypost.com"
  layout "mailer"
end
