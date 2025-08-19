require 'bigdecimal'
require 'bigdecimal/util'

module CalculatorApp
  class CalculationError < StandardError; end
end

module CalculatorApp
  class Operation
    attr_reader :key, :name, :symbol

    def initialize(key:, name:, symbol:)
      @key = key.freeze
      @name = name.freeze
      @symbol = symbol.freeze
    end

    def call(_a, _b)
      raise NotImplementedError, "#{self.class} must implement #call(a, b)"
    end
  end

  class SumOperation < Operation
    def initialize
      super(key: '1', name: 'Addition', symbol: '+')
    end

    def call(a, b)
      a + b
    end
  end

  class SubtractionOperation < Operation
    def initialize
      super(key: '2', name: 'Subtraction', symbol: '-')
    end

    def call(a, b)
      a - b
    end
  end

  class MultiplicationOperation < Operation
    def initialize
      super(key: '3', name: 'Multiplication', symbol: '×')
    end

    def call(a, b)
      a * b
    end
  end

  class DivisionOperation < Operation
    def initialize
      super(key: '4', name: 'Division', symbol: '÷')
    end

    def call(a, b)
      raise CalculationError, 'Division by zero is not allowed.' if b.zero?
      a / b
    end
  end
end

module CalculatorApp
  class Calculator
    def initialize(operations = nil)
      @operations = {}
      register_default_operations if operations.nil?
      Array(operations).each { |op| register(op) } if operations
      freeze_if_ready!
    end

    def compute(operation_key, a, b)
      op = @operations[operation_key]
      raise CalculationError, 'Invalid operation.' unless op
      op.call(a, b)
    end

    def operations_for_menu
      @operations.values.sort_by(&:key)
    end

    private

    def register_default_operations
      register(SumOperation.new)
      register(SubtractionOperation.new)
      register(MultiplicationOperation.new)
      register(DivisionOperation.new)
    end

    def register(operation)
      @operations[operation.key] = operation
    end

    def freeze_if_ready!
      @operations.freeze
      freeze
    end
  end
end

module CalculatorApp
  class Input
    def initialize(io_in: $stdin, io_out: $stdout)
      @io_in = io_in
      @io_out = io_out
    end

    def read_choice(valid_choices)
      loop do
        print_inline('Select the number of the desired operation: ')
        choice = @io_in.gets&.chomp.to_s.strip
        return choice if valid_choices.include?(choice)
        puts_line("Invalid option. Choose one of: #{valid_choices.join(', ')}.")
      end
    end

    def read_number(prompt)
      loop do
        print_inline(prompt)
        raw = @io_in.gets&.chomp.to_s.strip
        if numeric?(raw)
          return to_decimal(raw)
        end
        puts_line('Invalid value. Enter a number (e.g., 10, 3.5, -2, 0, 7,25).')
      end
    end

    def ask_yes_no(prompt)
      loop do
        print_inline(prompt)
        raw = @io_in.gets&.chomp.to_s.strip.downcase
        return true if %w[s sim y yes].include?(raw)
        return false if %w[n nao não no].include?(raw)
        puts_line('Invalid input. Enter "s" for yes or "n" for no.')
      end
    end

    private

    NUMERIC_REGEX = /\A[-+]?(\d+([.,]\d*)?|[.,]\d+)\z/

    def numeric?(str)
      NUMERIC_REGEX.match?(str)
    end

    def to_decimal(str)
      sanitized = str.tr(',', '.')
      BigDecimal(sanitized)
    end

    def print_inline(text)
      @io_out.print(text)
    end

    def puts_line(text)
      @io_out.puts(text)
    end
  end
end

module CalculatorApp
  class Input
    def initialize(io_in: $stdin, io_out: $stdout)
      @io_in = io_in
      @io_out = io_out
    end

    def read_choice(valid_choices)
      loop do
        print_inline('Select the number of the desired operation: ')
        choice = @io_in.gets&.chomp.to_s.strip
        return choice if valid_choices.include?(choice)
        puts_line("Invalid option. Choose one of: #{valid_choices.join(', ')}.")
      end
    end

    def read_number(prompt)
      loop do
        print_inline(prompt)
        raw = @io_in.gets&.chomp.to_s.strip
        if numeric?(raw)
          return to_decimal(raw)
        end
        puts_line('Invalid value. Enter a number (e.g., 10, 3.5, -2, 0, 7,25).')
      end
    end

    def ask_yes_no(prompt)
      loop do
        print_inline(prompt)
        raw = @io_in.gets&.chomp.to_s.strip.downcase
        return true if %w[s sim y yes].include?(raw)
        return false if %w[n nao não no].include?(raw)
        puts_line('Invalid input. Enter "s" for yes or "n" for no.')
      end
    end

    private

    NUMERIC_REGEX = /\A[-+]?(\d+([.,]\d*)?|[.,]\d+)\z/

    def numeric?(str)
      NUMERIC_REGEX.match?(str)
    end

    def to_decimal(str)
      sanitized = str.tr(',', '.')
      BigDecimal(sanitized)
    end

    def print_inline(text)
      @io_out.print(text)
    end

    def puts_line(text)
      @io_out.puts(text)
    end
  end
end

module CalculatorApp
  class NumberFormatter
    class << self
      def format_decimal(n)
        return n.to_s unless n.is_a?(BigDecimal)

        s = n.to_s('F')
        s = s.sub(/(\.\d*?[1-9])0+$/, '\1')
        s = s.sub(/\.0+$/, '')
        s = s.sub(/\.$/, '')
        s.empty? ? '0' : s
      end
    end
  end
end

module CalculatorApp
  class Menu
    def initialize(calculator:, input:)
      @calculator = calculator
      @input = input
    end

    def run
      loop do
        show_header
        show_options
        op_key = @input.read_choice(valid_keys)

        a = @input.read_number('Enter the first number: ')
        b = @input.read_number('Enter the second number: ')

        begin
          result = @calculator.compute(op_key, a, b)
          print_result(op_key, a, b, result)
        rescue CalculationError => e
          puts_line("Error: #{e.message}")
        end

        puts_line('')
        again = @input.ask_yes_no('Do you want to perform another calculation? (s/n): ')
        break unless again
        puts_line('')
      end

      puts_line('Goodbye! 👋')
    end

    private

    def show_header
      puts_line('============================================')
      puts_line(' Ruby Calculator - Basic Operations (OOP) ')
      puts_line('============================================')
      puts_line('Select the number of the mathematical operation you want to perform:')
      puts_line('')
    end

    def show_options
      @calculator.operations_for_menu.each do |op|
        puts_line("#{op.key} - #{op.name}")
      end
      puts_line('')
    end

    def print_result(op_key, a, b, result)
      op = operation_by_key(op_key)
      a_str = NumberFormatter.format_decimal(a)
      b_str = NumberFormatter.format_decimal(b)
      r_str = NumberFormatter.format_decimal(result)
      puts_line('')
      puts_line('------------------ Result ------------------')
      puts_line("#{op.name}: #{a_str} #{op.symbol} #{b_str} = #{r_str}")
      puts_line('--------------------------------------------')
    end

    def operation_by_key(key)
      @calculator.operations_for_menu.find { |op| op.key == key }
    end

    def valid_keys
      @calculator.operations_for_menu.map(&:key)
    end

    def puts_line(text)
      $stdout.puts(text)
    end
  end
end

module CalculatorApp
  class App
    def self.run
      calculator = Calculator.new
      input = Input.new
      Menu.new(calculator: calculator, input: input).run
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  CalculatorApp::App.run
end
