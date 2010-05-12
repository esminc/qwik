require 'test/unit'
require 'algorithm/diff'
require 'test_cases'

class DiffTest < Test::Unit::TestCase

  include DiffStringTests
  include DiffArrayTests
  include DiffStressTest

  def difftest(a, b)
    diff = Diff.diff(a, b)
    c = a.patch(diff)
    assert_equal(b, c)
    diff = Diff.diff(b, a)
    c = b.patch(diff)
    assert_equal(a, c)
  end

end

