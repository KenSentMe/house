# Outline
# Room Class
# => Look around in Room
# => Go to other room in certain direction
# => Look at objects in Room

require "./house_game_objects.rb"
require "./house_commands.rb"
require "./house_rooms.rb"

# This is the prompt where players type their commands. It displays the current room name and sends commands to the evaluate method
def prompt
  include Commands
  print "[#{$current_room.name}]:>"
  command = gets.chomp.downcase
  # split the command so we have seperate word and params
  command = command.split(' ')
  # grab the first word and define it as the word of the command
  command_word = command.shift
  # and the rest of the command is one or more parameters
  command_params = command
  evaluate(command_word, command_params)
end

# Here the commands are evaluated and (if necessary) sent to the appropriate method
def evaluate(command_word, command_params)
  case command_word
  when "q", "quit"
    puts "Bye, bye!"
    return
  when "look"
    look($current_room, command_params)
  when "go"
    go($current_room, command_params)
  when "get"
    get($current_room, command_params)
  when "i", "inventory"
    inventory
  when "use"
    use($current_room, command_params)
  else
    puts "I don't understand #{command_params}"
  end
  prompt
end

# Calling the methods to create the rooms and objects and set the directions
create_objects
create_object_actions
create_rooms
set_directions

# Define the first room the game starts in
$current_room = $room1

# Creating an empty inventory array
$inventory = {}

# Start the game by running the prompt
prompt
