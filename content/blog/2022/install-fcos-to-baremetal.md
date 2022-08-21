---
title: Fedora CoreOSを自宅サーバにインストールする
date: 2022-08-21T10:52:32+09:00
happenDate: 2022-08-21
tags:
  - Tips
  - Fedora CoreOS
archives:
  - 2022
  - 2022-08
---

[OptiPlex 7010 USFF](https://www.dell.com/support/home/ja-jp/product-support/product/optiplex-7010/docs)をひょんなことで入手したので、[Fedora CoreOS](https://getfedora.org/ja/coreos?stream=stable)をインストールしてみた。基本的には[Getting Started](https://docs.fedoraproject.org/en-US/fedora-coreos/getting-started/)の通りにやればいい…のがよかったけど、そうもいかなったので手順を記したいと思う。

### ディスクイメージを入手する

ストリームがStable、Testing、Nextで選べるようだけどとりあえず[StableのBare Metal用ISO](https://getfedora.org/ja/coreos/download?tab=metal_virtualized&stream=stable&arch=x86_64)をダウンロード。ブータブルUSBメモリは[Popsicle](https://github.com/pop-os/popsicle)で作成。

### Ignitionファイルを用意する

Getting Startedだと以降の手順はAmazon EC2インスタンスにインストールする例が紹介されており、別のドキュメントを参照する必要があった。

サイトを見回してProvisioning Machinesのうちの[Installing on Bare Metal](https://docs.fedoraproject.org/en-US/fedora-coreos/bare-metal/)を発見。前提条件としてIgnitionファイルをHTTPサーバなどでホストしてね、と書いてあるけど面倒くさい、それ以外の方法ないの…？と思った。Ignitionファイルはcoreos-installerというCLIで指定するようなので、[コマンドの使い方](https://coreos.github.io/coreos-installer/cmd/install/)をみると、 `--ignition-file` オプションでローカルからIgnitionファイルを参照することも可能と分かった。

それで[Ingition](https://docs.fedoraproject.org/en-US/fedora-coreos/producing-ign/)ファイルとはなんぞやというと、初回セットアップに使う設定ファイルとして以下の手順で用意するらしい。

1. YAMLフォーマットでButaneコンフィグ（`.bu` 拡張子のファイル）を書く
2. ButaneでJSONフォーマットのIgnitionコンフィグ（`.ign` 拡張子のファイル）に変換する

Ignitionファイルが用意できたら、Live ISOを起動して `coreos-installer install` と `sudo reboot` するだけ。なので、Butaneファイルにどんな設定を書くかが一番重要。


初期状態だとcoreアカウントは作成されるけどパスワードもSSHの認証も設定されないので、最低限その辺の設定が必要。

私がやりたかったのは

- SSH接続
- ローカルログイン
- dockerが使える
- sudo時パスワード認証
- mDNSで名前解決

で、以下のドキュメントとディスカッションが参考になった。

- [Using an SSH Key](https://docs.fedoraproject.org/en-US/fedora-coreos/authentication/#_using_an_ssh_key)
- [Using Password Authentication](https://docs.fedoraproject.org/en-US/fedora-coreos/authentication/#_using_password_authentication)
- [Configuring Groups](https://docs.fedoraproject.org/en-US/fedora-coreos/authentication/#_configuring_groups)
- [Setting a Hostname](https://docs.fedoraproject.org/en-US/fedora-coreos/hostname/)
- [Correct way to enable mDNS on Fedora Server 34?](https://discussion.fedoraproject.org/t/correct-way-to-enable-mdns-on-fedora-server-34/34641)

試行錯誤した結果、以下のように `config.bu` をつくった。

```yaml
variant: fcos
version: 1.4.0
passwd:
  users:
    - name: <ユーザ名>
      ssh_authorized_keys:
        - <SSH接続で使用する公開鍵>
      password_hash: <podman run -it --rm quay.io/coreos/mkpasswd --method=yescryptして得られるハッシュ>
      groups:
        - docker
        - wheel
storage:
  files:
    - path: /etc/hostname
      mode: 0644
      contents:
        inline: |
          fedora-coreos
    - path: /etc/NetworkManager/conf.d/enable-mdns.conf
      mode: 0644
      contents:
        inline: |
          [connection]
          connection.mdns=2
    - path: /etc/systemd/resolved.conf
      mode: 0644
      append:
        - inline: |
            MulticastDNS=yes
```

次はButanファイルをIgnitionファイルにする。[コンテナーでBlutanを動作させて](https://docs.fedoraproject.org/en-US/fedora-coreos/producing-ign/#_via_a_container_with_podman_or_docker)変換した。（自分はFedora Silverblueを使っていてpodmanが入っているのでpodmanを使っているけど、dockerでもできるはず）

```shell
podman run -i --rm quay.io/coreos/butane:release --pretty --strict < config.bu > config.ign
```

### インストールする

できたIgnitionファイルをブータブルUSBメモリとは別のUSBメモリにコピー。ブータブルUSBメモリとIgnitionファイルをコピーしたUSBメモリをOptiPlex 7010 USFFに挿して起動。

`fdisk` で中身をみて、以下のようにディスクが割り当てられていることを確認。

- sda: インストール先のディスク
- sdb: ブータブルUSBメモリ
- sdc: IgnitionファイルをコピーしたUSBメモリ

以下のコマンドを実行。

```
sudo mkdir /var/usb
sudo mount /dev/sdc1 /var/usb
sudo coreos-installer /dev/sda --ignition-file /var/usb/config.ign
```

インストールはほぼほぼ2～3GBをddしたみたいな時間で終わった。終わったら `sudo reboot` して素早くUSBメモリを抜く。

しばらくしたら `ssh -i <秘密鍵> <ユーザ名>@fedora-coreos.local` でSSH接続可能になった。

### 感想（とオチ）

設定をIgnitionファイルとして用意すれば、インストール後のセットアップが不要になるのはとても便利だと思った。また、[自動でOSアップデートしてくれるらしい](https://docs.fedoraproject.org/en-US/fedora-coreos/auto-updates/)ので立ち上げっぱなしにしたら放置でいいのも便利だと思った。

一方でIgnitionファイルはあくまで初回セットアップにのみ使うので、インストール後に設定を変更したい場合は他のLinuxディストリビューションと同じように `/etc` 下にファイルを追加したり編集する必要がある。NixOSだと設定変更時も同じ `/etc/nixos/configuration.nix` を弄って `nix-rebuild switch` すればいいから、そこは好みが分かれると思った。

インストールできたのはいいけど、OptiPlex 7010 USFFをどこにおくかもどんなふうにEthernetケーブルを引くかも決まっていないので、悩ましいなと思った。
