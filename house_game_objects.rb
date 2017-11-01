# Create the object class for all objects in the game
class GameObject
  attr_reader :name, :room_text
  attr_accessor :action, :description, :visible, :pickup, :locked
  def initialize(name,description,room_text,action,pickup,visible,locked)
    @name = name
    @description = description
    @room_text = room_text
    @action = action
    @pickup = pickup
    @visible = visible
    @locked = locked
  end
end

# Create the actual objects in the game
def create_objects
  $fork = GameObject.new(
    "Fork",
    "This is a fork",
    "In the chest is a fork.",
    [],
    false,
    false,
    false
  )
  $bag = GameObject.new(
    "Bag",
    "This is a bag",
    "There is a small bag on the floor.",
    [],
    false,
    true,
    false
  )
  $balloon = GameObject.new(
    "Balloon",
    "This is an inflated balloon",
    "A balloon is rolling on the floor.",
    [],
    true,
    true,
    false
  )
  $punched_balloon = GameObject.new(
    "Punched balloon",
    "It's a deflated balloon with a tiny hole in it",
    "",
    [],
    false,
    false,
    false
  )
  $chest = GameObject.new(
    "Chest",
    "A big chest, with an almost even bigger padlock on it.",
    "In the corner of the room is a big chest.",
    [],
    false,
    true,
    true
  )
  $key = GameObject.new(
    "Key",
    "A key, to open stuff.",
    "A small key lies on the floor.",
    [],
    true,
    true,
    false
  )
  $ball = GameObject.new(
    "Ball",
    "A ball.",
    "In the chest lies a small ball.",
    [],
    false,
    false,
    false
  )
end

# Because the action hash may contain objects that aren't initialized when
# the object instances are created, the actions are defined seperately.
def create_object_actions
  $fork.action = {
    verb: "combine",
    use_with: "balloon",
    text: "Using the fork on the balloon does the obvious thing. You get a deflated balloon with a hole in it.",
    result: :punched_balloon,
    created_objects: [$punched_balloon],
    deleted_objects: [:fork, :balloon]
  }

  $chest.action = [
    {
      verb: "open",
      result: [
        {
          job: "alter_description",
          affected_object: $chest,
          altered_description: "The chest is now open."
        },
        {
          job: "change_visibility",
          affected_object: $ball,
          visibility_state: true
        },
        {
          job: "change_pickup",
          affected_object: $ball,
          pickup_state: true
        },
        {
          job: "change_visibility",
          affected_object: $fork,
          visibility_state: true
        },
        {
          job: "change_pickup",
          affected_object: $fork,
          pickup_state: true
        }
      ]
    }
  ]
  # $key.action = {
  #   verb: "alter",
  #   combine_with: "chest",
  #   text: "You use the key to open the chest.",
  #   altered_object: $chest,
  #   altered_description: "Since you've used the key to open the padlock, you can now open the chest.",
  #   altered_text: "Inside the chest you find"
  # }

end
