if !System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("roman.exs", __DIR__)
end

ExUnit.start()
ExUnit.configure(exclude: :pending, trace: true)


#
# X, XX, XXX, XL, L, LX, LXX, LXXX, XC, C
# C, CC, CCC, CD, D, DC, DCC, DCCC, CM, M
# 39 = "Thirty nine" (XXX+IX) = XXXIX.
# 246 = "Two hundred and forty six" (CC+XL+VI) = CCXLVI.
# 1776 (M+DCC+LXX+VI) = MDCCLXXVI (the date written on the book held by the Statue of Liberty).[5]
# 1954 (M+CM+L+IV) = MCMLIV (as in the trailer for the movie The Last Time I Saw Paris)[6]
# 1990 (M+CM+XC) = MCMXC (used as the title of musical project Enigma's debut album MCMXC a.D., named after the year of its release).
# 2014 (MM+X+IV) = MMXIV (the year of the games of the XXII (22nd) Olympic Winter Games (in Sochi)
# The current year (2018) is MMXVIII.


defmodule RomanTest do
  use ExUnit.Case

 # @tag :pending
  test "163" do
    assert Roman.numerals(163) == "CLXIII"
  end

  test "161" do
    assert Roman.numerals(161) == "CLXI"
  end

  test "575" do
    assert Roman.numerals(575) == "DLXXV"
  end 

  test "551" do
    assert Roman.numerals(551) == "DLI"
  end 
end
