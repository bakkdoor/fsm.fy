require: "fsm/transition"
require: "fsm/state"
require: "fsm/builder"

class FSM {
  class ParseFailure : StandardError
  class StateNotFoundError : StandardError

  read_write_slot: 'states

  def initialize: block {
    @states = []
    Builder new: self . build: block
    @start = @states first
    @states = @states to_hash: @{ name }
  }

  def parse: input_string {
    state = @start

    input_string each: |char| {
      if: (state handle: char) then: |new_state| {
        if: (@states[new_state to_s]) then: |s| {
          state = s
        } else: {
          StateNotFoundError raise: "State not found: #{new_state}"
        }
      } else: {
        ParseFailure raise: "Could not parse: #{char} with state: #{state name}"
      }
    }

    # got to end state
    if: (state final_state?) then: {
      return true
    }

    return false
  }
}