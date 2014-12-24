
require './app'
require 'pork'
Pork.autorun

Pork::API.describe Util do
  include Util
  url = 'http://example.com/'

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
