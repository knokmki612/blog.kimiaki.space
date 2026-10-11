---
title: FlatpakのVSCode(OSS)のリポジトリが移行していて試したらLive Shareも使えた
date: 2021-07-20T01:12:52+09:00
eventDate: 2021-07-20
tags:
  - 日記
  - Tips
archives:
  - 2021
  - 2021-07
---

以前試した際は、[Live Shareに必要なライブラリ群](https://docs.microsoft.com/ja-jp/visualstudio/liveshare/reference/linux#tips-for-community-supported-distros)が[Flatpakパッケージに含まれていなかった](https://github.com/flathub/com.visualstudio.code.oss/issues/11)からなのか[なんなのか](https://github.com/flathub/com.visualstudio.code.oss/pull/31)分からないけど、動作に問題があるように感じ、別途Fedora SilverblueではLocal Packageをインストールしていた。これをしてしまうと、バージョンアップごとに `rpm-ostree install <ダウンロードしたrpmパッケージ>` とやる必要があり面倒くさい。

今週ふと「またFlatpakのVSCodeパッケージ試してみよう」と思ってOSS版のリポジトリを確認したら、[以前のリポジトリ](https://github.com/flathub/com.visualstudio.code.oss/)はアーカイブされていて、[新しいリポジトリ](https://github.com/flathub/com.visualstudio.code-oss)に移行していた。

リポジトリの移行に関連するのか分からないけど、Flatpakパッケージのパッケージングは[YAMLで書かれたマニフェストファイルで定義できる](https://docs.flatpak.org/en/latest/manifests.html)ようになっているみたいで、Flatpakパッケージのパッケージングに興味が出てきた。

初回起動時にFlatpak版特有のドキュメンテーション(実行環境の拡張、ターミナル連携の設定等)が表示される。ターミナル連携の設定がdeprecatedになっていたので、新しい書き方で[PR](https://github.com/gasinvein/vscode-flatpak-wrapper/pull/8)を出した(すぐレビューしてもらえてありがたかった)

また、自分はFedora Silverblueを使っているのでtoolboxのコンテナー環境をターミナルで使うことができ、以下のように設定した。フォントの設定もしているけどデフォルトだとひどい等幅フォントが使われていたので、よく使う `Dejavu Sans Mono` にした。

事前にコンテナー環境を作るのは `toolbox create vscode` をした。

```json
{
    "terminal.integrated.profiles.linux": {
        "toolbox": {
            "path": "/usr/bin/flatpak-spawn",
            "args":  ["--host", "toolbox", "enter", "vscode"]
        }
    },
    "terminal.integrated.defaultProfile.linux": "toolbox",
    "terminal.integrated.fontFamily": "Dejavu Sans Mono"
}
```

拡張機能をインストールしようとして接続エラーが出てインストールできないので調べたら、デフォルトでは[オープンプラットフォームなマーケットプレイス](https://open-vsx.org/)が設定されているみたい。(なぜ接続エラーがでるのかは分かっていない。issueを立てた方が良さそう)

使用するマーケットプレイスを変更する方法は[このコメント](https://github.com/flathub/com.visualstudio.code-oss/issues/11#issuecomment-782694865)と[このコメント](https://github.com/flathub/com.visualstudio.code-oss/issues/11#issuecomment-782695241)にしたがう。

`$HOME/.var/app/com.visualstudio.code-oss/config/product.json` にVSCodeのマーケットプレイスを使う設定を書く。

```json
{
  "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
  "itemUrl": "https://marketplace.visualstudio.com/items"
}
```

環境変数で先ほど書いたものを渡す。

```sh
$ flatpak --user override --env=VSCODE_EXTENSIONS_GALLERY=$HOME/.var/app/com.visualstudio.code-oss/config/product.json com.visualstudio.code-oss
```

これでESLint、Prettier、Live Shareなどの拡張機能が入れられるようになった。

Live ShareはVSCodeの起動時に毎回「We were unable to install support for joining sessions using a browser link. You may be missing key Linux libraries. Install them now?」とダイアログが表示されるが、これを「Cancel」して普通にセッションを開始することができた。ダイアログが表示されないようにしたいが分からない(issueを立てた方が良さそう)
