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

# The rooms have to be created first with empty hashes for the directions
# because not all instances are available when they are called in the hashes

def create_rooms
  $room1 = Room.new("Room 1", "This is room 1", {}, {bag: $bag, balloon: $balloon, key: $key})
  $room2 = Room.new("Room 2", "This is room 2", {}, {chest: $chest, ball: $ball, fork: $fork})
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
