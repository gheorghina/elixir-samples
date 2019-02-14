defmodule RobotSimulator do
  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """

  defstruct([:direction, :position])

  @allowed_directions [:north, :south, :east, :west]

  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0}) do
    case position |> validate_position() do
      {:ok, position} ->
        case direction |> validate_direction() do
          {:ok, direction} -> %RobotSimulator{direction: direction, position: position}
          error -> error
        end

      error ->
        error
    end
  end

  defp validate_position(position)
       when is_tuple(position) and :erlang.tuple_size(position) == 2 and
              is_integer(elem(position, 0)) and is_integer(elem(position, 1)) do
    {:ok, position}
  end

  defp validate_position(position) do
    {:error, "invalid position"}
  end

  defp validate_direction(direction) when is_atom(direction) do
    if Enum.member?(@allowed_directions, direction) do
      {:ok, direction}
    else
      {:error, "invalid direction"}
    end
  end

  defp validate_direction(direction) do
    {:error, "invalid direction"}
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot) do
    case robot do
      %RobotSimulator{direction: direction} -> direction
      _ -> nil
    end
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot) do
    case robot do
      %RobotSimulator{position: position} -> position
      _ -> nil
    end
  end
end
