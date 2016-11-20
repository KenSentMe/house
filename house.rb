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
  evaluate(command)
end

# Here the commands are evaluated and (if necessary) sent to the appropriate method
def evaluate(command)
  if command == "q"
    puts "Bye, bye!"
    return
  elsif command == "look" || command.start_with?("look ")
    look($current_room, command)
  elsif command == "go" || command.start_with?("go ")
    go($current_room, command)
  elsif command == "get" || command.start_with?("get ")
    get($current_room, command)
  elsif command == "inventory" || command == "i"
    inventory
  elsif command == "use" || command.start_with?("use ")
    use(command)
  else
    puts "I don't understand #{command}"
  end
  prompt
end

# Calling the methods to create the rooms and objects and set the directions
create_objects
create_rooms
set_directions

# Define the first room the game starts in
$current_room = $room1

# Creating an empty inventory array
$inventory = {}

# Start the game by running the prompt
prompt
