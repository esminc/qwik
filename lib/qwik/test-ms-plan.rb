$LOAD_PATH << '..' unless $LOAD_PATH.include? '..'
require 'qwik/ml-session'
require 'qwik/test-module-ml'

if $0 == __FILE__
  $test = true
end

class TestMSPlan < Test::Unit::TestCase
  include TestModuleML

  def test_plan
    send_normal_mail 'bob@example.net'
    logs = @ml_config.logger.get_log
    eq '[test]: New ML by bob@example.net', logs[0]

    # Bob send a mail with a date tag.
    res = sm('[1970-01-15] t') { 't' }
    ok_log '[test]: QwikPost: t
[test:2]: Send:'
    page = @site['t']
    eq "* [1970-01-15] t\n{{mail(bob@example.net,0)\nt\n}}\n", page.load

    # test_footer
    now = Time.at(0)
    footer = @site.get_footer(now)
    eq "* Plan\n- [01-15] t\nhttp://example.com/test/t.html\n", footer

    # Bob send a mail.
    res = sm('tt') { 't' }
    ok_log ['[test]: QwikPost: tt', '[test:3]: Send:']
    eq '-- 
archive-> http://example.com/test/tt.html 
ML-> test@q.example.com

* Plan
- [01-15] t
http://example.com/test/t.html',
      $ml_sm.buffer[-9..-3].join("\n")
  end

  def test_plan2
    send_normal_mail('bob@example.net')
    eq '[test]: New ML by bob@example.net', @ml_config.logger.get_log[0]

    # Bob send a mail with a date tag.
    res = sm('[1970-01-15] t') { 't' }
    ok_log("[test]: QwikPost: t\n[test:2]: Send:")
    page = @site['t']
    eq "* [1970-01-15] t\n{{mail(bob@example.net,0)\nt\n}}\n", page.load

    # Bob send the same mail again.msame a same mail with a date tag.
    res = sm('[1970-01-15] t') { 't' }
    ok_log("[test]: QwikPost: t\n[test:3]: Send:")
    page = @site['t']
    eq "* [1970-01-15] t\n{{mail(bob@example.net,0)\nt\n}}\n{{mail(bob@example.net,0)\nt\n}}\n", page.load

    # test_footer
    now = Time.at(0)
    footer = @site.get_footer(now)
    eq "* Plan\n- [01-15] t\nhttp://example.com/test/t.html\n", footer
  end

  def test_plan_japanese
    send_normal_mail('bob@example.net')
    logs = @ml_config.logger.get_log
    eq '[test]: New ML by bob@example.net', logs[0]

    # Bob send a mail with a date tag.
    res = sm('[1970-01-15] あ') { 'い' }
    ok_log("[test]: QwikPost: 1\n[test:2]: Send:")
    page = @site['1']
    eq "* [1970-01-15] あ\n{{mail(bob@example.net,0)\nい\n}}\n", page.load

    # test_footer
    now = Time.at(0)
    footer = @site.get_footer(now)
    eq "* Plan\n- [01-15] あ\nhttp://example.com/test/1.html\n", footer

    # Bob send a mail.
    res = sm('うう') { 'ええ' }
    ok_log(['[test]: QwikPost: 2', '[test:3]: Send:'])
    str = $ml_sm.buffer[-12..-3].join("\n")
    eq '
ええ

-- 
archive-> http://example.com/test/2.html 
ML-> test@q.example.com

* Plan
- [01-15] あ
http://example.com/test/1.html'.set_sourcecode_charset.to_mail_charset,
      str
  end
end
