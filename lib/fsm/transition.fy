class FSM {
  class Transition {
    read_slots: ('pattern, 'next_state)

    def initialize: @state pattern: @pattern

    def --> @next_state {
      self
    }
  }
}
