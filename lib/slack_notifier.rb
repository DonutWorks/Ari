require 'slack-notify'
require 'singleton'

class SlackNotifier
  def self.notify(msg)
    client.notify(msg) unless Rails.env.development? or Rails.env.test?
  end

private
  def self.client
    @client ||= SlackNotify::Client.new("donutworks", "G0QAYXA6uqygRTXjXCZ5Th2g")
  end
end