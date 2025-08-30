# typed: strict

require 'sorbet-runtime'
require 'colorize'
require 'ruby_llm'
require_relative('tools/file_tools')

class AgentLoop
  extend T::Sig

  sig { params(chat: RubyLLM::Chat, working_directory: String).void }
  def initialize(chat, working_directory)
    @chat = chat
    @working_directory = working_directory
  end

  sig { returns(T.nilable(String)) }
  def start_loop
    list_files_tools = ListFiles.new(@working_directory)
    read_file_tool = ReadFile.new(@working_directory)
    write_file_tool = WriteFile.new(@working_directory)
    execute_file_tool = ExecuteFile.new(@working_directory)

    @chat
      .with_instructions(
        'You are a coding assistant that only codes in Ruby.
        Use the tools available as many times as needed to fulfill the user\'s request.
        Your tools give you access to a single folder, it might contain files that are relevant for your work.
        If you are creating some code, write it to a file. Never use external libraries or gems.
        Make sure to use the tools provided to answer user\'s requests.')
      .with_tools(list_files_tools, read_file_tool, write_file_tool, execute_file_tool)

    puts 'Hello, please enter your query. Type quit to end the loop.'
    input = gets.chomp
    until input.downcase == 'quit'
      answer = T.let((@chat.ask input), RubyLLM::Message)
      puts 'Answer:'.colorize(:black)
      puts answer.content.colorize(:green)
      # puts answer.to_h
      puts 'Metrics:'.colorize(:blue)
      puts "- Input tokens: #{answer.input_tokens}".colorize(:blue)
      puts "- Output tokens: #{answer.output_tokens}".colorize(:blue)
      input = gets.chomp
    end
  end
end