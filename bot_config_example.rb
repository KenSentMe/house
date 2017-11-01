# Setting up the function to start the bot
def start_bot
  bot = TelegramBot.new(token: '<your token goes here>')
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
