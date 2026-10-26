cask "flclash-ssid" do
  version "0.9.2,2026102601"

  name "FlClash"
  desc "Proxy client with Wi-Fi SSID mode rules"
  homepage "https://github.com/yanjinbin/FlClash-SSID"

  on_arm do
    sha256 "84a2915eae90c8057de1905053abb5b16e924f591ed752bf60e99c21a810e262"
    url "https://github.com/yanjinbin/FlClash-SSID/releases/download/ssid-0.9.2-2026102601/FlClash-0.9.2-macos-arm64.dmg"
  end

  on_intel do
    sha256 "02eef8bd4aee86b3f03c61280273c1639d7efa35bf8a84fb01ca68877c7d9ec9"
    url "https://github.com/yanjinbin/FlClash-SSID/releases/download/ssid-0.9.2-2026102601/FlClash-0.9.2-macos-amd64.dmg"
  end

  conflicts_with cask: "flclash"

  app "FlClash.app"

  caveats <<~EOS
    This build is ad-hoc signed, not notarized. If macOS refuses to open it:
      xattr -dr com.apple.quarantine /Applications/FlClash.app
  EOS
end
