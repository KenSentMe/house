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
    else
      # look at an object in the room (if it exists)
      command.slice!("look ")
      object = command.intern
      if current_room.game_objects.key?(object)
        object_instance = current_room.game_objects[object]
        puts object_instance.description
      else
        puts "That object doesn't exist, at least not in this room."
      end
    end
  end

  def go(current_room, command)
    if command == "go"
      puts "Please specify a direction"
    elsif command.start_with?("go ") && command.length == 4
      direction = command.slice(3).intern
      # Check if the entered direction is an actual direction
      if $current_room.directions.key?(direction)
        $current_room = current_room.directions[direction]
      else
        puts "You can't go that way"
      end
    elsif command.start_with?("go ")
      command.slice!("go ")
      puts "I don't understand the direction #{command}"
    end
  end

  def get(current_room, command)
    if command == "get"
      puts "I don't get it, what do you want?"
    else
      puts "You can't get that, at least not now."
    end
  end
end

# Create the room class
class Room
  attr_reader :name, :description
  attr_accessor :directions, :game_objects
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
  elsif command == "look" || command.start_with?("look ")
    look($current_room, command)
  elsif command.start_with?("go")
    go($current_room, command)
  elsif command.start_with?("get")
    get($current_room, command)
  else
    puts "I don't understand #{command}"
  end
  prompt
end


def create_objects
  $fork = GameObject.new("Fork", "This is a fork", "Action", true, true)
  $bag = GameObject.new("Bag", "This is a bag", "Action", true, true)
end

# The rooms have to be created first with empty hashes for the directions
# because not all instances are available when they are called in the hashes

def create_rooms
  $room1 = Room.new("Room 1", "This is room 1", {}, {fork: $fork, bag: $bag})
  $room2 = Room.new("Room 2", "This is room 2", {}, {})
  $room3 = Room.new("Room 3", "This is room 3", {}, {})
  $room4 = Room.new("Room 4", "This is room 4", {}, {})
  $room5 = Room.new("Room 5", "This is room 5", {}, {})
end

# Setting the directions for the different rooms
def set_directions
  $room1.directions = {e: $room2}
  $room2.directions = {w: $room1, n: $room3, e: $room4, s: $room5}
  $room3.directions = {s: $room2}
  $room4.directions = {w: $room2}
  $room5.directions = {n: $room2}
end

# Calling the methods to create the rooms and objects and set the directions
create_objects
create_rooms
set_directions

# Define the first room the game starts in
$current_room = $room1

# Creating an empty inventory array
$inventory = []

# Start the game by running the prompt
prompt
