# typed: true

require 'sorbet-runtime'
require 'ruby_llm'
# require 'ruby_llm/mcp'
require 'colorize'
require_relative('agent_loop')

# ---- Configurations ----
model = 'gpt-oss:20b'
working_directory = "/Users/lucavgobbi/Downloads/ai_coded"
# -------- End -----------

RubyLLM.configure do |config|
  config.ollama_api_base = 'http://localhost:11434/v1'
end

chat = RubyLLM.chat(
  model: model,
  provider: :ollama,
  assume_model_exists: true
)

agent_loop = AgentLoop.new(chat, working_directory)
agent_loop.start_loop

