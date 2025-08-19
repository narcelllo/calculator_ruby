require 'bigdecimal'
require 'bigdecimal/util'

def options()
  puts "1 - Addition"
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

    puts "whats is the first number?"
    first_number = gets.chomp.to_d

    puts "whats is the second number?"
    second_number = gets.chomp.to_d

    if command == "1"
      result = first_number + second_number
      print (result.to_i)
    elsif command == "2"
      result = first_number - second_number
      print (result.to_i)
    elsif command == "3"
      result = first_number * second_number
      print (result.to_i)
    elsif command == "4"
      result = first_number / second_number
      print (result.to_s('F'))
    end
  end
end

def main()
  calculator_loop()
end

main()
