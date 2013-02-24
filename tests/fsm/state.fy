FancySpec describe: FSM State with: {
  it: "is a final state when no transitions exist" with: 'final? when: {
    s = FSM State new: "final_state"
    s final? is: true
  }

  it: "is not a final state if transitions exist" with: 'final? when: {
    s = FSM State new: "non_final_state"
    s on: "foo" --> 'bar
    s final? is: false
  }
}