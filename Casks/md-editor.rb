cask "md-editor" do
  version "0.1.4"
  sha256 "7d1310dc5f4ffcc121a7bc6655beb62da36986751bd81821d1967025a7f8a7c0"

  url "https://github.com/wmasfoe/md-editor/releases/download/v#{version}/Markdown%20Editor_0.1.4_aarch64.dmg"
  name "Markdown Editor"
  desc "Markdown and MDX-compatible desktop editor"
  homepage "https://github.com/wmasfoe/md-editor"

  app "Markdown Editor.app"
end
