---
title: Fedora Sericeaを試した
date: 2023-06-08T18:34:54+09:00
happenDate: 2023-06-08
tags:
  - 日記
archives:
  - 2023
  - 2023-06
  - Fedora
---

いつの間にか[Fedora Sericea](https://fedoraproject.org/sericea/)という新しいイミュータブルデスクトップがリリースされていたので試してみた。タイル型ウィンドウマネージャの[Sway](https://swaywm.org/)を使っているのが特長。他にもディスプレイマネージャに[sddm](https://github.com/sddm/sddm)とかファイルマネージャに[Thunar](https://docs.xfce.org/xfce/thunar/start)を採用しており、自分が[LXQt](https://lxqt-project.org/)とか[Xfce](https://www.xfce.org/?lang=ja)使っていた頃を思い出した。

Fedora Silverblueから乗り換えるのはとても簡単で、以下をおこなうだけ

```shell
rpm-ostree rebase fedora/38/x86_64/sericea
systemctl reboot
```

起動するとsddmのログイン画面がみえる。ログインしてからSwayの使い方が分からず、[Fedora Sericeaのデフォルト設定](https://gitlab.com/fedora/sigs/sway/sway-config-fedora/-/blob/fedora/sway/config.in)を参照した。ターミナルの起動は `mod + Enter` 、dmenu（アプリケーションラインチャー）の起動は `mod + d` 、ログインセッションの終了は `mod + Shift + E` らしい。

次に気づいたのは、使用しているキーボードが日本語配列なのに英語配列として認識されていることで、以下の設定を `~/.config/sway/config.d/10-keymap.conf` に追加してすべての入力デバイスにキーボードレイアウトは日本語配列を使用するように指定した。

```
input * {
  xkb_kayout "jp"
}
```

あとは入力メソッドが使えれば常用できる！思ったので `ibus-setup` などを試すと、デフォルトではibusデーモンが起動されない様子。以下の設定を `~/.config/sway/config.d/20-ibus.conf` に追加してログイン時ibusデーモンが起動されるようにする。

```
exec ibus-daemon -drx
```

また、起動したアプリケーションでibusが使えるように環境変数を `~/.config/environment.d/10-ibus.conf` に設定する（Waylandは.xprofileなどを参照しないので代わりに次のようにするらしい）

```
GTK_IM_MODULE=ibus
QT_IM_MODULE=ibus
XMODIFIERS="@im=ibus"
```

これでibus使えそうと思ったが、入力メソッドの切り替えがうまくいかない。キーバインドを変更して `Shift + Space` で入力メソッドが切り替わらないし、Anthyのオン・オフも効かない。あとシステムトレイに今使っている入力メソッドが表示されない[^Chewie Lin]。Fcitx使えば問題なさそうだけど、なんとなくibusが使いたかったので諦めてSilverblueに戻した。

[^Chewie Lin]: https://blog.chewie-lin.me/uim によれば、 `XDG_CURRENT_DESKTOP=KDE ibus-daemon -drx` すると表示される。
