class FSM {
  class State {
    read_slots: ('name, 'transitions, 'callback)
    read_write_slot: 'final

    def initialize: @name {
      @transitions = []
      @final = false
    }

    def + pattern {
      Transition new: self pattern: pattern . tap: |t| {
        @transitions << t
      }
    }

    def handle: input {
      try {
        @transitions each: |t| {
          match input {
            case t ->
              return t next_state
          }
        }
      } catch StandardError => e {
        ProcessFailure new: self input: input with: e . raise!
      }

      return nil
    }

    def final? {
      @transitions empty? || @final
    }
  }

  class SpecialState {
    def initialize: @builder do: @block

    def unknown_message: m with_params: p {
      @builder receive_message: m with_params: p . tap: @block
    }
  }

  class FinalState : SpecialState {
    def initialize: @builder {
      initialize: @builder do: @{ final: true }
    }
  }

  class LoopState : SpecialState {
    def initialize: @builder {
      initialize: @builder do: |state| {
        state + _ -> state
      }
    }
  }
}