# fsm.fy

Finite State Machine library for Fancy

## Example usage:

```fancy
require: "fsm"

numbers_only = FSM new: {
  non_digit = /[^0-9]/
  digit     = /[0-9]/
  done      = /\s/ >< ""

  start: @{
    + digit -> parse_num
  }

  final parse_num: @{
    + digit -> parse_num
    + "."   -> parse_decimal
    + done  -> end
    + _     -> fail
  }

  final parse_decimal: @{
    + digit -> parse_decimal
    + done  -> end
    + _     -> fail
  }

  loop fail
}

numbers_only <- "a"     # raises FSM ParseFailure
numbers_only <- "123"   # => true
numbers_only <- "a123"  # raises FSM ParseFailure
numbers_only <- "123a"  # => false
```
