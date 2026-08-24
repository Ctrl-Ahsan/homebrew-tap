cask "tickit" do
  # The release asset carries the build number as well as the version, and
  # Homebrew's csv form is what lets both come from one `version`.
  version "0.1.0,30"
  sha256 "7ebb27f3500e9a9b86b8a18281b1ee9c93c5fd6efc47a07c3de7000dcd58369a"

  url "https://github.com/Ctrl-Ahsan/tickit/releases/download/v#{version.csv.first}/Tickit-#{version.csv.first}-#{version.csv.second}.zip"
  name "Tickit"
  desc "Two-way sync between Apple Reminders and GitHub Issues"
  homepage "https://github.com/Ctrl-Ahsan/tickit"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sonoma"

  app "Tickit.app"

  # Reminders and Full Disk Access are remembered by path, so an upgrade that
  # left the old copy behind would strand the grants on it.
  uninstall quit: "io.github.ctrl-ahsan.tickit"

  zap trash: [
    "~/.tickit",
    "~/Library/Preferences/io.github.ctrl-ahsan.tickit.plist",
    "~/Library/Caches/io.github.ctrl-ahsan.tickit",
    "~/Library/HTTPStorages/io.github.ctrl-ahsan.tickit",
  ]
end
