# frozen_string_literal: true

require "cgi"
require "date"
require "erb"
require "fileutils"
require "kramdown"
require "yaml"

ROOT = File.expand_path("..", __dir__)
DIST_DIR = File.join(ROOT, "dist")
CONTENT_DIR = File.join(ROOT, "content", "notes")
TEMPLATES_DIR = File.join(ROOT, "templates")
STATIC_DIR = File.join(ROOT, "static")

Post = Struct.new(
  :title,
  :slug,
  :date,
  :description,
  :body_markdown,
  :body_html,
  :source_path,
  keyword_init: true
)

module Helpers
  module_function

  def render_template(name, locals = {})
    template_path = File.join(TEMPLATES_DIR, name)
    template = File.read(template_path)
    ERB.new(template, trim_mode: "-").result_with_hash(locals)
  end

  def wrap_layout(title:, description:, content:, canonical_path:, body_class: nil)
    render_template(
      "layout.html.erb",
      page_title: title,
      meta_description: description,
      content: content,
      canonical_url: canonical_path ? "https://rodreegez.com#{canonical_path}" : nil,
      body_class: body_class
    )
  end

  def parse_post(path)
    raw = File.read(path)
    frontmatter = {}
    body = raw

    if raw.start_with?("---\n")
      _, yaml_block, remainder = raw.split(/^---\s*$\n?/, 3)
      frontmatter = YAML.safe_load(yaml_block, permitted_classes: [Date], aliases: false) || {}
      body = remainder.to_s.sub(/\A\s+/, "")
    end

    title = frontmatter.fetch("title")
    slug = frontmatter["slug"] || File.basename(path, ".md")
    date = frontmatter.fetch("date")
    date = Date.parse(date.to_s) unless date.is_a?(Date)
    description = frontmatter["description"] || first_paragraph(body)

    Post.new(
      title: title,
      slug: slug,
      date: date,
      description: description,
      body_markdown: body,
      body_html: Kramdown::Document.new(body, input: "GFM").to_html,
      source_path: path
    )
  end

  def first_paragraph(markdown)
    markdown
      .split(/\n\s*\n/)
      .map(&:strip)
      .find { |chunk| !chunk.empty? && !chunk.start_with?("#", "```", "---") }
      &.gsub(/[`*_>#-]/, "")
      &.strip || ""
  end

  def format_date(date)
    date.strftime("%d %B %Y")
  end

  def xml_escape(text)
    CGI.escapeHTML(text.to_s)
  end
end

include Helpers

FileUtils.rm_rf(DIST_DIR)
FileUtils.mkdir_p(DIST_DIR)
FileUtils.mkdir_p(File.join(DIST_DIR, "notes"))
FileUtils.mkdir_p(File.join(DIST_DIR, "assets"))

FileUtils.cp(File.join(ROOT, "index.html"), File.join(DIST_DIR, "index.html"))
FileUtils.cp(File.join(ROOT, "favicon.svg"), File.join(DIST_DIR, "favicon.svg"))
FileUtils.cp_r(Dir[File.join(STATIC_DIR, "*")], File.join(DIST_DIR, "assets")) if Dir.exist?(STATIC_DIR)

posts = Dir.glob(File.join(CONTENT_DIR, "*.md")).sort.map { |path| parse_post(path) }
posts.sort_by! { |post| [-post.date.jd, post.slug] }

posts.each do |post|
  article = render_template("note.html.erb", post: post, format_date: method(:format_date))
  page = wrap_layout(
    title: "#{post.title} | Notes | Adam Rogers",
    description: post.description,
    content: article,
    canonical_path: "/notes/#{post.slug}/",
    body_class: "note-page"
  )

  destination = File.join(DIST_DIR, "notes", post.slug)
  FileUtils.mkdir_p(destination)
  File.write(File.join(destination, "index.html"), page)
end

notes_index = render_template("notes_index.html.erb", posts: posts, format_date: method(:format_date))
notes_index_page = wrap_layout(
  title: "Notes | Adam Rogers",
  description: "Notes on software, systems, delivery, and side projects.",
  content: notes_index,
  canonical_path: "/notes/",
  body_class: "notes-index-page"
)
File.write(File.join(DIST_DIR, "notes", "index.html"), notes_index_page)

puts "Built #{posts.length} notes into #{DIST_DIR}"
