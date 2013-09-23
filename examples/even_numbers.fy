require: "fsm"

even_numbers = FSM new: {
  start: @{
    + @{ even? } -> even
  }

  final even: @{
    + @{ even? } -> even
    + @{ odd? }  -> fail
  }

  loop fail
}

even_numbers do: @{
  <- [0]                     . println
  <- [0,2]                   . println
  <- [0,2,4,6,8,42,100,1000] . println
  <- []                      . println
  <- [0,1,2]                 . println
  <- [0,2,3]                 . println
}

{ even_numbers <- "0246" } call_with_errors_logged
{ even_numbers <- "123"  } call_with_errors_logged
