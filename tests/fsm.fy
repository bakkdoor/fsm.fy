FancySpec describe: FSM with: {
  it: "defines a FSM with states & transitions" when: {
    find_a = FSM new: @{
      start: @{
        on: "a" --> 'end
        on: _ --> 'start
      }
      end # end state, since it has no transitions
    }

    find_a states size is: 2
    find_a states keys is: ["start", "end"]
    find_a states values map: @{ transitions } flatten size is: 2

    find_a parse: "a" . is: true
    find_a parse: "b" . is: false
    find_a parse: "bbbbb" . is: false
    find_a parse: "bbbbba" . is: true
  }

  it: "parses numbers" with: 'parse: when: {
    parse_num = FSM new: @{
      parse_num: @{
        on: /[0-9]/ --> 'parse_num
        on: " " --> 'parse_num
        on: "." --> 'end
      }

      end
    }

    ["abc", "123a", "123 456 a", "123 456 .a", "123.123"] each: |input| {
      { parse_num parse: input } raises: FSM ParseFailure
    }

    parse_num parse: "123." . is: true
    parse_num parse: "123." . is: true
    parse_num parse: "123 123" . is: false
    parse_num parse: "123 123." . is: true
  }

  it: "parses from any Fancy::Enumerable" with: 'parse: when: {
    parse_nums = FSM new: @{
      parse_num: @{
        on: (0..9) --> 'parse_num
        on: 'done --> 'end
      }
      end
    }

    parse_nums parse: [0,1,2,3,4,5,6,7,8,9] . is: false
    parse_nums parse: [0,1,2,3,4,5,6,7,8,9,'done] . is: true

    {
      parse_nums parse: [0,1,2,3,4,5,6,7,8,9,10]
    } raises: FSM ParseFailure
  }
}