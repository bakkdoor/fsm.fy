FancySpec describe: FSM with: {
  it: "defines a FSM with states & transitions" when: {
    find_a = FSM new: @{
      start: @{
        on: "a" --> 'end
        on: _ --> 'start
      }
      end # end state
    }

    find_a parse: "a" . is: true
    find_a parse: "b" . is: false
    find_a parse: "bbbbb" . is: false
    find_a parse: "bbbbba" . is: true
  }
}