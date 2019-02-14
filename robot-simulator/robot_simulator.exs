defmodule RobotSimulator do
  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """

  defstruct([:direction, :position])
  @type t :: %RobotSimulator{}
  @allowed_directions [:north, :south, :east, :west]
  @allowed_instructions ["A", "R", "L"]

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

  defp validate_position(_) do
    {:error, "invalid position"}
  end

  defp validate_direction(direction) when is_atom(direction) do
    if Enum.member?(@allowed_directions, direction) do
      {:ok, direction}
    else
      {:error, "invalid direction"}
    end
  end

  defp validate_direction(_) do
    {:error, "invalid direction"}
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: RobotSimulator.t(), instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    codepoints =
      instructions
      |> String.codepoints()

    illegal_codepoints =
      codepoints
      |> Enum.find(fn i -> not Enum.member?(@allowed_instructions, i) end)

    case illegal_codepoints do
      nil ->
        codepoints
        |> Enum.reduce(robot, fn instruction, acc ->
          case instruction do
            "R" -> acc |> turn_right()
            "A" -> acc |> advance()
            "L" -> acc |> turn_left()
          end
        end)

      _ ->
        {:error, "invalid instruction"}
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

  defp turn_left(%RobotSimulator{direction: direction, position: position} = robot) do
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

  defp turn_right(%RobotSimulator{direction: direction, position: position} = robot) do
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
  def direction(%RobotSimulator{direction: direction}) do
    direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: RobotSimulator.t()) :: {integer, integer}
  def position(%RobotSimulator{position: position}) do
    position
  end
end
