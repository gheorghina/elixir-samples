defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  use GenServer

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @type t :: %BankAccount{}

  defstruct [
    balance: 0,
    is_closed: false
  ]

  @impl true
  @spec init([]) :: {:ok, BankAccount.t()}
  def init([]) do
    {:ok, %BankAccount{}}
  end

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: :ignore | {:error, any()} | {:ok, pid()}
  def open_bank() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account_pid) do
    GenServer.call(account_pid, :close)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account_pid) do
    GenServer.call(account_pid, :get_balance)
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account_pid, amount) do
    GenServer.call(account_pid, {:update_balance, amount})
  end

  @impl true
  def handle_call(:get_balance, _from,  %BankAccount{balance: balance, is_closed: is_closed} = state) do
    case is_closed do
      false -> {:reply, balance, state}
      true -> {:reply, {:error, :account_closed}, state}
    end
  end

  @impl true
  def handle_call({:update_balance, amount}, _from, %BankAccount{balance: balance, is_closed: is_closed} = state) do
    case is_closed do
      false -> {:reply, state, %{state | balance: balance + amount }}
      true -> {:reply, {:error, :account_closed}, state}
    end
  end

  @impl true
  def handle_call(:close, _from, state) do
    {:reply, state, %{state | is_closed: true }}
  end
end
