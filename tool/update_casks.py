#!/usr/bin/env python3
"""Refresh every cask's version and checksums from its latest release."""

import json
import os
import pathlib
import re
import sys
import urllib.error
import urllib.request

ROOT = pathlib.Path(__file__).resolve().parent.parent
MANIFEST = ROOT / "casks.json"
API = "https://api.github.com"


def fail(message):
    print(message, file=sys.stderr)
    return 1


def fetch_release(repo):
    request = urllib.request.Request(
        f"{API}/repos/{repo}/releases/latest",
        headers={
            "Accept": "application/vnd.github+json",
            "User-Agent": "homebrew-tap-updater",
            **(
                {"Authorization": f"Bearer {os.environ['GITHUB_TOKEN']}"}
                if os.environ.get("GITHUB_TOKEN")
                else {}
            ),
        },
    )
    with urllib.request.urlopen(request, timeout=30) as response:
        return json.load(response)


def tag_pattern(pattern):
    pieces = []
    for piece in re.split(r"(\{[a-z]+\})", pattern):
        if piece == "{app}":
            pieces.append(r"(?P<app>[0-9]+(?:\.[0-9]+)*)")
        elif piece == "{build}":
            pieces.append(r"(?P<build>[0-9]+)")
        else:
            pieces.append(re.escape(piece))
    return re.compile("^" + "".join(pieces) + "$")


def rewrite(cask_path, version, assets):
    lines = cask_path.read_text().splitlines()
    arch = None
    changed = False
    for index, line in enumerate(lines):
        stripped = line.strip()
        if stripped == "on_arm do":
            arch = "arm"
            continue
        if stripped == "on_intel do":
            arch = "intel"
            continue
        if arch and stripped == "end":
            arch = None
            continue
        if arch and stripped.startswith('sha256 "'):
            line = f'    sha256 "{assets[arch]["sha"]}"'
        elif arch and stripped.startswith('url "'):
            line = f'    url "{assets[arch]["url"]}"'
        elif stripped.startswith('version "'):
            line = f'  version "{version}"'
        else:
            continue
        if lines[index] != line:
            lines[index] = line
            changed = True
    if changed:
        cask_path.write_text("\n".join(lines) + "\n")
    return changed


def main():
    manifest = json.loads(MANIFEST.read_text())
    status = 0
    for cask, spec in manifest.items():
        cask_path = ROOT / "Casks" / f"{cask}.rb"
        if not cask_path.exists():
            status = fail(f"{cask}: Casks/{cask}.rb is missing")
            continue
        try:
            release = fetch_release(spec["repo"])
        except urllib.error.HTTPError as error:
            status = fail(f"{cask}: {spec['repo']} has no latest release ({error})")
            continue

        match = tag_pattern(spec["tag"]).match(release["tag_name"])
        if match is None:
            status = fail(
                f"{cask}: tag {release['tag_name']} does not match {spec['tag']}"
            )
            continue
        fields = match.groupdict()
        fields["tag"] = release["tag_name"]
        version = spec["version"].format(**fields)

        digests = {
            asset["name"]: asset.get("digest", "") for asset in release["assets"]
        }
        assets = {}
        for arch, name_template in spec["assets"].items():
            name = name_template.format(**fields)
            digest = digests.get(name, "")
            if not digest.startswith("sha256:"):
                status = fail(f"{cask}: {name} has no sha256 digest in {release['tag_name']}")
                break
            assets[arch] = {
                "sha": digest.removeprefix("sha256:"),
                "url": f"https://github.com/{spec['repo']}/releases/download/"
                f"{release['tag_name']}/{name}",
            }
        if len(assets) != len(spec["assets"]):
            continue

        if rewrite(cask_path, version, assets):
            print(f"{cask}: updated to {version} ({release['tag_name']})")
        else:
            print(f"{cask}: already at {version}")
    return status


if __name__ == "__main__":
    sys.exit(main())
