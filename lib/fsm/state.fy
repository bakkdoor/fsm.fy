class FSM {
  class State {
    read_slots: ('name, 'transitions)

    def initialize: @name {
      @transitions = []
    }

    def on: pattern {
      t = Transition new: self pattern: pattern
      @transitions << t
      t
    }

    def handle: char {
      @transitions each: |t| {
        match char {
          case t pattern -> return t next_state
        }
      }

      return nil
    }

    def final_state? {
      @transitions count: @{ next_state to_s == @name } == 0
    }
  }
}