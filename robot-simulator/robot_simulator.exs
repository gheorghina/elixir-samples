defmodule RobotSimulator do
  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """

  defguard is_position_valid(position)
            when is_tuple(position) and :erlang.tuple_size(position) == 2 and
                   is_integer(elem(position, 0)) and is_integer(elem(position, 1))

  defguard is_direction_valid(direction)
            when is_atom(direction) and
                   (direction == :north or direction == :south or direction == :east or
                      direction == :west)

  defstruct([:direction, :position])
  @type t :: %RobotSimulator{}
  @allowed_instructions ["A", "R", "L"]

  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0})

  def create(direction, position)
      when is_position_valid(position) and is_direction_valid(direction),
      do: %RobotSimulator{direction: direction, position: position}

  def create(_, position) when not is_position_valid(position), do: {:error, "invalid position"}

  def create(direction, _) when not is_direction_valid(direction),
    do: {:error, "invalid direction"}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: RobotSimulator.t(), instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    codepoints =
      instructions
      |> String.codepoints()

    invalid_point_exists =
      codepoints
      |> Enum.any?(fn i -> not Enum.member?(@allowed_instructions, i) end)

    if invalid_point_exists do
      {:error, "invalid instruction"}
    else
      codepoints
      |> Enum.reduce(robot, fn instruction, acc ->
        case instruction do
          "R" -> acc |> turn_right()
          "A" -> acc |> advance()
          "L" -> acc |> turn_left()
        end
      end)
    end
  end

  defp advance(%RobotSimulator{direction: direction, position: {x, y}} = robot) do
    %{
      robot
      | position:
          case direction do
            :north -> {x, y + 1}
            :east -> {x + 1, y}
            :west -> {x - 1, y}
            :south -> {x, y - 1}
          end
    }
  end

  defp turn_left(%RobotSimulator{direction: direction} = robot) do
    %{
      robot
      | direction:
          case direction do
            :north -> :west
            :east -> :north
            :west -> :south
            :south -> :east
          end
    }
  end

  defp turn_right(%RobotSimulator{direction: direction} = robot) do
    %{
      robot
      | direction:
          case direction do
            :north -> :east
            :east -> :south
            :west -> :north
            :south -> :west
          end
    }
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: RobotSimulator.t()) :: atom
  def direction(%RobotSimulator{direction: direction}), do: direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: RobotSimulator.t()) :: {integer, integer}
  def position(%RobotSimulator{position: position}), do: position
end
