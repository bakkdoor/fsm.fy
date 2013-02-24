class FSM {
  class State {
    read_slots: ('name, 'transitions)

    def initialize: @name {
      @transitions = []
    }

    def on: pattern {
      Transition new: self pattern: pattern . tap: |t| {
        @transitions << t
      }
    }

    def handle: char {
      @transitions each: |t| {
        match char {
          case t pattern -> return t next_state
        }
      }

      return nil
    }

    def final? {
      @transitions empty?
    }
  }
}