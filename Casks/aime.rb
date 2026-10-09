cask "aime" do
  version "0.1.7"
  sha256 "a12ce695fdf396b3fa164bebaa61401d524c4ae906d5643224e0baf753bbcd0f"

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
