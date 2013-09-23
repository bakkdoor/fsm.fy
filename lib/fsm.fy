require: "fsm/transition"
require: "fsm/state"
require: "fsm/builder"

class FSM {
  class Debug {
    def initialize: @enabled (false);

    def if_debug: block {
      match @enabled {
        case true -> block call
      }
    }

    def start_processing: input {
      if_debug: {
        "DEBUG: Processing: #{input inspect}" println
      }
    }

    def transition: state value: value new_state: new_state {
      if_debug: {
        "DEBUG: #{state name}(#{value inspect}) -> #{new_state name}" println
      }
    }

    def completed: state input: input {
      if_debug: {
        match state final? {
          case true -> "DEBUG: Processing successful: #{input inspect}" println
          case _    -> "DEBUG: Processing failed: #{input inspect}" println
        }
      }
    }
  }

  class ProcessFailure : StandardError {
    read_slots: ('state, 'input, 'reason)
    def initialize: @state input: @input with: @reason (nil) {
      msg = "ProcessFailure: #{@state name}(#{@input inspect})"
      { msg << " with: #{reason}" } if: @reason
      initialize: msg
    }
  }

  class StateNotFoundError : StandardError

  read_write_slots: ('states, 'final_states)

  def initialize: block debug: debug? (false) {
    @debug  = Debug new: debug?
    @states = []
    states  = Builder new build: block
    @start  = states first
    @states = states to_hash: @{ name }

    @final_states = []
  }

  def state_with_name: state_name {
    if: (@states[state_name to_s]) then: |s| {
      return s
    } else: {
      StateNotFoundError raise: "State not found: #{state_name}"
    }
  }

  def setup_final_states {
    @final_states each: |state_name| {
      state_with_name: state_name . final: true
    }
  }

  def transition: state value: value {
    new_state = state handle: value

    unless: new_state do: {
      ProcessFailure new: state input: value . raise!
    }

    @debug transition: state value: value new_state: new_state

    match new_state {
      case State -> new_state
      case _     -> state_with_name: $ new_state to_s
    }
  }

  def <- input {
    setup_final_states

    @debug start_processing: input

    state = @start
    input each: |value| {
      state = transition: state value: value
    }

    @debug completed: state input: input

    return state final?
  }

  alias_method: 'process: for: '<-
}