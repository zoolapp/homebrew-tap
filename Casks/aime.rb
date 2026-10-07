cask "aime" do
  version "0.1.4"
  sha256 "b0ffc769308c2bc103af7f6e65ab6246fad4979ed3e371563319c3111d1be5e4"

  url "https://get.zool.app/aime/#{version}/AIME-#{version}.pkg"
  name "AIME"
  desc "AI-enhanced Chinese input method built on librime"
  homepage "https://aime.zool.app/"

  livecheck do
    url "https://get.zool.app/aime/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  depends_on macos: :tahoe

  pkg "AIME-#{version}.pkg"

  uninstall quit:    "app.zool.inputmethod.aime",
            pkgutil: "app.zool.inputmethod.aime.pkg",
            delete:  [
              "/Applications/AIME Settings.app",
              "/Library/Input Methods/AIME.app",
            ]

  zap trash: [
    "~/Library/AIME",
    "~/Library/Application Support/AIME",
    "~/Library/Caches/app.zool.aime.settings",
    "~/Library/Caches/app.zool.inputmethod.aime",
    "~/Library/HTTPStorages/app.zool.aime.settings",
    "~/Library/HTTPStorages/app.zool.aime.settings.binarycookies",
    "~/Library/HTTPStorages/app.zool.inputmethod.aime",
    "~/Library/HTTPStorages/app.zool.inputmethod.aime.binarycookies",
    "~/Library/Preferences/app.zool.aime.settings.plist",
    "~/Library/Preferences/app.zool.inputmethod.aime.plist",
  ]

  caveats <<~EOS
    AIME registers itself as an input source during installation.
    If it does not appear, add it in System Settings › Keyboard › Input Sources.
  EOS
end
