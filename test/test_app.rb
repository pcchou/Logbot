
require './app'
require 'pork'
Pork.autorun

Pork::API.describe Util do
  include Util

  %w[http://example.com
     http://example.com/
     http://example.com/path
     http://example.com/path/
     http://example.com/中文
     http://example.com/中文/].each do |url|

    would 'autolink' do
      expect(autolink("This is a link #{url}")).
        eq("This is a link <a href=\"#{url}\">#{url}</a>")
    end

    would 'not autolink' do
      text = "This is not a link#{url}"
      expect(autolink(text)).eq(text)
    end

    would 'autolink with <>' do
      expect(autolink("This is a link &lt;#{url}&gt;")).
        eq("This is a link &lt;<a href=\"#{url}\">#{url}</a>&gt;")
    end
  end

  def verify_text msg
    expect(user_nick(  msg)).eq('name')
    expect(user_action(msg)).eq(nil)
    expect(user_text(  msg)).eq('&lt;hi&gt; hi')
    expect(user_text_without_tags(msg)).eq('&lt;hi&gt; hi')
  end

  would 'for regular user' do
    verify_text('nick' => 'name'       , 'msg' => '<hi> hi')
  end

  would 'for slack user' do
    verify_text('nick' => '_slack_bot1', 'msg' => '<name> <hi> hi')
  end

  would 'for action' do
    msg = {'nick' => 'name', 'msg' => "\u0001ACTION hug\u0001"}

    expect(user_nick(  msg)).eq('*')
    expect(user_action(msg)).eq('hug')
    expect(user_text(  msg)).eq('<span class="nick">name</span>&nbsp;hug')
    expect(user_text_without_tags(msg)).eq('*hug*')
  end
end
