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
    find_prefixes_aba = :btrie.find_prefixes(<<"aba">>, btn0)
    find_prefixes_aaaaaaaaaaaaaaa = :btrie.find_prefixes(<<"aaaaaaaaaaaaaaa">>, btn0)
    appended = :btrie.find_prefixes(<<"ss">>, btn0)

    assert fetch_keys_similar == ["ab", "aba", "abcdefghijklmnopqrstuvwxyz"]
    assert find_prefixes_aba == [{"ab", 5}, {"aba", 6}]
    assert find_prefixes_aaaaaaaaaaaaaaa == [{"aa", 1}, {"aaa", 2}, {"aaaaaaaa", 3}, {"aaaaaaaaaaa", 4}]
    assert appended == [{"ss", [2]}]
    assert fetch_keys_similar_xy == []

  end

  test "trie empty new" do
    rn0 = :trie.new()
    assert rn0 == []
  end

  test "trie tests" do
    tn0 = :trie.new([
      {'abcdefghijklmnopqrstuvwxyz', 9},
      {'ammmmmmm',      7},
      {'aaaaaaaaaaa',   4},
      {'aaa',           2},
      {'ab',            0},
      {'ab',            5},
      {'aa',            1},
      {'aba',           6},
      {'aaaaaaaa',      3}])

      find_prefixes_aba = :trie.find_prefixes('aba', tn0)
      find_prefixes_aaaaaaaaaaaaaaa = :trie.find_prefixes('aaaaaaaaaaaaaaa', tn0)

      assert tn0 == {97, 97, {{{97, 109, {{{97, 97, {{{97, 97, {{{97, 97, {{{97, 97, {{{97, 97, {{{97, 97, {{{97, 97, {{'aa', 4}}}, 3}}}, :error}}}, :error}}}, :error}}}, :error}}}, 2}}}, 1}, {{97, 99, {{[], 6}, {[], :error}, {'defghijklmnopqrstuvwxyz', 9}}}, 5}, {[], :error}, {[], :error}, {[], :error}, {[], :error}, {[], :error}, {[], :error}, {[], :error}, {[], :error}, {[], :error}, {[], :error}, {'mmmmmm', 7}}}, :error}}}
      assert find_prefixes_aba ==   [{'ab', 5}, {'aba', 6}] # :( - not ok
      assert find_prefixes_aaaaaaaaaaaaaaa == [{'aa', 1}, {'aaa', 2}, {'aaaaaaaa', 3}, {'aaaaaaaaaaa', 4}]
  end

  test "trie find similar" do
    tn0 = :trie.new([
      {'abcdefghijklmnopqrstuvwxyz', 9},
      {'ammmmmmm',      7},
      {'aaaaaaaaaaa',   4},
      {'aaa',           2},
      {'ab',            0},
      {'ab',            5},
      {'aa',            1},
      {'aba',           6},
      {'aaaaaaaa',      3}])

      fold_similar = :trie.fold_similar('ab', fn v, d , e -> {v, d, e} end, [], tn0)

      assert fold_similar ==  {'abcdefghijklmnopqrstuvwxyz', 9, {'aba', 6, {'ab', 5, []}}}
  end

  test "map to list for index" do

    obj_list1 = Map.new(
          [
            { 1, %{ id: 1, name: "apple"}},
            { 2, %{ id: 2, name: "pear"}},
            { 3, %{ id: 3, name: "peach"}},
            { 4, %{ id: 4, name: "blossom"}},
            { 5, %{ id: 5, name: "ananas"}}
          ])

    obj_list2 = Map.new(
            [
              { 6, %{ id: 6, name: "cowboy"}},
              { 7, %{ id: 7, name: "horse"}},
              { 8, %{ id: 8, name: "sheep"}}
            ])

    obj_list3 = Map.new(
              [
                { 9, %{ id: 9, name: "p_something"}},
                { 10, %{ id: 10, name: "orange_fresh"}}
              ])
    index =
        (obj_list1
          |> Map.values()
          |> Enum.map(fn %{id: id, name: name} -> {String.to_charlist(name), {id, 1, "fruits"}} end)) ++
        (obj_list2
          |> Map.values()
          |> Enum.map(fn %{id: id, name: name} -> {String.to_charlist(name), {id, 1, "ranch"}} end)) ++
        (obj_list3
          |> Map.values()
          |> Enum.map(fn %{id: id, name: name} -> {String.to_charlist(name), {id, 1, "drinks"}} end))
        |> :trie.new()

    assert index != []
    fold_similar = :trie.fold_similar('p', fn v, d , e -> {v, d, e} end, [], index)
    assert fold_similar ==  {'pear', {2, 1, "fruits"}, {'peach', {3, 1, "fruits"}, {'p_something', {9, 1, "drinks"}, []}}}

    end
end