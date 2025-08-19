require 'bigdecimal'
require 'bigdecimal/util'

def options()
  puts "1 - Addition"
  puts "2 - Subtraction"
  puts "3 - Multiplication"
  puts "4 - Division"
  puts "Q - Quit"
end

def valid_user_input()
  command = gets.chomp.downcase

  if command == "q"
    puts "End"
    return
  end

  if command == "1"
    puts "1 - Addition"
  elsif command == "2"
    puts "2 - Subtraction"
  elsif command == "3"
    puts "3 - Multiplication"
  elsif command == "4"
    puts "4 - Division"
  else
    puts "Invalid command"
    return
  end
  return command
end

def calculator_loop()
  while true
    options()

    command = valid_user_input()

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
