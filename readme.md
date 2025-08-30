
# RubAgent

RubAgent is the simplest coding agent that can be created. It is a minimal Ruby project for learning and experimentation with Large Language Models (LLMs) using the RubyLLM gem and Ollama. This repository is not intended for production use, but rather as a playground to explore how to connect Ruby applications to AI APIs and handle responses.

## Purpose
This project serves as a hands-on introduction to integrating Ruby with LLM services. It demonstrates basic usage patterns, error handling, and configuration, making it a useful reference for anyone interested in experimenting with AI in Ruby.

## Features
- Connects to LLM APIs via RubyLLM and Ollama
- Basic error handling for API responses
- Simple, readable code structure
- Can read, write, and execute files within a specified directory

## Getting Started
1. Install Ollama by following the instructions at [Ollama's official site](https://ollama.com/).
2. Download the model you want to use, for example:
  ```sh
  ollama pull gpt-oss:20b
  ```
  > Note: the model must support tool calling.
3. Ensure Ollama is running locally:
  ```sh
  ollama serve
  ```
  > Note: code assumes ollama is running on `http://localhost:11434/`
3. Install dependencies:
	```sh
	bundle install
	```
4. Update the configuration section in `main.rb` with your preferences.
5. Run the main script:
	```sh
	ruby main.rb
	```

## Disclaimer
This is a learning project. The code is experimental and may not follow best practices for production applications.

## License
MIT License

> Note: This readme was generated with the help of an AI.