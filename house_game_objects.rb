# Create the object class for all objects in the game
class GameObject
  attr_reader :name, :description, :pickup
  attr_accessor :action
  def initialize(name,description,action,pickup,visible)
    @name = name
    @description = description
    @action = action
    @pickup = pickup
  end
end

# Create the actual objects in the game
def create_objects
  $fork = GameObject.new("Fork", "This is a fork", {}, true, true)
  $bag = GameObject.new("Bag", "This is a bag", {}, false, true)
  $balloon = GameObject.new("Balloon", "This is an inflated balloon", {}, true, true)
  $punched_balloon = GameObject.new("Punched balloon", "It's a deflated balloon with a tiny hole in it", {}, false, false)
  create_object_actions
end

# Because the action hash may contain objects that aren't initialized when the object instances are created, the actions are defined seperately.
def create_object_actions
  $fork.action = {verb: "combine", combine: "balloon", text: "Using the fork on the balloon, does the obvious thing. You get a deflated balloon with a hole in it.", result: {key: :punched_balloon, object: $punched_balloon, text: "Punched balloon"}}
end
