---
title: "GPD WIN Max 2 2023がサスペンド後すぐ復帰しないようにする"
date: 2023-08-26T10:26:42+09:00
tags:
- GPD
- Fedora
- Tips
---

[GPD WIN Max 2 2023](https://gpd.hk/gpdwinmax2)を手に入れたので、ストレージの拡張スロットにFedora Silverblueを入れてみたら利用上ほぼほぼ支障なかった。

ただし、サスペンドは正常に動くものの、勝手に復帰してしまうのでそれを解消した。

同じGPD WIN Max 2所有者の情報がないかなと調べてみた[^1]ら、復帰のACPIイベントを呼んでいるデバイスがありそうなことが分かった。[ArchWikiに復帰トリガーに関するページがあった](https://wiki.archlinux.jp/index.php/%E9%9B%BB%E6%BA%90%E7%AE%A1%E7%90%86/%E5%BE%A9%E5%B8%B0%E3%83%88%E3%83%AA%E3%82%AC%E3%83%BC)ので参考に調べてみると、以下のように幾つかのデバイスで復帰トリガーが有効であることが分かった。[^note]

[^1]: https://blog.nhiroki.net/2023/01/07/gpd-win-max-2-ubuntu-22-10
[^note]:実際の出力結果を得るのが面倒くさかったので再現したものであることに注意

```console
$ cat /proc/acpi/wakeup 
Device	S-state	  Status   Sysfs node
GPP1	  S4	*enabled   pci:0000:00:01.2
GPP0	  S4	*disabled
GPP6	  S4	*enabled   pci:0000:00:02.2
GPP7	  S4	*enabled   pci:0000:00:02.3
GP11	  S4	*disabled
SWUS	  S4	*disabled
GP12	  S4	*enabled   pci:0000:00:04.1
SWUS	  S4	*disabled
XHC0	  S4	*enabled   pci:0000:65:00.3
XHC1	  S4	*enabled   pci:0000:65:00.4
XHC2	  S3	*disabled  pci:0000:67:00.0
XHC3	  S3	*enabled   pci:0000:67:00.3
XHC4	  S3	*enabled   pci:0000:67:00.4
NHI0	  S4	*disabled
NHI1	  S3	*enabled   pci:0000:67:00.6
```

なので復帰トリガーを有効にしているデバイスの復帰トリガーを無効にすればいいんだけど、Fedora Silverblueの場合はOSTreeによる管理上読み取り専用のディレクトリが存在し、 `/lib/systemd/system-sleep` 配下にフックスクリプトを置く方法をとることができない。

[ArchWikiのフックの注記](https://wiki.archlinux.jp/index.php/%E9%9B%BB%E6%BA%90%E7%AE%A1%E7%90%86#.2Fusr.2Flib.2Fsystemd.2Fsystem-sleep_.E3.81.AE.E3.83.95.E3.83.83.E3.82.AF)にもあるが、Systemdユニットでも同じタイミングをフックすることができるのでその方針をとろうとした。

これまた似たようなことをしている人がいないか調べた[^2]ら、起動時に一回だけ復帰トリガーを無効にすることで解決していたので、毎回どのデバイスで復帰トリガーが有効になっているか変化しないならこれでもいいかなと思った。

[^2]: https://sgyatto.hatenablog.com/entry/kubuntu-suspend

そういうわけで、以下の内容でユニットファイルを用意して `/etc/systemd/system/gpd-win-max-2-2023-disable-wakeup.service` に配置した。

```toml
[Unit]
Description=Disable Wakeup

[Service]
Type=oneshot
ExecStart=sh -c 'for DEVICE in GPP1 GPP6 GPP7 GP12 XHC0 XHC1 XHC3 XHC4 NHI1; do echo $DEVICE > /proc/acpi/wakeup; done'

[Install]
WantedBy=default.target
```

その後、 `systemctl enable gpd-win-max-2-2023-disable-wakeup.service` を実行して再起動し、サスペンド後勝手に復帰しないことを確認した。
