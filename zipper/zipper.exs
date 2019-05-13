defmodule BinTree do
  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """

  @type t :: %BinTree{value: any, left: t() | nil, right: t() | nil}

  defstruct [:value, :left, :right]
end

defimpl Inspect, for: BinTree do
  import Inspect.Algebra

  # A custom inspect instance purely for the tests, this makes error messages
  # much more readable.
  #
  # BinTree[value: 3, left: BinTree[value: 5, right: BinTree[value: 6]]] becomes (3:(5::(6::)):)
  def inspect(%BinTree{value: value, left: left, right: right}, opts) do
    concat([
      "(",
      to_doc(value, opts),
      ":",
      if(left, do: to_doc(left, opts), else: ""),
      ":",
      if(right, do: to_doc(right, opts), else: ""),
      ")"
    ])
  end
end

defmodule Zipper do

  @type trail :: { :left | :right, BinTree.t, trail} | :root
  @type t :: %Zipper{focus: nil, trail: trail }

  defstruct [:focus, :trail]

  require Logger

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(bin_tree), do: %Zipper{focus: bin_tree, trail: :root}

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(%Zipper{focus: node, trail: :root}), do: node
  def to_tree(zipper), do: zipper |> up |> to_tree

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(%Zipper{focus: %BinTree{value: value}}), do: value

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(%Zipper{focus: %{left: nil}}), do: nil
  def left(%Zipper{focus: %{left: left} = node, trail: trail} = zipper) do
    %{ zipper |
        focus: left,
        trail: [{:left, node} | trail]
     }
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(%Zipper{focus: %{right: nil}}), do: nil
  def right(%Zipper{focus: %{right: right} = node, trail: trail} = zipper) do
    %{ zipper |
        focus: right,
        trail: [{:right, node} | trail]
     }
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(%Zipper{trail: :root}), do: nil
  def up(%Zipper{trail: [{_, node_up} | trail]} = zipper) do
    %{ zipper |
        focus: node_up,
        trail: trail
    }
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(%Zipper{focus: node, trail: trail} = zipper, value) do
    update_zipper(%{zipper | focus: %{node | value: value}}, trail)
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(%Zipper{focus: node, trail: trail} = zipper, left) do
    update_zipper(%{zipper | focus: %{node | left: left}}, trail)
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(%Zipper{focus: node, trail: trail} = zipper, right) do
    update_zipper(%{zipper | focus: %{node | right: right}}, trail)
  end

  defp update_zipper(zipper, :root), do: zipper

  defp update_zipper(%Zipper{trail: :root} = zipper, _), do: zipper

  defp update_zipper(%Zipper{focus: updated_node} = zipper, [{direction, parent} | trail]) do
     {_, updated_parent} = parent |> Map.get_and_update!(direction, fn v -> {v, updated_node} end)

     %{zipper | trail: [{direction, updated_parent}] ++ trail}
     |> up()
     |> update_zipper(trail)
  end
end
