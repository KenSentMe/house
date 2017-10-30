require 'telegram_bot'
require "./house_game_objects.rb"
require "./house_tasks.rb"
require "./house_commands.rb"
require "./house_rooms.rb"


# Here the commands are evaluated and (if necessary) sent to the appropriate method
def evaluate(command_word, command_params)
  include Commands
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
  when "open"
    open($current_room, command_params)
  else
    $reply_text = "I don't understand #{command_word}"
  end
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

# This game can operate in 2 modes. The default mode is the bot mode, where
# the game runs in a chatbot (in this case Telegram). When the argument nobot
# is given, the game runs in command line.

# Setting up the function to start the bot
def start_bot
  bot = TelegramBot.new(token: '319896844:AAEa9Ojtb7NppgeUDXP3QwRK7TujOwodmKE')
  bot.get_updates(fail_silently: true) do |message|
    puts "@#{message.from.username}: #{message.text}"
    command = message.get_command_for(bot)
    command = command.downcase
    command = command.split(' ')
    command_word = command.shift
    command_params = command
    evaluate(command_word, command_params)
    message.reply do |reply|
      reply.text = $reply_text
      reply.send_with(bot)
    end
  end
end

# Setting up the function to run the game in the prompt
def start_prompt
  loop do
    print "[#{$current_room.name}]:>"
    command = STDIN.gets.chomp.downcase
    # split the command so we have seperate word and params
    command = command.split(' ')
    # grab the first word and define it as the word of the command
    command_word = command.shift
    # and the rest of the command is one or more parameters
    command_params = command
    evaluate(command_word, command_params)
    puts $reply_text
  end
end

# Check the mode in which the game runs by grabbing the argument from the
# command line
game_mode = ARGV
case game_mode[0]
when nil
  start_bot
when "nobot"
  start_prompt
else
  puts "Unknow argument #{game_mode}"
end
