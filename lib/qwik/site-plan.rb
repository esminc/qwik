$LOAD_PATH << '..' unless $LOAD_PATH.include?('..')
require 'qwik/common-time'

module Qwik
  class Site
    def get_pages_with_date
      pages = []
      self.each {|page|
	tags = page.get_tags
	next if tags.nil?
	tags.each {|tag|
	  date = Action.date_parse(tag)
	  if date
	    pages << [page.key, date.to_i]
	  end
	}
      }
      return pages
    end
  end
end

if $0 == __FILE__
  require 'qwik/test-common'
  $test = true
end

if defined?($test) && $test
  class TestSitePlan < Test::Unit::TestCase
    include TestSession

    def test_all
      page = @site.create_new
      page.store("* [1970-01-01] t")
      page = @site.create_new
      page.store("* [1970-01-15] t")
      page = @site.create_new
      page.store("* [1970-02-01] t")
      page = @site.create_new
      page.store("* [1971-01-01] t")

      pages = @site.get_pages_with_date
      ok_eq([['1', -32400], ['2', 1177200], ['3', 2646000], ['4', 31503600]],
	    pages)
    end
  end
end

