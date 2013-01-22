dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"

module Wallet
  class GmailContactImporterTest < ContactImporterTestCase
    def setup
      super
      @account = TestAccounts[:gmail]
    end

    def test_guess_importer
      assert_equal Contacts::Gmail, Contacts.guess_importer('test@gmail.com')
      assert_equal Contacts::Gmail, Contacts.guess_importer('test@googlemail.com')
    end

    def test_guess
      contacts = Contacts.guess(@account.username, @account.password)

      @account.contacts.each do |contact|
        assert contacts.include?(contact), "Could not find: #{contact.inspect} in #{contacts.inspect}"
      end
    end

    def test_successful_login
      Contacts.new(:gmail, @account.username, @account.password)
    end

    def test_importer_fails_with_invalid_password
      assert_raise(Contacts::AuthenticationError) do
        Contacts.new(:gmail, @account.username, "wrong_password")
      end
    end

    def test_importer_fails_with_blank_password
      assert_raise(Contacts::AuthenticationError) do
        Contacts.new(:gmail, @account.username, "")
      end
    end

    def test_importer_fails_with_blank_username
      assert_raise(Contacts::AuthenticationError) do
        Contacts.new(:gmail, "", @account.password)
      end
    end

    def test_fetch_contacts
      contacts = Contacts.new(:gmail, @account.username, @account.password).contacts
      @account.contacts.each do |contact|
        assert contacts.include?(contact), "Could not find: #{contact.inspect} in #{contacts.inspect}"
      end
    end
  end
end
