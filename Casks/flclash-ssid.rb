cask "flclash-ssid" do
  version "0.9.1,2026102202"

  name "FlClash"
  desc "Proxy client with Wi-Fi SSID mode rules"
  homepage "https://github.com/yanjinbin/FlClash-SSID"

  on_arm do
    sha256 "981c76b76cf14c2302f4965a218ea4676eb5e77e9d4d8620e45d60556e4ebc29"
    url "https://github.com/yanjinbin/FlClash-SSID/releases/download/ssid-#{version.csv.first}-#{version.csv.second}/FlClash-#{version.csv.first}-macos-arm64.dmg"
  end

  on_intel do
    sha256 "20312efa772eeec606eed94909c4572688ab917418c8ed8b9a5b8a08e26a4a38"
    url "https://github.com/yanjinbin/FlClash-SSID/releases/download/ssid-#{version.csv.first}-#{version.csv.second}/FlClash-#{version.csv.first}-macos-amd64.dmg"
  end

  conflicts_with cask: "flclash"

  app "FlClash.app"

  caveats <<~EOS
    This build is ad-hoc signed, not notarized. If macOS refuses to open it:
      xattr -dr com.apple.quarantine /Applications/FlClash.app
  EOS
end
