class FSM {
  class Transition {
    read_slots: ('pattern, 'next_state, 'callback)

    def initialize: @state pattern: @pattern {
      @next_state   = nil
      @conditionals = nil
    }

    def -> @next_state {
      self
    }

    def ! @callback {
      self
    }

    alias_method: 'do: for: '!

    def ?? block {
      @conditionals = ConditionalTransitions new: block
    }

    def === input {
      match input {
        case @pattern -> |m|
          { @callback call: [input] } if: @callback
          { return m } unless: @conditionals

          m = @conditionals === input
          @next_state = @conditionals next_state
          m
      }
    }
  }

  class ConditionalTransition {
    read_slots: ('condition, 'next_state, 'callback)

    def initialize: @condition

    def -> @next_state {
      self
    }

    def ! @callback {
      self
    }

    def === input {
      @condition === input
    }
  }

  class ConditionalTransitions {
    read_slot: 'transitions

    def initialize: block {
      @transitions = <[]>
      block call: [self]
    }

    def ? condition {
      ct = ConditionalTransition new: condition
      @transitions[condition]: ct
      ct
    }

    def next_state {
      @next_state
    }

    def === input {
      @transitions each_value: |ct| {
        match input {
          case ct condition -> |m|
            { ct callback call: [input] } if: $ ct callback
            @next_state = ct next_state
            return m
        }
      }
    }
  }
}
