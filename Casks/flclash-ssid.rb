cask "flclash-ssid" do
  version "0.9.3,2026111102"

  name "FlClash"
  desc "Proxy client with Wi-Fi SSID mode rules"
  homepage "https://github.com/yanjinbin/FlClash-SSID"

  on_arm do
    sha256 "14bb823a885ce3411bfb35bd1f6fbbd70c820e7598d241569e7add4246e33e25"
    url "https://github.com/yanjinbin/FlClash-SSID/releases/download/ssid-0.9.3-2026111102/FlClash-0.9.3-macos-arm64.dmg"
  end

  on_intel do
    sha256 "5c660692869a11b64465bb3b39fff8602ade843ac606a69a9e2d97bedf67ae62"
    url "https://github.com/yanjinbin/FlClash-SSID/releases/download/ssid-0.9.3-2026111102/FlClash-0.9.3-macos-amd64.dmg"
  end

  conflicts_with cask: "flclash"

  app "FlClash.app"

  caveats <<~EOS
    This build is ad-hoc signed, not notarized. If macOS refuses to open it:
      xattr -dr com.apple.quarantine /Applications/FlClash.app
  EOS
end
