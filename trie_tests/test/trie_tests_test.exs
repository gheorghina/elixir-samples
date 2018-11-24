defmodule TrieTestsTest do
  use ExUnit.Case
  doctest TrieTests

  test "greets the world" do
    assert TrieTests.hello() == :world
  end

  test "btrie new" do
    btn0 = :btrie.new([<<"a">>])

    btn1 =
      :btrie.new([
        {<<"ammmmmmm">>, 7},
        {<<"aaaaaaaaaaa">>, 4},
        {<<"aaa">>, 2},
        {<<"ab">>, 0},
        {<<"ab">>, 5},
        {<<"aa">>, 1},
        {<<"aba">>, 6},
        {<<"aaaaaaaa">>, 3}
      ])

    assert btn0 == {97, 97, {{"", :empty}}}

    assert btn1 ==
             {97, 97,
              {{{97, 109,
                 {{{97, 97,
                    {{{97, 97,
                       {{{97, 97,
                          {{{97, 97,
                             {{{97, 97, {{{97, 97, {{{97, 97, {{"aa", 4}}}, 3}}}, :error}}},
                               :error}}}, :error}}}, :error}}}, 2}}}, 1},
                  {{97, 97, {{"", 6}}}, 5}, {"", :error}, {"", :error}, {"", :error},
                  {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error},
                  {"", :error}, {"", :error}, {"mmmmmm", 7}}}, :error}}}
  end

  test "btrie new with complex value for a key" do
    btn0 =
      :btrie.new([
        {<<"ammmmmmm">>, %{id: "1", score: "0.5"}},
        {<<"ammbbeqmmmmm">>, %{id: "1", score: "0.5"}},
        {<<"amxsd">>, %{id: "1", score: "0.5"}},
        {<<"aaaaaaaaaaa">>, %{id: "2", score: "0.6"}}
      ])

    fetch_keys_similar = :btrie.fetch_keys_similar(<<"am">>, btn0)
    fetch = :btrie.fetch(<<"ammmmmmm">>, btn0)
    find_prefixes = :btrie.find_prefixes(<<"am">>, btn0)

    assert btn0 ==
             {97, 97,
              {{{97, 109,
                 {{"aaaaaaaaa", %{id: "2", score: "0.6"}}, {"", :error}, {"", :error},
                  {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error},
                  {"", :error}, {"", :error}, {"", :error}, {"", :error},
                  {{109, 120,
                    {{{98, 109,
                       {{"beqmmmmm", %{id: "1", score: "0.5"}}, {"", :error}, {"", :error},
                        {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error},
                        {"", :error}, {"", :error}, {"", :error},
                        {"mmmm", %{id: "1", score: "0.5"}}}}, :error}, {"", :error}, {"", :error},
                     {"", :error}, {"", :error}, {"", :error}, {"", :error}, {"", :error},
                     {"", :error}, {"", :error}, {"", :error}, {"sd", %{id: "1", score: "0.5"}}}},
                   :error}}}, :error}}}

    assert fetch == %{id: "1", score: "0.5"}
    assert fetch_keys_similar == ["ammbbeqmmmmm", "ammmmmmm", "amxsd"]
    assert find_prefixes == []
  end

  test "btrie fetch keys similar " do
    btn0 =
      :btrie.new([
        {<<"abcdefghijklmnopqrstuvwxyz">>, 9},
        {<<"ammmmmmm">>, 7},
        {<<"aaaaaaaaaaa">>, 4},
        {<<"aaa">>, 2},
        {<<"ab">>, 0},
        {<<"ab">>, 5},
        {<<"aa">>, 1},
        {<<"aba">>, 6},
        {<<"aaaaaaaa">>, 3}
      ])

    btn0 = :btrie.append(<<"ss">>, 2, btn0)

    fetch_keys_similar = :btrie.fetch_keys_similar(<<"ab">>, btn0)
    fetch_keys_similar_xy = :btrie.fetch_keys_similar(<<"xy">>, btn0)
    find_prefixes_aba = :btrie.find_prefixes(<<"aba">>, btn0)
    find_prefixes_aaaaaaaaaaaaaaa = :btrie.find_prefixes(<<"aaaaaaaaaaaaaaa">>, btn0)
    appended = :btrie.find_prefixes(<<"ss">>, btn0)

    assert fetch_keys_similar == ["ab", "aba", "abcdefghijklmnopqrstuvwxyz"]
    assert find_prefixes_aba == [{"ab", 5}, {"aba", 6}]

    assert find_prefixes_aaaaaaaaaaaaaaa == [
             {"aa", 1},
             {"aaa", 2},
             {"aaaaaaaa", 3},
             {"aaaaaaaaaaa", 4}
           ]

    assert appended == [{"ss", [2]}]
    assert fetch_keys_similar_xy == []
  end

  test "trie empty new" do
    rn0 = :trie.new()
    assert rn0 == []
  end

  test "trie crash tst" do

   t =  :trie.new([
      {'*',      1},
      {'aa*',    2},
      {'aa*b',   3},
      {'aa*a*',  4},
      {'aaaaa',  5}])

    r1 = :trie.fold_match('aaaa', RootNode6)
    r2 = :trie.find_match('aaaaa', RootNode6)
    r3 = :trie.find_match('aa', RootNode6)
    r4 = :trie.find_match('aab', RootNode6)

    assert r1 == r2 == r3 == r4 == ""


    tn =
      :trie.new([{'abcdefghijklmnopqrstuvwxyz', [{"eIxwocDq96uYG1A-Y7qek_BP7gy5ROAA4mAxio7A2Pk", 0, 1, :forum}, {"eIxwocDq96uYG1A-Y7qek_BP7gy5ROAA4mAxio7A2Pk", 5, 1, :forum}] },
      {'ammmmmmm', {"eIxwocDq96uYG1A-Y7qek_BP7gy5ROAA4mAxio7A2Pk", 5, 1, :forum}}
      # {"eIxwocDq96uYG1A-Y7qek_BP7gy5ROAA4mAxio7A2Pk", 6, 1, :forum},
      # {"9XqiLVC1sEA9WlInxbujyTP3Hqlt3OyK1SJCQQrif1Q", 0, 1, :forum}
      ])

    assert tn == {97, 97, {{{98, 109, {{'cdefghijklmnopqrstuvwxyz', [{"eIxwocDq96uYG1A-Y7qek_BP7gy5ROAA4mAxio7A2Pk", 0, 1, :forum}, {"eIxwocDq96uYG1A-Y7qek_BP7gy5ROAA4mAxio7A2Pk", 5, 1, :forum}]}, {[], :error}, {[], :error}, {[],:error}, {[], :error}, {[], :error}, {[], :error}, {[], :error}, {[], :error}, {[], :error}, {[], :error}, {'mmmmmm', {"eIxwocDq96uYG1A-Y7qek_BP7gy5ROAA4mAxio7A2Pk", 5, 1, :forum}}}}, :error}}}

  end

  test "trie tests" do
    tn0 =
      :trie.new([
        {'abcdefghijklmnopqrstuvwxyz', 9},
        {'ammmmmmm', 7},
        {'aaaaaaaaaaa', 4},
        {'aaa', 2},
        {'ab', 0},
        {'ab', 5},
        {'aa', 1},
        {'aba', 6},
        {'aaaaaaaa', 3}
      ])

    find_prefixes_aba = :trie.find_prefixes('aba', tn0)
    find_prefixes_aaaaaaaaaaaaaaa = :trie.find_prefixes('aaaaaaaaaaaaaaa', tn0)

    assert tn0 ==
             {97, 97,
              {{{97, 109,
                 {{{97, 97,
                    {{{97, 97,
                       {{{97, 97,
                          {{{97, 97,
                             {{{97, 97, {{{97, 97, {{{97, 97, {{'aa', 4}}}, 3}}}, :error}}},
                               :error}}}, :error}}}, :error}}}, 2}}}, 1},
                  {{97, 99, {{[], 6}, {[], :error}, {'defghijklmnopqrstuvwxyz', 9}}}, 5},
                  {[], :error}, {[], :error}, {[], :error}, {[], :error}, {[], :error},
                  {[], :error}, {[], :error}, {[], :error}, {[], :error}, {[], :error},
                  {'mmmmmm', 7}}}, :error}}}

    # :( - not ok
    assert find_prefixes_aba == [{'ab', 5}, {'aba', 6}]

    assert find_prefixes_aaaaaaaaaaaaaaa == [
             {'aa', 1},
             {'aaa', 2},
             {'aaaaaaaa', 3},
             {'aaaaaaaaaaa', 4}
           ]
  end

  test "trie find similar" do
    tn0 =
      :trie.new([
        {'abcdefghijklmnopqrstuvwxyz', 9},
        {'ammmmmmm', 7},
        {'aaaaaaaaaaa', 4},
        {'aaa', 2},
        {'ab', 0},
        {'ab', 5},
        {'aa', 1},
        {'aba', 6},
        {'aaaaaaaa', 3}
      ])

    fold_similar = :trie.fold_similar('ab', fn v, d, e -> {v, d, e} end, [], tn0)

    assert fold_similar == {'abcdefghijklmnopqrstuvwxyz', 9, {'aba', 6, {'ab', 5, []}}}
  end

  test "map to list for index" do
    obj_list1 =
      Map.new([
        {1, %{id: 1, name: "apple"}},
        {2, %{id: 2, name: "pear"}},
        {3, %{id: 3, name: "peach"}},
        {4, %{id: 4, name: "blossom"}},
        {5, %{id: 5, name: "ananas"}}
      ])

    obj_list2 =
      Map.new([
        {6, %{id: 6, name: "cowboy"}},
        {7, %{id: 7, name: "horse"}},
        {8, %{id: 8, name: "sheep"}}
      ])

    obj_list3 =
      Map.new([
        {9, %{id: 9, name: "p_something"}},
        {10, %{id: 10, name: "orange_fresh"}}
      ])

    index =
      ((obj_list1
        |> Map.values()
        |> Enum.map(fn %{id: id, name: name} ->
          {String.to_charlist(name), %{id: id, boosting: 1, type: "fruits"}}
        end)) ++
         (obj_list2
          |> Map.values()
          |> Enum.map(fn %{id: id, name: name} ->
            {String.to_charlist(name), %{id: id, boosting: 1, type: "ranch"}}
          end)) ++
         (obj_list3
          |> Map.values()
          |> Enum.map(fn %{id: id, name: name} ->
            {String.to_charlist(name), %{id: id, boosting: 1, type: "drinks"}}
          end)))
      |> :trie.new()

    fold_similar = :trie.fold_similar('p', fn key, value, acc -> acc ++ [value] end, [], index)
    filtered_data = fold_similar |> Enum.filter(fn v -> v.type == "fruits" end)
    map_data = filtered_data |> Enum.map(fn v -> {v.id, 1 * v.boosting} end)

    fold_similar_punctuation =
      :trie.fold_similar('p.', fn key, value, acc -> acc ++ [{key, value}] end, [], index)

    fold_similar_space =
      ['an', 'p']
      |> Enum.map(fn term ->
        :trie.fold_similar(term, fn key, value, acc -> acc ++ [{key, value}] end, [], index)
      end)

    assert index != []

    assert fold_similar == [
             %{boosting: 1, id: 9, type: "drinks"},
             %{boosting: 1, id: 3, type: "fruits"},
             %{boosting: 1, id: 2, type: "fruits"}
           ]

    assert filtered_data == [
             %{boosting: 1, id: 3, type: "fruits"},
             %{boosting: 1, id: 2, type: "fruits"}
           ]

    assert map_data == [{3, 1}, {2, 1}]

    assert fold_similar_punctuation == [
             {'p_something', %{boosting: 1, id: 9, type: "drinks"}},
             {'peach', %{boosting: 1, id: 3, type: "fruits"}},
             {'pear', %{boosting: 1, id: 2, type: "fruits"}}
           ]

    assert fold_similar_space == [
             [{'ananas', %{boosting: 1, id: 5, type: "fruits"}}],
             [
               {'p_something', %{boosting: 1, id: 9, type: "drinks"}},
               {'peach', %{boosting: 1, id: 3, type: "fruits"}},
               {'pear', %{boosting: 1, id: 2, type: "fruits"}}
             ]
           ]
  end

  test "btrie - map to list for index with filtering and stuff" do
    index = get_a_btrie_idx()

    results_1 =
      ["p", "pe"]
      |> Enum.map(fn t ->
        :btrie.fold_similar(t, fn key, value, acc -> acc ++ [value] end, [], index)
      end)
      |> Enum.at(0)
      |> Enum.filter(fn {_, _, v} -> v == :fruits end)
      |> Enum.map(fn {id, b, v} -> %{id: id, boosting: 1 * b, type: v} end)

    results_2 =
      ["p", "pe"]
      |> Enum.map(fn t ->
        :btrie.fold_similar(t, fn key, value, acc -> acc ++ [{key, value}] end, [], index)
      end)
      |> Enum.at(0)
      |> Enum.filter(fn {_, {_, _, v}} -> v == :fruits end)
      |> Enum.map(fn {_, {id, b, v}} -> %{id: id, boosting: 1 * b, type: v} end)

    assert index != []

    assert results_1 == [
             %{boosting: 1, id: 3, type: :fruits},
             %{boosting: 1, id: 2, type: :fruits}
           ]

    assert results_2 == [
             %{boosting: 1, id: 3, type: :fruits},
             %{boosting: 1, id: 2, type: :fruits}
           ]
  end

  def compute_score(list, id) do
    list
    |> Enum.filter(fn {_, {i, _, _}} -> i == id end)
    |> Enum.map(fn {_, {_, boosting, _}} -> boosting end)
    |> Enum.sum()
  end

  def compute_score(list) do
    list
    |> Map.new(fn {_, {id, boosting, _}} -> {id, compute_score(list, id)} end)
  end

  test "map compute score" do
    m = [
      [
        {"p_something", {9, 1, :drinks}},
        {"peach", {3, 1, :fruits}},
        {"pear", {3, 0.1, :fruits}},
        {"ananas", {1, 1, :fruits}}
      ]
    ]

    r =
      m
      |> Enum.at(0)
      |> Enum.filter(fn {_, {_, _, v}} -> v == :fruits end)
      |> compute_score()
      |> Enum.map(fn {id, score} -> %{id: id, score: score} end)

    assert r == [%{id: 1, score: 1}, %{id: 3, score: 1.1}]
  end

  test "erase from btrie" do
    obj_list1 =
      Map.new([
        {1, %{id: 1, name: "apple"}},
        {2, %{id: 2, name: "pear"}},
        {3, %{id: 3, name: "peach"}}
      ])

    index =
      obj_list1
      |> Map.values()
      |> Enum.map(fn %{id: id, name: name} ->
        [{name, [{id, 1, :fruits}]}, {name <> "_test", [{id, 1, :fruits}]}]
      end)
      |> List.flatten()
      |> Enum.map(fn {k, v} -> {k, v} end)
      |> :btrie.new()

    # try the append_list function
    index =
      obj_list1
      |> Map.values()
      |> Enum.map(fn %{id: id, name: name} ->
        [{name <> "_appended", [{id, 1, :fruits}]}]
      end)
      |> List.flatten()
      |> Enum.reduce(index, fn {k, v}, acc_index ->
        :btrie.append_list(k, v, acc_index)
      end)

    # try the erase function
    index =
      obj_list1
      |> Map.values()
      |> Enum.map(fn %{id: id, name: name} ->
        [{name <> "_test", [{id, 1, :fruits}]}]
      end)
      |> List.flatten()
      |> Enum.reduce(index, fn {k, v}, acc_index ->
        :btrie.erase(k, acc_index)
      end)

    r =
      ["p"]
      |> Enum.map(fn t ->
        :btrie.fold_similar(t, fn key, value, acc -> acc ++ [{key, value}] end, [], index)
      end)
      |> Enum.concat()
      |> List.flatten()
      |> Enum.map(fn {k, v} -> {k, v |> Enum.at(0)} end)
      |> Enum.filter(fn {_, {_, _, v}} -> v == :fruits end)
      |> Enum.map(fn {k, {id, b, v}} -> %{k: k, id: id, boosting: 1 * b, type: v} end)

    f = :btrie.is_key("peach", index)

    assert f == true

    # assert v ==  [[{"peach", [{3, 1, :fruits}]}, {"peach_appended", [{3, 1, :fruits}]}, {"pear", [{2, 1, :fruits}]}, {"pear_appended", [{2, 1, :fruits}]}]]
    assert r == [
             %{boosting: 1, id: 3, k: "peach", type: :fruits},
             %{boosting: 1, id: 3, k: "peach_appended", type: :fruits},
             %{boosting: 1, id: 2, k: "pear", type: :fruits},
             %{boosting: 1, id: 2, k: "pear_appended", type: :fruits}
           ]
  end

  test "btrie - build different" do
    obj_list1 =
      Map.new([
        {1, %{id: 1, name: "apple"}},
        {2, %{id: 2, name: "pear"}},
        {3, %{id: 3, name: "peach"}},
        {4, %{id: 4, name: "blossom"}},
        {5, %{id: 5, name: "ananas"}}
      ])

    index =
      obj_list1
      |> Map.values()
      |> Enum.map(fn %{id: id, name: name} ->
        [
          {name, {id, 1, :fruits}},
          {name <> "_new", {id + 1, 1, :fruits}},
          {"", {id + 1, 1, :fruits}}
        ]
      end)
      |> Enum.flat_map(fn v -> v end)
      |> Enum.filter(fn {term, {_, _, _}} -> term != "" end)
      |> :btrie.new()

    results_2 =
      ["p", "pe"]
      |> Enum.map(fn t ->
        :btrie.fold_similar(t, fn key, value, acc -> acc ++ [{key, value}] end, [], index)
      end)
      |> Enum.at(0)
      |> Enum.filter(fn {_, {_, _, v}} -> v == :fruits end)
      |> Enum.map(fn {term, {id, b, v}} -> %{term: term, id: id, boosting: 1 * b, type: v} end)

    assert results_2 == [
             %{boosting: 1, id: 3, type: :fruits, term: "peach"},
             %{boosting: 1, type: :fruits, id: 4, term: "peach_new"},
             %{boosting: 1, id: 2, term: "pear", type: :fruits},
             %{boosting: 1, id: 3, term: "pear_new", type: :fruits}
           ]
  end

  test "try simpler" do
    obj_list1 =
      Map.new([
        {1, %{id: 1, name: "apple"}},
        {2, %{id: 2, name: "pear"}},
        {3, %{id: 3, name: "peach"}},
        {4, %{id: 4, name: "blossom"}},
        {5, %{id: 5, name: "ananas"}}
      ])

    obj_list2 =
      Map.new([
        {6, %{id: 6, name: "cowboy"}},
        {7, %{id: 7, name: "horse"}},
        {8, %{id: 8, name: "pheep"}}
      ])

    index =
      ((obj_list1
        |> Map.values()
        |> Enum.reduce(%{}, fn %{id: id, name: name}, map ->
            map
            |> Map.update(name, {id, 1, :fruits}, fn ids -> [{id, 1, :fruits} | ids ] end)
            |> Map.update((name <> "_new"), {id + 1, 1, :fruits}, fn ids -> [ {id + 1, 1, :fruits}] end)
            |> Map.update("bb", {id, 1, :fruits}, fn ids -> [{id, 1, :fruits} | ids ] end)
            |> Map.update("",  {id, 1, :fruits}, fn ids -> [{id, 1, :fruits} | ids ] end)
        end)
        |> Map.to_list()
        |> Enum.filter(fn {term, _} -> term != "" end)) ++
         (obj_list2
          |> Map.values()
          |> Enum.reduce(%{}, fn %{id: id, name: name}, map ->
              map
              |> Map.update(name, {id, 100, :ranch}, fn ids -> [{id, 100, :ranch} | ids ] end)
              |> Map.update((name <> "_test"), {id, 1, :ranch}, fn ids -> [ {id, 1, :ranch} | ids ] end)
              |> Map.update((name <> "_test"), {id, 100, :dont_override}, fn ids -> [{id, 100, :dont_override} | ids] end)
              |> Map.update((name <> "_test"), {id, 100, :dont_override2}, fn ids -> [{id, 100, :dont_override2} | ids] end)
            end)
          |> Map.to_list()))
      |> :btrie.new()

    r =
      ["p", "pe", "b", "cowboy"]
      |> Enum.map(fn t ->
        :btrie.fold_similar(t, fn key, value, acc ->
            f_v = value
                |> cmp_score()
                |> Enum.filter(fn {_, _, v} -> v == :fruits or v == :ranch end)
                |> Enum.reduce(%{}, fn {id, boosting, type}, map -> Map.update(map, {id, type}, boosting, &(&1 + boosting))  end)

          acc ++ [f_v] end, [], index)
      end)
      |> List.flatten()
      #[%{}, %{}, %{}, %{}, %{{8, :ranch} => 200}, %{{8, :ranch} => 2}, %{}, %{}, %{}, %{}, %{}, %{}, %{}, %{{6, :ranch} => 200}, %{{6, :ranch} => 2}]
      |> Enum.reduce( fn k, v -> Map.merge(k, v, fn _k, v1, v2 -> v1 + v2 end) end)
      #%{{6, :ranch} => 202, {8, :ranch} => 202}
      |> Enum.group_by(fn {{_, type}, _} -> type end)

    assert r ==  %{
      fruits: [
        {{1, :fruits}, 2},
        {{2, :fruits}, 4},
        {{3, :fruits}, 8},
        {{4, :fruits}, 6},
        {{5, :fruits}, 2}
      ],
      ranch: [{{6, :ranch}, 202}, {{8, :ranch}, 202}]
    }
  end

  defp cmp_score(v, acc \\ [])
  defp cmp_score([], acc), do:  acc
  defp cmp_score([head|tail], acc), do: cmp_score(tail, acc)
  defp cmp_score({id, boosting, type}, acc), do: acc ++ [{id, boosting * 2 , type}]


  def compute_score(index_items) do
    index_items
    |> Enum.reduce(%{}, fn {id, boosting, _}, map ->
      Map.update(map, id, boosting, &(&1 + boosting))
    end)
  end

  defp append_to_search_index(index, {term, _}) when term == "", do: index

  defp append_to_search_index(index, {term, value}) when term != "",
    do: :btrie.append(term |> String.downcase(), value, index)

  def compute_index([head | tail], index_acc) do
    index_acc =
      index_acc
      |> append_to_search_index(head)

    compute_index(tail, index_acc)
  end

  def compute_index([], index_acc) do
    index_acc
  end

  defp get_a_btrie_idx() do
    obj_list1 =
      Map.new([
        {1, %{id: 1, name: "apple"}},
        {2, %{id: 2, name: "pear"}},
        {3, %{id: 3, name: "peach"}},
        {4, %{id: 4, name: "blossom"}},
        {5, %{id: 5, name: "ananas"}}
      ])

    obj_list2 =
      Map.new([
        {6, %{id: 6, name: "cowboy"}},
        {7, %{id: 7, name: "horse"}},
        {8, %{id: 8, name: "sheep"}}
      ])

    obj_list3 =
      Map.new([
        {9, %{id: 9, name: "p_something"}},
        {10, %{id: 10, name: "orange_fresh"}}
      ])

    ((obj_list1
      |> Map.values()
      |> Enum.map(fn %{id: id, name: name} -> {name, {id, 1, :fruits}} end)) ++
       (obj_list2
        |> Map.values()
        |> Enum.map(fn %{id: id, name: name} -> {name, {id, 1, :ranch}} end)) ++
       (obj_list3
        |> Map.values()
        |> Enum.map(fn %{id: id, name: name} -> {name, {id, 1, :drinks}} end)))
    |> :btrie.new()
  end

  defp get_a_trie_idx() do
    obj_list1 =
      Map.new([
        {1, %{id: 1, name: "apple"}},
        {2, %{id: 2, name: "pear"}},
        {3, %{id: 3, name: "peach"}},
        {4, %{id: 4, name: "blossom"}},
        {5, %{id: 5, name: "ananas"}}
      ])

    obj_list2 =
      Map.new([
        {6, %{id: 6, name: "cowboy"}},
        {7, %{id: 7, name: "horse"}},
        {8, %{id: 8, name: "sheep"}}
      ])

    obj_list3 =
      Map.new([
        {9, %{id: 9, name: "p_something"}},
        {10, %{id: 10, name: "orange_fresh"}}
      ])

    ((obj_list1
      |> Map.values()
      |> Enum.map(fn %{id: id, name: name} ->
        {String.to_charlist(name), %{id: id, boosting: 1, type: "fruits"}}
      end)) ++
       (obj_list2
        |> Map.values()
        |> Enum.map(fn %{id: id, name: name} ->
          {String.to_charlist(name), %{id: id, boosting: 1, type: "ranch"}}
        end)) ++
       (obj_list3
        |> Map.values()
        |> Enum.map(fn %{id: id, name: name} ->
          {String.to_charlist(name), %{id: id, boosting: 1, type: "drinks"}}
        end)))
    |> :trie.new()
  end

  test " concat vs [v1, v2] in merge" do

    list = Enum.reduce(1..100000,  %{}, fn x, acc ->
              Map.put(acc, x, %{id: x, name: "perf_test"})
            end)

    IO.puts("have the initial list #{Time.utc_now }")

    v1v2_result =
      list
      |> Map.values()
      |> Enum.reduce(%{}, fn %{id: id, name: name}, map ->
        map =
          map
          |> Map.merge(%{name => [{id, 5, :ranch}]}, fn _k, v1, v2 -> [v1, v2] end)
        end)
      |> Map.to_list()

      IO.puts("have the merged list with [v1, v2] #{Time.utc_now }")

    # concat_result =
    #     list
    #     |> Map.values()
    #     |> Enum.reduce(%{}, fn %{id: id, name: name}, map ->
    #       map =
    #         map
    #         |> Map.merge(%{name => [{id, 5, :ranch}]}, fn _k, v1, v2 -> Enum.concat(v1, v2) end)
    #       end)
    #     |> Map.to_list()

    # IO.puts("have the merged list with Enum.concat #{Time.utc_now }")

    update_result =
      list
      |> Map.values()
      |> Enum.reduce(%{}, fn %{id: id, name: name}, acc ->
        acc |> Map.update(id, %{name => [{id, 5, :ranch}]}, fn ids -> [ ids | %{name => [{id, 5, :ranch}]} ] end)
      end)

  IO.puts("have the merged list with Map.update [v1 | v2] #{Time.utc_now }")

    assert update_result != []
    # assert list == []
    # assert v1v2_result ==  concat_result

  end
end
