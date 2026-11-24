cask "flclash-ssid" do
  version "0.9.4,2026112401"

  name "FlClash"
  desc "Proxy client with Wi-Fi SSID mode rules"
  homepage "https://github.com/yanjinbin/FlClash-SSID"

  on_arm do
    sha256 "fc16109579336ee1f499bcb1863663bf11b8563a505bd42319fbca879e081d1b"
    url "https://github.com/yanjinbin/FlClash-SSID/releases/download/ssid-0.9.4-2026112401/FlClash-0.9.4-macos-arm64.dmg"
  end

  on_intel do
    sha256 "562e084d92096989ad54e9c6a70419bfa66153ef001c756933571fa66bdd3df0"
    url "https://github.com/yanjinbin/FlClash-SSID/releases/download/ssid-0.9.4-2026112401/FlClash-0.9.4-macos-amd64.dmg"
  end

  conflicts_with cask: "flclash"

  app "FlClash.app"

  caveats <<~EOS
    This build is ad-hoc signed, not notarized. If macOS refuses to open it:
      xattr -dr com.apple.quarantine /Applications/FlClash.app
  EOS
end
