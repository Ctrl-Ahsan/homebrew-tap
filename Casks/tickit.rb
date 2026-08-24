cask "tickit" do
  # The release asset carries the build number as well as the version, and
  # Homebrew's csv form is what lets both come from one `version`.
  version "0.1.0,30"
  sha256 "7ebb27f3500e9a9b86b8a18281b1ee9c93c5fd6efc47a07c3de7000dcd58369a"

  url "https://github.com/Ctrl-Ahsan/tickit/releases/download/v#{version.csv.first}/Tickit-#{version.csv.first}-#{version.csv.second}.zip"
  name "Tickit"
  desc "Two-way sync between Apple Reminders and GitHub Issues"
  homepage "https://github.com/Ctrl-Ahsan/tickit"

  # The default github_latest strategy reads the tag, which carries the version
  # and not the build, so it reports 0.1.0 against a cask version of 0.1.0,30
  # and every check looks like a mismatch. The build number only exists in the
  # asset filename, so the release's assets are what get read here.
  livecheck do
    url :url
    regex(/Tickit[._-]v?(\d+(?:\.\d+)+)[._-](\d+)\.zip/i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  depends_on macos: :sonoma

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
