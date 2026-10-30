cask "flclash-ssid" do
  version "0.9.2,2026103001"

  name "FlClash"
  desc "Proxy client with Wi-Fi SSID mode rules"
  homepage "https://github.com/yanjinbin/FlClash-SSID"

  on_arm do
    sha256 "669e116bfbc4c8d58b0b0c73080303eacc4d6de2e56244e0295339e750b6d3af"
    url "https://github.com/yanjinbin/FlClash-SSID/releases/download/ssid-0.9.2-2026103001/FlClash-0.9.2-macos-arm64.dmg"
  end

  on_intel do
    sha256 "8e8c39f1e182fd578b67de0d7d47b33870ee6593517e4def43e3e051c8a5de79"
    url "https://github.com/yanjinbin/FlClash-SSID/releases/download/ssid-0.9.2-2026103001/FlClash-0.9.2-macos-amd64.dmg"
  end

  conflicts_with cask: "flclash"

  app "FlClash.app"

  caveats <<~EOS
    This build is ad-hoc signed, not notarized. If macOS refuses to open it:
      xattr -dr com.apple.quarantine /Applications/FlClash.app
  EOS
end
