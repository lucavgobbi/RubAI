# typed: strict

require 'sorbet-runtime'
require 'colorize'
require 'ruby_llm'
require_relative('tools/file_tools')
require_relative('tools/ruby_tools')

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
    delete_file_tool = DeleteFiles.new(@working_directory)

    execute_file_tool = ExecuteFile.new(@working_directory)
    execute_bundle_tool = ExecuteBundle.new(@working_directory)

    @chat
      .with_instructions(
        'You are a coding assistant that only codes in Ruby.
        Use the tools available as many times as needed to fulfill the user\'s request.
        Your tools give you access to a single folder, it might contain files that are relevant for your work.
        Only write files if you need to update their content. Never use external libraries or gems.
        Make sure to use the tools provided to answer user\'s requests.')
      .with_tools(
        list_files_tools, 
        read_file_tool,
        write_file_tool, 
        delete_file_tool, 
        execute_file_tool,
        execute_bundle_tool,
      )
      .on_tool_call do |tool_call|
        tool_call = T.let(tool_call, RubyLLM::ToolCall)
        print_block(title: 'Tool Call', color: :light_blue) do
          <<~LOG
          Name: #{tool_call.name}
          #{tool_call.arguments}
          LOG
        end
      end

    puts 'Hello, please enter your query. Type quit to end the loop.'
    input = gets.chomp
    until input.downcase == 'quit'
      answer = T.let((@chat.ask input), RubyLLM::Message)
      print_block(title: 'Answer', color: :green) do
        answer.content
      end
      
      print_block(title: 'Metrics', color: :blue) do
        <<~LOG
        - Input tokens: #{answer.input_tokens}
        - Output tokens: #{answer.output_tokens}
        LOG
      end
      
      input = gets.chomp
    end
  end

  private
  
  sig { params(title: String, color: Symbol, block: T.proc.returns(String)).returns(NilClass) }
  def print_block(title:, color: :black, &block)
    block_width = 30 
    block_side_width = ((block_width - title.length) / 2) - 1
    header = "#{('-' * block_side_width)} #{title} #{('-' * block_side_width)}"

    puts header.colorize(color)
    puts yield.colorize(color)
    puts ('-' * block_width).colorize(color)
    puts
  end
end