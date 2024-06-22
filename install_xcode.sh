#!/bin/bash -e
# Copyright 2024 Namespace Labs Inc. Licensed under the MIT License.

log() { echo "$@" >&2; }
die() { log "$@"; exit 1; }
[ $# -eq 2 ] || die "usage: $0 path/to/Xcode.xip /Applications/Xcode.app"

xip=$1
dest=$2
tmp=$(mktemp -d)

cleanup() {
    set +e
    if [ -d "$tmp" ]; then
        log "Removing $tmp..."
        rm -rf "$tmp"
    fi
}
trap cleanup EXIT

log "Unxiping $xip into $tmp..."
unxip "$xip" "$tmp"
bundle=$(echo "$tmp"/*)

log "Verifying $bundle..."
codesign -vv -d "$bundle"
spctl --assess --verbose --type execute "$bundle"

log "Moving $bundle to $dest..."
mv "$bundle" "$dest"

log "Running firstRun..."
sudo "$dest/Contents/Developer/usr/bin/xcodebuild" -license accept
sudo "$dest/Contents/Developer/usr/bin/xcodebuild" -runFirstLaunch

version=$(plutil -extract CFBundleShortVersionString raw "$dest/Contents/Info.plist")
log "Installed Xcode ${version}."

# Could speed up first run, but doesn't seem to be checked by modern Xcodes.
# cacheDir=$(getconf DARWIN_USER_CACHE_DIR)
# macosBuild=$(sw_vers -buildVersion)
# xcodeBuild=$(/usr/libexec/PlistBuddy -c 'Print :ProductBuildVersion' "$dest/Contents/version.plist")
# touch "${cacheDir}com.apple.dt.Xcode.InstallCheckCache_${macosBuild}_${xcodeBuild}"
