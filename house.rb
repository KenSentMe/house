# Outline
# Room Class
# => Look around in Room
# => Go to other room in certain direction
# => Look at objects in Room

module Commands

  # The look method is for objects in a room or in your inventory
  def look(current_room, command)
    if command == "look"
      # look at the current room
      # convert the availavle direcions into the proper text
      converted_directions = []
      current_room.directions.each do |d,r|
        direction_conversions = {n: "North", s: "South", e: "East", w: "West"}
        converted_directions << direction_conversions[d]
      end
      puts "#{current_room.description}. From here you can go #{converted_directions.join(', ')}."
    else
      # look at an object in the room (if it exists)
      command.slice!("look ")
      object = command.gsub(" ","_").intern
      if current_room.game_objects.key?(object)
        object_instance = current_room.game_objects[object]
        puts object_instance.description
      elsif $inventory.key?(object)
        object_instance = $inventory[object]
        puts object_instance.description
      else
        puts "That object doesn't exist, at least not in this room."
      end
    end
  end

  def get(current_room, command)
    if command == "get"
      puts "I don't get it, what do you want?"
    else
      command.slice!("get ")
      object = command.intern
      if current_room.game_objects.key?(object)
        object_instance = current_room.game_objects[object]
        if object_instance.pickup
          $inventory[object] = current_room.game_objects.delete(object)
          puts "You add #{object_instance.name} to your inventory."
        else
          puts "You can't pick that up."
        end
      else
        puts "You can't get that, at least not now."
      end
    end
  end

  def use(command)
    if command == "use"
      puts "Use what?"
    else
      command.slice!("use ")
      objects = command.split(" on ")
      object1 = objects[0].intern
      object2 = objects[1].intern
      if $inventory.key?(object1) && $inventory.key?(object2)
        object1_instance = $inventory[object1]
        puts object1_instance.action[:text]
        result = object1_instance.action[:result]
        new_object_key = result[:key]
        new_object_var = result[:object]
        puts new_object_key.class
        puts new_object_var.class
        # new_object_var = $punched_balloon
        puts result[:text]
        $inventory[new_object_key] = object1_instance.action[:result_object]
        $inventory.delete(object1)
        $inventory.delete(object2)
      else
        puts "That doesn't make sense"
      end
    end
  end

  def inventory
    if $inventory.empty?
      puts "Your inventory is empty."
    else
      inventory_list = []
      $inventory.each do |s,i|
        inventory_list << i.name
      end
      puts "In your inventory you has the following items: #{inventory_list.join(', ')}"
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
  attr_reader :name, :description, :action, :pickup
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

def create_objects
  $fork = GameObject.new("Fork", "This is a fork", {verb: "combine", combine: "balloon", text: "Using the fork on the balloon, does the obvious thing. You get a deflated balloon with a hole in it.", result: {key: :punched_balloon, object: $punched_balloon, text: "Punched balloon"}, result_object: $punched_balloon}, true, true)
  $bag = GameObject.new("Bag", "This is a bag", {}, false, true)
  $balloon = GameObject.new("Balloon", "This is an inflated balloon", {}, true, true)
  $punched_balloon = GameObject.new("Punched balloon", "It's a deflated balloon with a tiny hole in it", {}, false, false)
end

def punched_balloon
end

# The rooms have to be created first with empty hashes for the directions
# because not all instances are available when they are called in the hashes

def create_rooms
  $room1 = Room.new("Room 1", "This is room 1", {}, {fork: $fork, bag: $bag, balloon: $balloon})
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
$inventory = {}

# Start the game by running the prompt
prompt
