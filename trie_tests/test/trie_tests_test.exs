defmodule TrieTestsTest do
  use ExUnit.Case
  doctest TrieTests

  test "greets the world" do
    assert TrieTests.hello() == :world
  end

  test "btrie new" do
    btn0 = :btrie.new([<<"a">>])
    btn1 = :btrie.new([
      {<<"ammmmmmm">>,      7},
      {<<"aaaaaaaaaaa">>,   4},
      {<<"aaa">>,           2},
      {<<"ab">>,            0},
      {<<"ab">>,            5},
      {<<"aa">>,            1},
      {<<"aba">>,           6},
      {<<"aaaaaaaa">>,      3}])
    assert btn0 == {97, 97, {{"", :empty}}}
    assert btn1 == {97, 97,
    {{{97, 109,
       {{{97, 97,
          {{{97, 97,
             {{{97, 97,
                {{{97, 97,
                   {{{97, 97,
                      {{{97, 97, {{{97, 97, {{"aa", 4}}}, 3}}}, :error}}},
                     :error}}}, :error}}}, :error}}}, 2}}}, 1},
        {{97, 97, {{"", 6}}}, 5}, {"", :error}, {"", :error},
        {"", :error}, {"", :error}, {"", :error}, {"", :error},
        {"", :error}, {"", :error}, {"", :error}, {"", :error},
        {"mmmmmm", 7}}}, :error}}}
  end

  test "btrie new with complex value for a key" do
    btn0 = :btrie.new([
      {<<"ammmmmmm">>, %{id: "1", score: "0.5"}},
      {<<"ammbbeqmmmmm">>, %{id: "1", score: "0.5"}},
      {<<"amxsd">>, %{id: "1", score: "0.5"}},
      {<<"aaaaaaaaaaa">>, %{id: "2", score: "0.6"}},
    ])

    fetch_keys_similar = :btrie.fetch_keys_similar(<<"am">>, btn0)
    fetch = :btrie.fetch(<<"ammmmmmm">>, btn0)
    find_prefixes = :btrie.find_prefixes(<<"am">>, btn0)
    # find_similar = :btrie.find_similar("am", btn0) #PRIVATE
    # find_match = :btrie.find_match(<<"am">>, btn0) #PRIVATE

    assert btn0 == {97, 97, {{{97, 109, {{"aaaaaaaaa", %{id: "2", score: "0.6"}}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {{109, 120, {{{98, 109, {{"beqmmmmm", %{id: "1", score: "0.5"}}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"mmmm", %{id: "1", score: "0.5"}}}}, :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"sd", %{id: "1", score: "0.5"}}}}, :error}}}, :error}}}
    assert fetch == %{id: "1", score: "0.5"}
    assert fetch_keys_similar == ["ammbbeqmmmmm", "ammmmmmm", "amxsd"]
    assert find_prefixes == []

  end

  test "btrie fetch keys similar " do
    btn0 = :btrie.new([
      {<<"abcdefghijklmnopqrstuvwxyz">>, 9},
      {<<"ammmmmmm">>,      7},
      {<<"aaaaaaaaaaa">>,   4},
      {<<"aaa">>,           2},
      {<<"ab">>,            0},
      {<<"ab">>,            5},
      {<<"aa">>,            1},
      {<<"aba">>,           6},
      {<<"aaaaaaaa">>,      3}])

      btn0 = :btrie.append(<<"ss">>, 2, btn0)

    fetch_keys_similar = :btrie.fetch_keys_similar(<<"ab">>, btn0)
    fetch_keys_similar_xy = :btrie.fetch_keys_similar(<<"xy">>, btn0)
    find = :btrie.find(<<"ab">>, btn0)
    fetch = :btrie.fetch(<<"ab">>, btn0)
    # find_match = :btrie.find_match("ab", btn0) - private
    find_prefix = :btrie.find_prefix(<<"ab">>, btn0)
    find_prefixes = :btrie.find_prefixes(<<"ab">>, btn0)
    appended = :btrie.find_prefixes(<<"ss">>, btn0)

    assert fetch_keys_similar == ["ab", "aba", "abcdefghijklmnopqrstuvwxyz"]
    assert find == {:ok, 5}
    assert find_prefix == {:ok, 5}
    assert find_prefixes == [{"ab", 5}]
    assert fetch == 5
    assert appended == [{"ss", [2]}]
    assert fetch_keys_similar_xy == []

  end

  test "trie empty new" do
    rn0 = :trie.new()
    assert rn0 == []
  end

  test "trie add key to existing node" do
    tn0 = :trie.new()

    :trie.append("a", 2, tn0)

    tn4 = :trie.store("aabcde", 3, tn0)
    tn00 = :trie.new(["ab"])
    # ,"aa"])
    tn1 = :trie.new([{"abcdefghijklmnopqrstuvwxyz", 1},{"aac", 2}])
    tn3 = :trie.new([{"cowboy", 1}, {"ranch", 2}])


    assert tn0 != []
    assert tn00 != []

  end
end
