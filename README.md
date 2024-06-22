# Xcode and Simulator Runtime Installer

Scripts to install Xcode and simulator runtimes from pre-existing packages.

Usage:

    install_xcode.sh path/to/Xcode.xip /Applications/Xcode.app

    install_runtime.sh path/to/runtime.dmg

Tested with Xcode 14.x—16-beta and iOS runtimes 15.x—18-beta.

## Where to obtain packages

- Manual download from https://developer.apple.com/download/all/.

- JSON representation of the same downloads:

      curl -fL 'https://developer.apple.com/services-account/QH65B2/downloadws/listDownloads.action'
          -X POST -d '{}' -H 'Content-type: application/json' \
          -H 'Cookie: ...' \
          | gunzip | jq

  This requires cookies for developer.apple.com domain (e.g. extracted from the
  browser).

- All simulator runtime downloads:

      curl -fL 'https://devimages-cdn.apple.com/downloads/xcode/simulators/index2.dvtdownloadableindex' \
          | plutil -convert json -o - - | jq

  Some downloads require cookies for download.developer.apple.com domain.
