cask "flclash-ssid" do
  version "0.9.3,2026111402"

  name "FlClash"
  desc "Proxy client with Wi-Fi SSID mode rules"
  homepage "https://github.com/yanjinbin/FlClash-SSID"

  on_arm do
    sha256 "67a5d84a0850573a6e0393c9ede600c7c5625393fb25200da7e71933b0153237"
    url "https://github.com/yanjinbin/FlClash-SSID/releases/download/ssid-0.9.3-2026111402/FlClash-0.9.3-macos-arm64.dmg"
  end

  on_intel do
    sha256 "0b0617694a3e36c5e8bed8f4a5642fddd94f0fed02d27a3a994a05f3d6514a31"
    url "https://github.com/yanjinbin/FlClash-SSID/releases/download/ssid-0.9.3-2026111402/FlClash-0.9.3-macos-amd64.dmg"
  end

  conflicts_with cask: "flclash"

  app "FlClash.app"

  caveats <<~EOS
    This build is ad-hoc signed, not notarized. If macOS refuses to open it:
      xattr -dr com.apple.quarantine /Applications/FlClash.app
  EOS
end
