require 'bigdecimal'
require 'bigdecimal/util'

def options()
  puts "\n1 - Addition"
  puts "2 - Subtraction"
  puts "3 - Multiplication"
  puts "4 - Division"
  puts "Q - Quit"
end

def get_user_input()
  command = gets.chomp.downcase
  return command
end

def invalid_command(command)
  if command != "1" && command != "2" && command != "3" && command != "4" && command != "q"
    puts "Invalid command"
    return true
  end
end

def check_end(command)
  if command == "q"
    puts "End"
    return true
  end
end

def get_user_numbers()
  puts "whats is the first number?"
  first_number = gets.chomp.to_d

  puts "whats is the second number?"
  second_number = gets.chomp.to_d

  return first_number, second_number
end

def add(first_number, second_number)
  result = first_number + second_number
  puts "Result: #{result.to_i}"
end

def subtracti(first_number, second_number)
  result = first_number - second_number
  puts "Result: #{result.to_i}"
end

def multiplay(first_number, second_number)
  result = first_number * second_number
  puts "Result: #{result.to_i}"
end

def divide(first_number, second_number)
  if second_number == 0
    puts"not divisible"
    return
  else
    result = first_number / second_number
    puts "Result: #{result.to_s('F')}"
  end
end

def calculate(first_number, second_number, command)
  if command == "1"
    add(first_number, second_number)
  elsif command == "2"
    subtracti(first_number, second_number)
  elsif command == "3"
    multiplay(first_number, second_number)
  elsif command == "4"
    divide(first_number, second_number)
  end
end

def calculator_loop()
  while true
    options()

    command = get_user_input()

    if invalid_command(command)
      next
    end

    if check_end(command)
      break
    end
    first_number, second_number = get_user_numbers()

    calculate(first_number, second_number, command)

  end
end

def main()
  calculator_loop()
end

main()
