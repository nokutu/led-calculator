class UserMailer < ApplicationMailer
  include ApplicationHelper

  default from: 'jorgelopezfueyo@gmail.com'

  def result_email(calculation)
    @calculation = calculation
    @code = encode(@calculation.id)
    mail(to: @calculation.email, subject: 'Start saving with Integra')
  end
end
