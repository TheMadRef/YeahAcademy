class PaymentReceiptMailer  < ActionMailer::Base
  def receipt(order_id, participant, total, url)
    @subject    = 'Facilitrax Notification: Payment Receipt'
    email_custom_text = EmailCustomText.find(1)
    if email_custom_text.receipt_header.blank?
    	@body["header"] = email_custom_text.master_header
    else
    	@body["header"] = email_custom_text.receipt_header
    end
    if email_custom_text.receipt_footer.blank?
    	@body["footer"] = email_custom_text.master_footer
    else
    	@body["footer"] = email_custom_text.receipt_footer
    end
    @body["order"] = order_id
    @body["total"] = total
    @body["participant"] = participant.first_name
    @recipients = participant.email
    @from       = 'ClassTrack Online Automated Email <tutormail@classtrackonline.com>'
    @sent_on    = Time.now
    @headers    = {}
  end

  def notification(order_id, participant, total, url)
    @subject    = MasterSetting.find(1).system_name + " Facilitrax Notification: Online Payment Receipt"
    @body["order"] = order_id
    @body["total"] = total
    @body["participant"] = participant.first_name + " " + participant.last_name
    @recipients = PaymentSetting.find(1).payment_notification_email
    @from       = 'ClassTrack Online Automated Email <tutormail@classtrackonline.com>'
    @sent_on    = Time.now
    @headers    = {}
  end
end
