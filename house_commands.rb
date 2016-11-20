module Commands

  # The look method is for objects in a room or in your inventory
  def look(current_room, command_params)
    if command_params.empty?
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
      object = command_params.join('_').intern
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

  def get(current_room, command_params)
    if command_params.empty?
      puts "I don't get it, what do you want?"
    elsif command_params.length > 1
      puts "Wow, easy there. Try picking up one item at a time."
    else
      object = command_params[0].intern
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

  # The use command is for combining objects.
  def use(current_room, command_params)
    if command_params.empty?
      puts "Use what?"
    elsif command_params.length > 3
      puts "What are you trying to do, make a coctail? Combining two items should be sufficient."
    elsif command_params[1] != "on"
      puts "That's not the right way to combine stuff"
    else
      command_params.delete("on")
      object1 = command_params[0].intern
      object2 = command_params[1].intern

      # first check of the two objects are in the inventory
      if $inventory.key?(object1) && $inventory.key?(object2)
        # then create an instance of the first object
        object1_instance = $inventory[object1]
        # check if it can be combined with the second object
        if object1_instance.action[:combine_with] != object2.to_s
          puts "You can't do that, at least not now."
        else
          # print out the result of the combination
          puts object1_instance.action[:text]
          new_object_key = object1_instance.action[:result]
          $inventory[new_object_key] = object1_instance.action[:new_object]
          $inventory.delete(object1)
          $inventory.delete(object2)
        end
      # now check if the first object is in the inventory and the second is in the current room
      elsif $inventory.key?(object1) && current_room.game_objects.key?(object2)
        # then create an instance of the first object
        object1_instance = $inventory[object1]
        # check if the first object can be combined with the second object
        if object1_instance.action[:combine_with] != object2.to_s
          puts "You can't do that, at least not now."
        else
          # print out the result of the combination
          puts object1_instance.action[:text]
        end
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

  def go(current_room, command_params)
    if command_params.empty?
      puts "Please specify a direction"
    elsif command_params.length == 1 || command_params[1].length == 1
      direction = command_params[0].intern
      # Check if the entered direction is an actual direction
      if $current_room.directions.key?(direction)
        $current_room = current_room.directions[direction]
      else
        puts "You can't go that way"
      end
    else
      wrong_direction = command_params.join(" ")
      puts "I don't understand the direction #{wrong_direction}"
    end
  end
end
