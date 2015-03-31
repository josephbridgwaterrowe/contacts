RSpec::Matchers.define :have_content_type do |content_type|
  # rubocop:disable Metrics/LineLength
  CONTENT_HEADER_MATCHER = /^(.*?)(?:; charset=(.*))?$/

  chain :with_charset do |charset|
    @charset = charset
  end

  match do |response|
    _, content, charset = *content_type_header.match(CONTENT_HEADER_MATCHER).to_a

    if @charset
      @charset == charset && content == content_type
    else
      content == content_type
    end
  end

  failure_message do |response|
    if @charset
      "Content type #{content_type_header.inspect} should match #{content_type.inspect} with charset #{@charset}"
    else
      "Content type #{content_type_header.inspect} should match #{content_type.inspect}"
    end
  end

  failure_message_when_negated do |model|
    if @charset
      "Content type #{content_type_header.inspect} should not match #{content_type.inspect} with charset #{@charset}"
    else
      "Content type #{content_type_header.inspect} should not match #{content_type.inspect}"
    end
  end

  def content_type_header
    response.headers['Content-Type']
  end
  # rubocop:enable Metrics/LineLength
end
