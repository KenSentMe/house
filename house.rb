# Outline
# Room Class
# => Look around in Room
# => Go to other room in certain direction
# => Look at objects in Room

module Commands
  def look(current_room, command)
    if command == "look"
      # look at the current room
      # convert the availavle direcions into the proper text
      converted_directions = []
      current_room.directions.each do |d,r|
        direction_conversions = {n: "North", s:"South", e: "East", w: "West"}
        converted_directions << direction_conversions[d]
      end
      puts "#{current_room.description}. From here you can go #{converted_directions.join(', ')}."
    elsif
      # look at an object in the room (if it exists)
      puts "Bla"
    end
  end

  def go(current_room, direction)
    $current_room = current_room.directions[direction]
    prompt
  end

  def get(current_room, object_name)
  end
end

# Create the room class
class Room
  attr_reader :name, :description
  attr_accessor :directions
  def initialize(name,description,directions,game_objects)
    @name = name
    @description = description
    @directions = directions
    @game_objects = game_objects
  end
end

# Create the object class for all objects in the game
class GameObject
  attr_reader :name, :description, :action
  def initialize(name,description,action,pickup,visible)
    @name = name
    @description = description
    @action = action
    @pickup = pickup
  end
end

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
  elsif command == "look"
    look($current_room, "look")
    prompt
  elsif command.start_with?("go")
    if command == "go"
      puts "Please specify a direction"
      prompt
    elsif command.start_with?("go ") && command.length == 4
      direction = command.slice(3).intern
      # Check if the entered direction is an actual direction
      if $current_room.directions.key?(direction)
        go($current_room, direction)
      else
        puts "You can't go that way"
        prompt
      end
    elsif command.start_with?("go ")
      command.slice!("go ")
      puts "I don't understand the direction #{command}"
      prompt
    end
  else
    puts "I don't understand #{command}"
    prompt
  end
end


def create_objects
  $fork = GameObject.new("Fork", "This is a fork", "Action", true, true)
end

# The rooms have to be created first with empty hashes for the directions
# because not all instances are available when they are called in the hashes

def create_rooms
  $room1 = Room.new("Room 1", "This is room 1", {}, [$fork])
  $room2 = Room.new("Room 2", "This is room 2", {}, [])
  $room3 = Room.new("Room 3", "This is room 3", {}, [])
  $room4 = Room.new("Room 4", "This is room 4", {}, [])
  $room5 = Room.new("Room 5", "This is room 5", {}, [])
end

# Setting the directions for the different rooms
# THe hash creation should be updated to the newer Ruby syntax, but i'll leave it like this for now
def set_directions
  $room1.directions = {e: $room2}
  $room2.directions = {w: $room1, n: $room3, e: $room4, s: $room5}
  $room3.directions = {s: $room2}
  $room4.directions = {w: $room2}
  $room5.directions = {n: $room2}
end

# Calling the methods to create the rooms and set the directions
create_rooms
set_directions

# Define the first room the game starts in
$current_room = $room1

# Start the game by running the prompt
prompt
