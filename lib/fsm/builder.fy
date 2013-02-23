class FSM {
  class Builder {
    read_slot: 'states

    def initialize: @fsm {
      @states = []
    }

    def build: block {
      block call: [self]
      @fsm states: @states
    }

    def unknown_message: m with_params: p {
      state_name = m to_s replace: ":" with: ""
      s = State new: state_name
      if: (p first) then: @{ call: [s] }
      @states << s
      self
    }
  }
}