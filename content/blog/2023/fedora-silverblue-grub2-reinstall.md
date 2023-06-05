---
title: UEFI環境のFedora SilverblueでGRUB 2を再インストールする
date: 2023-06-05
tags:
  - Tips
  - Fedora Silverblue
archives:
  - 2023
  - 2023-06
---

他のLinuxディストリビューションと同じノリで `sudo grub2-install /dev/sda` などと実行すると、引き続き起動はするものの以下のような現象に見舞われることになる。

- `/boot/efi/EFI/fedora/grub.cfg` と `/boot/grub2/grub.cfg` で競合して古いメニューエントリーが残る
- `sudo fwupdmgr update` したときに `/boot/efi/EFI/fedora/shim.efi` のチェックサム不一致でUEFI dbxの更新に失敗する

[GRUB 2の再インストール](https://fedoraproject.org/wiki/GRUB_2#Instructions_for_UEFI-based_systems)をするのが対処方法になるのだが、Fedora Silverblueだと `dnf reinstall` が使えないので少し工夫をする必要がある。

```shell
# 最新のFedora Toolboxコンテナーを作成して中に入る
toolbox create
toolbox enter
# パッケージをダウンロードするディレクトリを用意する
mkdir grub2
cd grub2
# GRUB 2の再インストールに必要なパッケージをダウンロードする
dnf download grub2-efi-x64 grub2-common shim-x64
exit
# 設定ファイルを再生成するためにGRUB 2設定ファイルを消す
sudo rm /boot/efi/EFI/fedora/grub.cfg rm /boot/grub2/grub.cfg
# /usr 配下を書き込み可能にしておく
sudo rpm-ostree usroverlay
# パッケージを再インストールする
sudo rpm --verbose --reinstall grub2/*
# 再起動
systemctl reboot
```
