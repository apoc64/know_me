require 'simplecov'
SimpleCov.start
require_relative "../lib/complete_me"
require 'pry'
require "Minitest/autorun"
require "Minitest/pride"

class CompleteMeTest < Minitest::Test

  def setup
  end

  def test_it_exists
    complete_me = CompleteMe.new
    assert_instance_of CompleteMe, complete_me
  end

  def test_find
    complete_me = CompleteMe.new
    file = "dog\ncat\nbear\nmonkey\ncattle"
    complete_me.populate(file)
    actual = complete_me.find('bear')
    assert_instance_of Node, actual
    assert_equal 'r', actual.character
    assert_equal 'bear', actual.to_s
    assert_nil complete_me.find('hyena')
  end

  def test_include_word?
    complete_me = CompleteMe.new
    word = 'phrase'
    complete_me.insert(word)
    assert complete_me.include_word?(word)
    refute complete_me.include_word?('something')
    # binding.pry
    complete_me.insert("cat")
    complete_me.insert("cattle")
    assert complete_me.include_word?("cat")
    assert complete_me.include_word?("cattle")
    refute complete_me.include_word?('something')
  end

  def test_it_inserts
    complete_me = CompleteMe.new
    word = "phrase"
    complete_me.insert(word)
    assert complete_me.include_word?(word)
    word = "pharoh"
    complete_me.insert(word)
    word = "police"
    complete_me.insert(word)
    word = "Pharoh"
    complete_me.insert(word)
    word = "monkey"
    complete_me.insert(word)
    word = "dog"
    complete_me.insert(word)
    word = "xxoxxxxxo"
    complete_me.insert(word)
    word = "Phrase"
    complete_me.insert(word)
    assert complete_me.include_word?('pharoh')
    assert complete_me.include_word?('police')
    assert complete_me.include_word?('monkey')
    assert complete_me.include_word?('Pharoh')
    assert complete_me.include_word?('dog')
    assert complete_me.include_word?('xxoxxxxxo')
    assert complete_me.include_word?('Phrase')
  end

  def test_it_inserts_words
    complete_me = CompleteMe.new
    words = ['dog', 'cat', 'cattle', 'zebra']
    complete_me.insert_words(words)
    root = complete_me.root
    root_end_nodes = root.get_end_nodes
    assert_equal root_end_nodes.count, 4
    assert_instance_of Node, root_end_nodes[0]
    assert_instance_of Node, root_end_nodes[1]
    assert_instance_of Node, root_end_nodes[2]
    assert_instance_of Node, root_end_nodes[3]
  end

  def test_it_populates
    complete_me = CompleteMe.new
    file = "dog\ncat\nbear\nmonkey\ncattle"
    complete_me.populate(file)
    assert complete_me.include_word?("cat")
    assert complete_me.include_word?("dog")
    assert complete_me.include_word?("bear")
    assert complete_me.include_word?("monkey")
    assert complete_me.include_word?("cattle")
    refute complete_me.include_word?("mon")
    refute complete_me.include_word?("cats")
    refute complete_me.include_word?("do")
  end

  def test_suggest
    complete_me = CompleteMe.new
    file = "dog\ncat\nbear\nmonkey\ncattle\ncattles"
    complete_me.populate(file)
    assert_equal ['monkey'], complete_me.suggest('mon')
    assert_equal ['dog'], complete_me.suggest('do')
    assert_equal ['cat', 'cattle', 'cattles'], complete_me.suggest('ca')
    assert_equal [], complete_me.suggest('hyena')
  end

  def test_it_sorts_suggestions_by_weight
    complete_me = CompleteMe.new
    file = "dog\ncat\nmonkey\ncattle\ncattles"
    complete_me.populate(file)

    assert_equal ['cat', 'cattle', 'cattles'], complete_me.suggest('ca')
    root = complete_me.root
    root_end_nodes = root.get_end_nodes
    node = root_end_nodes[2]
    node.weight = 2
    # binding.pry
    assert_equal ['cattle', 'cat', 'cattles'], complete_me.suggest('ca')
    cattles = root_end_nodes[3]
    cattles.weight = 4
    assert_equal ['cattles', 'cattle', 'cat'], complete_me.suggest('ca')
    complete_me.insert('cats')

    assert_equal ['cattles', 'cattle', 'cat', 'cats'], complete_me.suggest('ca')
    cattles.weight = 0
    assert_equal ['cattle', 'cat', 'cats', 'cattles'], complete_me.suggest('ca')
  end

  def test_it_accurately_counts_the_number_of_words_in_a_trie
    # skip
    trie = CompleteMe.new
    assert_equal 0, trie.count

    expected = 10
    words = ['dog', 'cat', 'bird', 'monkey', 'chimp', 'whale', 'dolphin', 'eagle', 'aardvark', 'ant']
    trie.insert_words(words)
    actual = trie.count
    assert_equal expected, actual

    trie = CompleteMe.new
    expected = 10
    words = ['dog', 'cat', 'cat', 'bird', 'bird', 'monkey', 'chimp', 'whale', 'dolphin', 'eagle', 'aardvark', 'ant']
    trie.insert_words(words)
    actual = trie.count
    assert_equal expected, actual
    #
    # whole_dict = CompleteMe.new
    # dict_count = 235886
    # whole_dict.populate(File.read("/usr/share/dict/words"))
    # assert_equal dict_count, whole_dict.count
  end

  def test_select_increments_the_weight
    complete_me = CompleteMe.new
    file = "dog\ncat\nbear\nmonkey\ncattle\ncattles"
    complete_me.populate(file)
    assert_equal ['cat', 'cattle', 'cattles'], complete_me.suggest('ca')
    complete_me.select('ca', 'cattle')
    complete_me.select('ca', 'cattle')
    complete_me.select('ca', 'cattle')
    assert_equal ['cattle', 'cat', 'cattles'], complete_me.suggest('ca')
  end

  def test_select_increments_by_substing
    cm = CompleteMe.new
    file = "dog\ncat\nbear\nmonkey\ncattle\ncattles"
    cm.populate(file)
    # binding.pry
    cm.select('ca', 'cattle')
    cm.select('ca', 'cattle')
    assert_equal ['cattle', 'cat', 'cattles'], cm.suggest('ca')
    cm.select('cat', 'cattles')
    assert_equal ['cattles', 'cattle', 'cat'], cm.suggest('cat')
    assert_equal ['cattle', 'cattles', 'cat'], cm.suggest('ca')
    cm.select('cat', 'cat')
    cm.select('cat', 'cat')
    assert_equal ['cat', 'cattles', 'cattle'], cm.suggest('cat')
  end

  def test_it_can_delete_words
    cm = CompleteMe.new
    file = "dog\ncat\nbear\nmonkey\ncattle\ncattles"
    cm.populate(file)
    assert cm.include_word?("cattle")
    assert cm.include_word?("dog")
    assert 6, cm.count
    cm.delete("evrevervre")
    assert_equal 6, cm.count
    cm.delete("cats")
    assert_equal 6, cm.count

    cm.delete("cattle")
    refute cm.include_word?("cattle")
    assert cm.include_word?("cattles")
    assert_equal 5, cm.count

    node = cm.find("cat")
    assert_equal 1, node.children.count
    cm.delete("cattles")
    refute cm.include_word?("cattles")
    assert cm.include_word?("cat")
    assert_equal 0, node.children.count

    assert_equal 4, cm.root.children.count
    cm.delete("dog")
    assert_equal 3, cm.root.children.count
    assert_equal 3, cm.count
  end

  # def test_it_can_parse_csv
  #   # skip
  #   cm = CompleteMe.new
  #   addresses = cm.parse("addresses.csv")
  #   assert_equal "1776 Curtis St Unit 2803", addresses[0]
  # end

  # def test_it_adds_addresses_to_dictionary
  #   # skip
  #   cm = CompleteMe.new
  #   addresses = cm.parse("addresses.csv")
  #   cm.insert_words(addresses)
  #
  #   assert cm.include_word?("3085 W Virginia Ave")
  #   refute cm.include_word?("1234545667 N Hollywood Blvd")
  # end

  def test_it_can_suggest_mid_strings
    cm = CompleteMe.new
    file = "dog\ncat\nbear\nmonkey\ncattle\ncattles"
    cm.populate(file)

    suggestions = cm.mid_string_suggest("ttl")
    assert_equal ["cattle", "cattles"], suggestions
  end

end
