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
  EmptyFile = |f| {
    File exists?: f && { File read: f . bytes size == 0 }
  }

  final loop filter_empty: @{
    + EmptyFile -> filter_empty ! @{ println }
  }
}

print_empty_files <- (Directory list: $ file_pattern )
