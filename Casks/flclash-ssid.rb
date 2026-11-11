cask "flclash-ssid" do
  version "0.9.3,2026111101"

  name "FlClash"
  desc "Proxy client with Wi-Fi SSID mode rules"
  homepage "https://github.com/yanjinbin/FlClash-SSID"

  on_arm do
    sha256 "003d26c043c991e79fe5b304140037cf505b757bf5110429751c429066092b0e"
    url "https://github.com/yanjinbin/FlClash-SSID/releases/download/ssid-0.9.3-2026111101/FlClash-0.9.3-macos-arm64.dmg"
  end

  on_intel do
    sha256 "8e49ede1d6cc0d82a0b588fc0aff1d010386e8e92c9616261a094944515f4435"
    url "https://github.com/yanjinbin/FlClash-SSID/releases/download/ssid-0.9.3-2026111101/FlClash-0.9.3-macos-amd64.dmg"
  end

  conflicts_with cask: "flclash"

  app "FlClash.app"

  caveats <<~EOS
    This build is ad-hoc signed, not notarized. If macOS refuses to open it:
      xattr -dr com.apple.quarantine /Applications/FlClash.app
  EOS
end
