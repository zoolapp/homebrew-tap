cask "aime" do
  version "0.1.8"
  sha256 "b1fd3bf9efd162cb159ec83f71fa5a9650e837c336943a8651f7fd21b7ed321c"

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
    AIME registers itself as an input source during installation. After the first
    install, macOS lists it only after you log out and back in (or restart) once.
    If it still does not appear, add it in System Settings › Keyboard › Input Sources.
    首次安装后需要注销或重启一次，艾么输入法才会出现在输入法列表里。
  EOS
end
