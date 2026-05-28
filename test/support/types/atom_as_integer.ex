# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.Test.Types.AtomAsInteger do
  @moduledoc false
  use Ash.Type

  @atoms_to_ints %{active: 1, inactive: 0}
  @ints_to_atoms Map.new(@atoms_to_ints, fn {k, v} -> {v, k} end)
  @atom_values Map.keys(@atoms_to_ints)
  @string_values Enum.map(@atom_values, &to_string/1)

  @impl Ash.Type
  def storage_type, do: :integer

  @impl Ash.Type
  def cast_input(nil, _), do: {:ok, nil}

  def cast_input(value, _) when value in @atom_values, do: {:ok, value}
  def cast_input(value, _) when value in @string_values, do: {:ok, String.to_existing_atom(value)}

  def cast_input(integer, _) when is_integer(integer),
    do: Map.fetch(@ints_to_atoms, integer)

  def cast_input(_, _), do: :error

  @impl Ash.Type
  def matches_type?(value, _) when is_atom(value) and value in @atom_values, do: true
  def matches_type?(_, _), do: false

  @impl Ash.Type
  def cast_stored(nil, _), do: {:ok, nil}
  def cast_stored(integer, _) when is_integer(integer), do: Map.fetch(@ints_to_atoms, integer)
  def cast_stored(_, _), do: :error

  @impl Ash.Type
  def dump_to_native(nil, _), do: {:ok, nil}
  def dump_to_native(atom, _) when is_atom(atom), do: Map.fetch(@atoms_to_ints, atom)
  def dump_to_native(_, _), do: :error
end
