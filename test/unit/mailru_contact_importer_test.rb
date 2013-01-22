dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"

module Wallet
  class MailruContactImporterTest < ContactImporterTestCase
    def setup
      super
      @account = TestAccounts[:mailru]
    end

    def test_guess_importer
      assert_equal Contacts::Mailru, Contacts.guess_importer('test@mail.ru')
      assert_equal Contacts::Mailru, Contacts.guess_importer('test@list.ru')
      assert_equal Contacts::Mailru, Contacts.guess_importer('test@inbox.ru')
      assert_equal Contacts::Mailru, Contacts.guess_importer('test@bk.ru')
    end

    def test_successful_login
      Contacts.new(:mailru, @account.username, @account.password)
    end

    def test_importer_fails_with_invalid_password
      assert_raise(Contacts::AuthenticationError) do
        Contacts.new(:mailru, @account.username, "wrong_password")
      end
    end

    def test_importer_fails_with_blank_password
      assert_raise(Contacts::AuthenticationError) do
        Contacts.new(:mailru, @account.username, "")
      end
    end

    def test_importer_fails_with_blank_username
      assert_raise(Contacts::AuthenticationError) do
        Contacts.new(:mailru, "", @account.password)
      end
    end

    def test_fetch_contacts
      contacts = Contacts.new(:mailru, @account.username, @account.password).contacts
      @account.contacts.each do |contact|
        assert contacts.include?(contact), "Could not find: #{contact.inspect} in #{contacts.inspect}"
      end
    end
  end
end
