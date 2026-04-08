# frozen_string_literal: true

require "bundler/setup"
require "webrick"

ROOT = File.expand_path("..", __dir__)
DIST_DIR = File.join(ROOT, "dist")
PORT = Integer(ENV.fetch("PORT", "4000"))
HOST = ENV.fetch("HOST", "127.0.0.1")

build_ok = system("bundle", "exec", "ruby", File.join(ROOT, "scripts", "build.rb"))
abort "Preview build failed" unless build_ok

server = WEBrick::HTTPServer.new(
  Port: PORT,
  BindAddress: HOST,
  DocumentRoot: DIST_DIR,
  AccessLog: [],
  Logger: WEBrick::Log.new($stderr, WEBrick::Log::WARN),
  DirectoryIndex: ["index.html"]
)

trap("INT") { server.shutdown }
trap("TERM") { server.shutdown }

puts "Previewing dist/ at http://#{HOST}:#{PORT}"
puts "Press Ctrl+C to stop"

server.start
