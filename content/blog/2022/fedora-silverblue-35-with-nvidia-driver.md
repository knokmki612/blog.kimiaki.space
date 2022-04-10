---
title: Fedora Silverblue 35でNVIDIAのグラフィックドライバーを使う
date: 2022-04-10T11:05:17+09:00
tags:
  - Tips
  - Fedora Silverblue
archives:
  - 2022
  - 2022-04
---

NVIDIAのグラフィックボードを使っている環境では、デフォルトだとグラフィックドライバーとして[Nouveau](https://nouveau.freedesktop.org/)が使われる。しかし、比較的新しいグラフィックボードを使っている場合や、CUDA、NVENCなどを使いたい場合はNVIDIAが提供しているドライバーが必要になる。

Fedora Silverblue 35時点でどのような手順で導入することになるか記しておきたいと思う。

最新の情報が知りたければ、注釈に入れているurlを参照してもらいたい。

### RPM Fusionリポジトリの追加[^リポジトリの追加]

[^リポジトリの追加]: https://rpmfusion.org/Configuration

NVIDIAのドライバーはFedora / RHELでは提供されておらず、RPM Fusionがコンパイル済みのRPMパッケージを提供してくれている。

RPM FusionではOSSなパッケージはfree、プロプライエタリなパッケージはnonfreeのリポジトリで提供されている。Nvidiaのドライバーはプロプライエタリなので、nonfreeのリポジトリを追加する必要がある。nonfreeのリポジトリを利用するにもfreeのリポジトリが必要なので、両方追加する。

```shell
# freeのリポジトリの追加
rpm-ostree https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
# nonfreeのリポジトリの追加
https://mirrors.rpmfusion.org/free/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
# リポジトリのパッケージを利用するには再起動が必要
systemctl reboot
```

### NVIDIAのドライバーのインストールと設定[^インストールと設定]

[^インストールと設定]: https://rpmfusion.org/Howto/NVIDIA

```shell
# カーネルモジュール、ディスプレイドライバー、CUDA関連、電源管理関連のパッケージのインストール
rpm-ostree install akmod-nvidia xorg-x11-drv-nvidia{,-cuda,-cuda-libs,-power}
# Nouveauの代わりにNvidiaのドライバーを使うなどのカーネルパラメーターの設定
rpm-ostree kargs --append=rd.driver.blacklist=nouveau --append=modprobe.blacklist=nouveau --append=nvidia-drm.modeset=1
# 反映には再起動が必要
systemctl reboot
# 電源管理関連のサービスを自動起動するように変更
systemctl enable nvidia-{suspend,resume,hibernate}
```

### Flatpakの更新

Flatpakのアプリケーションは、別途NVIDIAのドライバーをFlatpakのランタイムとしてインストールする必要がある。そのためには、"ソフトウェア"アプリからアップデートするか、 `flatpak update` を実行すればいい。
