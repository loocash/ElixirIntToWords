defmodule IntToWordsTest do
  use ExUnit.Case
  doctest IntToWords

  import IntToWords
  require IntToWords

    
  @cardinal ~w/zero one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen/
  @cardinal_tens ~w/twenty thirty forty fifty sixty seventy eighty ninety/
  
  test "works for cardinals from 0 to 19" do
    @cardinal
    |> Stream.with_index 
    |> Enum.each fn({word, index}) ->
      assert (itw(index) == word)
    end
  end

  test "works for tens cardinals" do
    [20, 30, 40, 50, 60, 70, 80, 90]
    |> Stream.with_index
    |> Enum.each fn({number, index}) ->
      word = itw(number)
      assert (Enum.fetch(@cardinal_tens, index) == {:ok, word})
    end
  end
 
  test "macro is_cardinal_ten" do
    cardinal_tens = [20, 30, 40, 50, 60, 70, 80, 90]
    non_cardinal_tens = [0, 3, 6, 8, 10, 11, 56, 33, 100, 101]

    cardinal_tens |> Enum.each fn(x) ->
      assert(is_cardinal_ten(x) == true)
    end

    non_cardinal_tens |> Enum.each fn(x) ->
      assert(is_cardinal_ten(x) == false, "Testing for #{x}")
    end
  end

  test "macro is_hundred works" do
    [100, 200, 300, 400, 500, 600, 700, 800, 900]
    |> Enum.each fn(x) ->
      assert (is_hundred(x) == true)
    end
    
    [0, 4, 10, 11, 13, 23, 67, 99, 101, 123, 1000, 901]
    |> Enum.each fn(x) ->
      assert (is_hundred(x) == false)
    end
  end

  test "hyphen words" do
    numbers = [21, 25, 32, 58, 64, 79, 83, 99]
    words = ["twenty-one", "twenty-five", "thirty-two", "fifty-eight", "sixty-four", "seventy-nine", "eighty-three", "ninety-nine"]

    Enum.zip(numbers, words)
    |> Enum.each fn({number, word}) ->
      assert (itw(number) == word)
    end

  end


  test "whole hundreds" do
    [100, 200, 300, 400, 500, 600, 700, 800, 900] 
    |> Enum.each fn(x) ->
      index = div(x, 100)
      {:ok, number} = Enum.fetch @cardinal, index
      assert(itw(x) == number <> " hundred")
    end
  end

  test "works for 1000" do
    assert (itw(1000) == "one thousand")
  end

  test "works for 115" do
    assert (itw(115) == "one hundred and fifteen")
  end

  test "works for 342" do
    assert (itw(342) == "three hundred and forty-two")
  end

  test "Some 3 digit numbers" do
    numbers = [101, 109, 110, 117, 120, 152, 208, 394]
    words = ["one hundred and one", "one hundred and nine", "one hundred and ten", "one hundred and seventeen", "one hundred and twenty", "one hundred and fifty-two", "two hundred and eight", "three hundred and ninety-four"]

    Enum.zip(numbers, words)
    |> Enum.each fn({number, word}) ->
      assert (itw(number) == word)
    end
  end

  test "count work for 342" do
    assert(count(342) == 23)
  end

  test "count work for 115" do
    assert(count(115) == 20)
  end

  test "answer for 5" do
    assert(answer(5) == 19)
  end

  test "answer for 1000" do
    assert(answer(1000) == 21124)
  end

end
