# yanjinbin Homebrew tap

Personal macOS builds that are not in the upstream casks: FlClash forks with
Wi-Fi SSID rules, and other modified or self-built apps as they appear.

## Install

```sh
brew install --cask yanjinbin/tap/flclash-ssid
```

`brew` taps the repository on its own; `brew tap yanjinbin/tap` once if you
prefer to browse first.

## Casks

| Cask | App | Notes |
| --- | --- | --- |
| `flclash-ssid` | FlClash | Wi-Fi SSID mode rules; follows the latest [FlClash-SSID](https://github.com/yanjinbin/FlClash-SSID) release |

Upgrade and remove with the usual commands:

```sh
brew upgrade --cask flclash-ssid
brew uninstall --cask flclash-ssid
```

These builds are ad-hoc signed rather than notarized. If macOS refuses to open
one, clear the quarantine flag:

```sh
xattr -dr com.apple.quarantine /Applications/FlClash.app
```

## How updates work

[`update-casks.yml`](.github/workflows/update-casks.yml) runs every six hours
and after a manual dispatch. It reads each project's **latest** release, takes
the `sha256:` digest GitHub reports for the chosen assets, and rewrites the
cask's version, checksums and URLs. Nothing is committed when the cask already
matches.

A release only reaches the tap after it is published as the project's latest
release, so a half-uploaded build never lands here.

## Adding another app

1. Add `Casks/<token>.rb`. Keep the `on_arm` / `on_intel` shape so the updater
   can find the checksum and URL lines:

   ```ruby
   cask "<token>" do
     version "1.2.3,2026102201"

     name "App Name"
     desc "What the app does"
     homepage "https://github.com/yanjinbin/<repo>"

     on_arm do
       sha256 "<sha256 of the arm64 dmg>"
       url "https://github.com/yanjinbin/<repo>/releases/download/<tag>/<asset>"
     end

     on_intel do
       sha256 "<sha256 of the amd64 dmg>"
       url "https://github.com/yanjinbin/<repo>/releases/download/<tag>/<asset>"
     end

     app "App Name.app"
   end
   ```

   Use a token different from any upstream cask with the same name, and add
   `conflicts_with cask: "<upstream>"` when both would install the same bundle.
   For Apple Silicon only, keep `on_intel` out and list just `"arm"` in the
   manifest.

2. Teach the updater about it in [`casks.json`](casks.json):

   ```json
   {
     "<token>": {
       "repo": "yanjinbin/<repo>",
       "tag": "v{app}",
       "version": "{app}",
       "assets": {
         "arm": "App-{app}-macos-arm64.dmg",
         "intel": "App-{app}-macos-amd64.dmg"
       }
     }
   }
   ```

   `tag` is a pattern over the release tag; `{app}` accepts digits and dots,
   `{build}` accepts digits. `version` is the cask version string. `assets`
   names the release files per architecture; the URL is derived from the repo,
   the tag and the name.

3. Run the workflow once (`Actions → update-casks → Run workflow`) and check:

   ```sh
   brew tap yanjinbin/tap
   brew info --cask yanjinbin/tap/<token>
   brew fetch --cask yanjinbin/tap/<token>
   ```

   `brew fetch` verifies the checksum without installing.
