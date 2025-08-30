# typed: strict

class ReadFile < RubyLLM::Tool
  extend T::Sig

  description 'Use this tool to read a file'
  param :file_name, desc: 'The file name to read'

  sig { params(working_directory: String).void }
  def initialize(working_directory)
    @working_directory = working_directory
  end


  sig { params(file_name: String).returns(String) }
  def execute(file_name:)
    file_path = "#{@working_directory}/#{file_name}"
    
    unless File.exist?(file_path)
      return ''
    end

    File.read(file_path)
  end
end

class WriteFile < RubyLLM::Tool
  extend T::Sig

  description 'Use this tool to write string to a file'
  param :file_name, desc: 'The file name to write'
  param :content, desc: 'The content to write'

  sig { params(working_directory: String).void }
  def initialize(working_directory)
    @working_directory = working_directory
  end

  sig { params(file_name: String, content: String).void }
  def execute(file_name:, content:)
    file_path = "#{@working_directory}/#{file_name}"
    File.write(file_path, content)
  end
end

class ListFiles < RubyLLM::Tool
  extend T::Sig

  description 'Use this tool to list all files in the working folder/directory'

  sig { params(working_directory: String).void }
  def initialize(working_directory)
    @working_directory = working_directory
  end

  sig { returns(T::Array[String]) }
  def execute
    Dir.glob("#{@working_directory}/*")
  end
end

class DeleteFiles < RubyLLM::Tool
  extend T::Sig

  description 'Use this tool to delete a file'
  param :file_name, desc: 'The file name to delete'

  sig { params(working_directory: String).void }
  def initialize(working_directory)
    @working_directory = working_directory
  end


  sig { params(file_name: String).void }
  def execute(file_name:)
    file_path = "#{@working_directory}/#{file_name}"
    unless File.exist?(file_path)
      return ''
    end

    File.delete(file_path)
  end
end