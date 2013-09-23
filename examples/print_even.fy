require: "fsm"

print_even = FSM new: {
  final numbers: @{
    + @{ even? } -> numbers ! @{ println }
    # or:
    # + @{ even? } -> numbers do: @{ println }
    + _          -> numbers
  }
}

print_even <- (0..10)

print_even_skipping_letters = FSM new: {
  final print_numbers: @{
    + /[0-9]/ ?? @{
      ? @{ to_i even? } -> print_numbers ! @{ println }
      ? _               -> print_numbers
    }

    + _ -> print_numbers
  }
}

input = Console readln: "Print only even numbers of input: "
print_even_skipping_letters <- input
