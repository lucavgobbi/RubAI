# typed: strict


class ExecuteFile < RubyLLM::Tool
  extend T::Sig

  description 'Executes the Ruby file and returns the stdout'
  param :file_name, desc: 'The file name to write'
  param :params, desc: 'The parameters to pass as a string', required: false

  sig { params(working_directory: String).void }
  def initialize(working_directory)
    @working_directory = working_directory
  end

  sig { params(file_name: String, params: String).returns(T.nilable(String)) }
  def execute(file_name:, params:)
    unless file_name.end_with?('.rb')
      return 'Error: file extension must be .rb'
    end

    file_path = "#{@working_directory}/#{file_name}"
    unless File.exist?(file_path)
      return 'Error: file does not exists'
    end

    output = `ruby #{file_path} #{params}`
    puts output
  end
end

class ExecuteBundle < RubyLLM::Tool
  extend T::Sig

  description 'Executes a command using bundle and returns the stdout'
  param :command, desc: 'the command string to be run after bundle ...'

  sig { params(working_directory: String).void }
  def initialize(working_directory)
    @working_directory = working_directory
  end

  sig { params(command: String).returns(T.nilable(String)) }
  def execute(command:)
    Dir.chdir(@working_directory) do
      output = command.start_with?('bundle') ? `#{command}` : `bundle #{command}`
      puts output
    end
  end
end