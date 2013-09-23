class FSM {
  class Builder {
    read_slot: 'states

    def initialize {
      @states = []
    }

    def build: block {
      block call_with_receiver: self
      @states
    }

    def unknown_message: m with_params: p {
      state_name = m to_s replace: ":" with: ""
      match state_name {
        case "final" ->
          FinalState new: self
        case "loop" ->
          LoopState new: self
        case _ ->
          s = @states find_by: @{ name == state_name }
          unless: s do: {
            s = State new: state_name
            @states << s
          }
          if: (p first) then: @{ call: [s] }
          s
      }
    }
  }
}