require File.dirname(__FILE__) + '/../test_helper'

class FreeAgentMailerTest < Test::Unit::TestCase
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

  def test_invite
    @expected.subject = 'FreeAgentMailer#invite'
    @expected.body    = read_fixture('invite')
    @expected.date    = Time.now

    assert_equal @expected.encoded, FreeAgentMailer.create_invite(@expected.date).encoded
  end

  def test_accept
    @expected.subject = 'FreeAgentMailer#accept'
    @expected.body    = read_fixture('accept')
    @expected.date    = Time.now

    assert_equal @expected.encoded, FreeAgentMailer.create_accept(@expected.date).encoded
  end

  def test_decline
    @expected.subject = 'FreeAgentMailer#decline'
    @expected.body    = read_fixture('decline')
    @expected.date    = Time.now

    assert_equal @expected.encoded, FreeAgentMailer.create_decline(@expected.date).encoded
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/free_agent_mailer/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
