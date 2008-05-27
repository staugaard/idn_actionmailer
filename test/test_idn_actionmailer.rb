require "test/unit"

require "idn_actionmailer"

ActionMailer::Base.template_root = "#{File.dirname(__FILE__)}/fixtures"

class TestMailer < ActionMailer::Base
  
  default_url_options[:host] = 'www.basecamphq.com'
  
  def signed_up_with_url(recipient)
    @recipients   = recipient
    @subject      = "[Signed up] Welcome"
    @from         = "bla <system@loudthinking.com>"
    @sent_on      = Time.local(2004, 12, 12)

    @body["recipient"]   = recipient
  end

  class <<self
    attr_accessor :received_body
  end

  def receive(mail)
    self.class.received_body = mail.body
  end
end

class ActionMailerUrlTest < Test::Unit::TestCase
  include ActionMailer::Quoting

  def encode( text, charset="utf-8" )
    quoted_printable( text, charset )
  end

  def new_mail( charset="utf-8" )
    mail = TMail::Mail.new
    mail.mime_version = "1.0"
    if charset
      mail.set_content_type "text", "plain", { "charset" => charset }
    end
    mail
  end

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  def test_single_address

    expected = new_mail
    expected.to      = 'bla <mick@xn--brndendekrlighed-vobh.dk>'
    expected.subject = "[Signed up] Welcome"
    expected.body    = "Hello there"
    expected.from    = "bla <system@loudthinking.com>"
    expected.date    = Time.local(2004, 12, 12)

    created = nil
    assert_nothing_raised { created = TestMailer.create_signed_up_with_url('bla <mick@brændendekærlighed.dk>') }
    assert_not_nil created
    assert_equal expected.encoded, created.encoded

    assert_nothing_raised { TestMailer.deliver_signed_up_with_url('bla <mick@brændendekærlighed.dk>') }
    assert_not_nil ActionMailer::Base.deliveries.first
    assert_equal expected.encoded, ActionMailer::Base.deliveries.first.encoded
  end

  def test_multi_addresses
    expected = new_mail
    expected.to      = ['bla <mick@xn--brndendekrlighed-vobh.dk>', 'mick@xn--brndendekrlighed-vobh.dk']
    expected.subject = "[Signed up] Welcome"
    expected.body    = "Hello there"
    expected.from    = "bla <system@loudthinking.com>"
    expected.date    = Time.local(2004, 12, 12)

    created = nil
    assert_nothing_raised { created = TestMailer.create_signed_up_with_url(['bla <mick@brændendekærlighed.dk>', 'mick@brændendekærlighed.dk']) }
    assert_not_nil created
    assert_equal expected.encoded, created.encoded
  end
end