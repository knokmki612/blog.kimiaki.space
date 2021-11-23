---
title: 作ったもの
date: 2015-11-27T13:48:39+09:00
menu:
  main:
    identifier: product
    title: 作ったもの
    weight: 2
---

## Androidアプリケーション

### [Ringspot (リンスポット)](https://play.google.com/store/apps/details?id=jp.techinstitute.tiad1401313.ringspot)

位置情報を利用して、現在位置にあわせて着信音のオン/オフ、着信音の変更ができるようになるアプリです。

## UNIX系アプリケーション

### [sitesh](https://github.com/knokmki612/sitesh)

このサイトの執筆・運用のために自作したブロギングツールです。使い方の記事は[こちら]({{% relref "/blog/2015/release-sitesh" %}})

### [twm-ohki](https://github.com/knokmki612/twm-ohki)

{{% image src="screenshot.jpg" caption="縦書きタイトルオプションを使っている様子" %}}

古典的なx11ウィンドウマネージャであるtwmのタイトルバーの拡張等を施したものを、[大木 敦雄氏](http://www2.gssm.otsuka.tsukuba.ac.jp/staff/ohki/)が2008年から公開されています。が、LANG=Cの環境以外ではクラッシュするバグなどが存在しています。

そのバグ修正や挙動変更をしたり、[freedesktopプロジェクトでメンテナンス](https://cgit.freedesktop.org/xorg/app/twm/)されているtwmのコードを取り込めるよう、gitでコードを管理できるようにしたものです。なんでこんなことをしたかというと、ユニークな機能で良いなと思っていたのと、知り合いに利用している人がいて、前述のバグで困っていたためです。
