require: "fsm"

file_pattern = ARGV[1]
unless: file_pattern do: {
  *stderr* do: @{
    println: "Usage:   #{ARGV[0]} 'file_pattern'"
    println: "Example: #{ARGV[0]} 'lib/*.fy'"
  }
  System abort
}

print_empty_files = FSM new: {
  ValidFile = |f| {
    File exists?: f && { File read: f . bytes size == 0 }
  }

  final filter_empty: @{
    + ValidFile -> filter_empty ! @{ println }
    + _         -> filter_empty
  }
}

print_empty_files <- (Directory list: $ file_pattern )
