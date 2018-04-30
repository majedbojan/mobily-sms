require "mobily/sms/version"
require_relative 'mobily_api_auth'
require_relative 'mobily_account'
require_relative 'mobily_sms'
require_relative 'mobily_formatted_sms'
require_relative 'mobily_sender'
require_relative 'mobily_api_error'

class Sms

  USERNAME = Rails.application.secrets.mobilyws[:username]
  PASSWORD = Rails.application.secrets.mobilyws[:password]
  SMSHOST  = Rails.application.secrets.mobilyws[:smshost]

  def self.send(recipient_mobile, message)
    if check_can_send
      begin
        sms = MobilySMS.new(MobilyApiAuth.new(USERNAME, PASSWORD))
        sms.add_number(recipient_mobile)

        sms.sender = SMSHOST

        sms.msg = message
        sms.send
        return 'sms'
      rescue => e
        Rails.logger.debug "ERROR: #{e}"
        Rails.logger.debug "sms sender: #{sms.sender}"
        Rails.logger.debug "sms: #{sms.inspect}"
      end
    end
    return { error_code: '1302' }
  end

  def self.check_can_send
    return true if MobilySMS.can_send?
    false
  end

  def self.schedule(mobile, password, recipient_mobile)
    sms = MobilySMS.new(MobilyApiAuth.new(mobile, password))
    sms.add_number(recipient_mobile)
    sms.sender = SMSHOST
    sms.msg = 'Testing تجريب ^&**\nFrom Ruby, scheduled'
    sms.schedule_to_send_on(25, 12, 2020, 12, 0, 0)
    sms.delete_key = '666'
    sms.send
  end

  def self.send_formatted(mobile, password, recipient_one, recipient_two)
    auth = MobilyApiAuth.new(mobile, password)
    msg = 'Hi (1), your subscription will end on (2).'
    sms = MobilyFormattedSMS.new(auth, [recipient_one, recipient_two], SMSHOST)

    sms.add_variable_for_number(recipient_one, '(1)', 'Martin')
    sms.add_variable_for_number(recipient_one, '(2)', '31/12/2017')
    sms.add_variable_for_number(recipient_two, '(1)', 'Tim')
    sms.add_variable_for_number(recipient_two, '(2)', '01/11/2020')
    sms.send
  end

  def self.send_scheduled_formatted(mobile, password, recipient_one, recipient_two)
    auth = MobilyApiAuth.new(mobile, password)
    msg = 'Hi (1), your subscription will end on (2)..'

    sms = MobilyFormattedSMS.new(auth, [recipient_one, recipient_two], SMSHOST, msg )

    sms.add_variable_for_number(recipient_one, '(1)', 'Lee')
    sms.add_variable_for_number(recipient_one, '(2)', '31/11/2019')
    sms.add_variable_for_number(recipient_two, '(1)', 'James')
    sms.add_variable_for_number(recipient_two, '(2)', '03/10/2017')
    sms.delete_key = '666'
    sms.schedule_to_send_on(25, 12, 2020, 12, 0, 0)
    sms.send
  end

  # def change_pass(mobile, old_pass, new_pass)
  #   account = MobilyAccount.new(MobilyApiAuth.new(mobile, old_pass))
  #   account.change_password(new_pass)
  # end

  # def forgot_pass_email(mobile, password)
  #   account = MobilyAccount.new(MobilyApiAuth.new(mobile, password))
  #   account.forgot_password
  # end

  # def forgot_pass_mobile(mobile, password)
  #   account = MobilyAccount.new(MobilyApiAuth.new(mobile, password))
  #   account.forgot_password(false)
  # end

  # def check_balance(mobile, password)
  #   account = MobilyAccount.new(MobilyApiAuth.new(mobile, password))
  #   balance = account.check_balance
  #   puts '%s credits available, total %s' % [balance['current'], balance['total']]
  # end

  # def delete_sms(mobile, password)
  #   sms = MobilySMS.new(MobilyApiAuth.new(mobile, password))
  #   sms.delete_key = '666'
  #   sms.delete
  # end

  # def add_alpha_sender(mobile, password, alpha_sender)
  #   sender = MobilySender.new(MobilyApiAuth.new(mobile, password))
  #   sender.request_alphabetical_license(alpha_sender)
  # end

  # def list_senders(mobile, password)
  #   sender = MobilySender.new(MobilyApiAuth.new(mobile, password))
  #   senders_by_status = sender.get_activation_status_for_all_senders
  #   print 'Active Senders: ', senders_by_status['active'].each { |x| x }
  #   print 'Pending Senders: ', senders_by_status['pending'].each { |x| x }
  #   print 'Inactive Senders: ', senders_by_status['notActive'].each { |x| x }
  # end

  # def add_mobile_sender(mobile, password, mobile_sender)
  #   sender = MobilySender.new(MobilyApiAuth.new(mobile, password))
  #   begin
  #     return sender.request_mobile_number_license(mobile_sender)
  #   rescue MobilyApiError => e
  #     puts e.msg_english, e.msg_arabic
  #   end
  # end

  # def activate_mobile_sender(mobile, password, sender_id, activation_code)
  #   sender = MobilySender.new(MobilyApiAuth.new(mobile, password))
  #   sender.activate_mobile_number_license(sender_id, activation_code)
  # end

  # def check_activation_status(mobile, password, sender_id)
  #   sender = MobilySender.new(MobilyApiAuth.new(mobile, password))
  #   if sender.is_mobile_number_license_active?(sender_id)
  #     print 'Activated!'
  #   else
  #     print 'Not activated!'
  #   end
  # end
end
