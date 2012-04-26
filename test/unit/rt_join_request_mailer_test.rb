require File.dirname(__FILE__) + '/../test_helper'

class RtJoinRequestMailerTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
  end

  def test_request
    @expected.subject = 'RtJoinRequestMailer#request'
    @expected.body    = read_fixture('request')
    @expected.date    = Time.now

    assert_equal @expected.encoded, RtJoinRequestMailer.create_request(@expected.date).encoded
  end

  def test_accept
    @expected.subject = 'RtJoinRequestMailer#accept'
    @expected.body    = read_fixture('accept')
    @expected.date    = Time.now

    assert_equal @expected.encoded, RtJoinRequestMailer.create_accept(@expected.date).encoded
  end

  def test_decline
    @expected.subject = 'RtJoinRequestMailer#decline'
    @expected.body    = read_fixture('decline')
    @expected.date    = Time.now

    assert_equal @expected.encoded, RtJoinRequestMailer.create_decline(@expected.date).encoded
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/rt_join_request_mailer/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
