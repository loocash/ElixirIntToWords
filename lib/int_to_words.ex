# So the answer for problem 17 is
# iex> 1..1000 |> Enum.reduce(0, fn(x, acc) -> acc + count(x) end)

defmodule IntToWords do
  @cardinal ~w/zero one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen/

  @cardinal_tens ~w/twenty thirty forty fifty sixty seventy eighty ninety/
  
  defmacro is_single_digit(number) do
    quote do: unquote(number) >= 0 and unquote(number) < 10
  end

  defmacro is_cardinal(number) do
    quote do: unquote(number) >= 0 and unquote(number) < 20
  end

  defmacro is_cardinal_ten(number) do
    quote do 
      (rem(unquote(number), 10) == 0) and 
      (unquote(number) > 19) and 
      is_single_digit(unquote(number)/10)
    end
  end

  defmacro is_hundred(number) do
    quote do
      (rem(unquote(number), 100) == 0) and 
      (unquote(number) > 99) and 
      unquote(number) < 901
    end
  end

  # numbers between 21 and 99
  defmacro is_hyphen_number(number) do
    quote do: unquote(number) >= 21 and unquote(number) <= 99
  end

  def itw(number) when is_cardinal(number) do
    case Enum.fetch @cardinal, number do
      {:ok, word} -> word
      {:error} -> "unknown"
    end
  end
  
  def itw(number) when is_cardinal_ten(number) do
    index = div(number, 10) - 2
    case Enum.fetch @cardinal_tens, index do
      {:ok, word} -> word
      {:error} -> "unknown"
    end
  end

  def itw(number) when is_hyphen_number(number) do
    {st, nd} = {div(number, 10)*10, rem(number, 10)}
    "#{itw(st)}-#{itw(nd)}"
  end

  def itw(number) when is_hundred(number) do
    st = div(number, 100)
    "#{itw(st)} hundred"
  end

  def itw(number) when number < 1000 do
    {st, rest} = {div(number, 100)*100, rem(number, 100)}
    "#{itw(st)} and #{itw(rest)}"
  end

  def itw(_), do: "one thousand"

  def count(number) do
    number
    |> itw
    |> String.replace(" ", "")
    |> String.replace("-", "")
    |> String.length
  end

end
