---
title: OSS Gate東京ワークショップ2018-09-08にサポーターで参加した
date: 2018-09-14T19:49:24+09:00
tags:
  - 日記
  - OSS Gate
archives:
  - 2018
  - 2018/09
---

* [Doorkeeper](https://oss-gate.doorkeeper.jp/events/76040)
* [使われたGitHub issues](https://github.com/oss-gate/workshop/issues?utf8=%E2%9C%93&q=OSS+Gate+Workshop%3A+Tokyo%3A+2018-09-08)
* [アンケート](https://github.com/oss-gate/workshop/tree/master/tutorial/retrospectives/2018-09-08-tokyo)

### 当日の様子

{{% image src="P_20180908_131236_vHDR_Auto_1.jpg" caption="入り口に置いてあった立て看板" %}}

会場は初めて[GMOメディア](https://www.gmo.media/)さんに提供してもらえた。GMOメディアさんの関係の方でワークショップに参加してくださった方が6〜7人くらいいたと思う。みなさん会場運営で参加の予定が、サポーターをすることになるという行き違いがあった。混乱があったけど、最終的には各々サポーターやビギナーで参加してくださった。とてもありがたかった。

{{% image src="P_20180908_154614_vHDR_Auto.jpg" caption="ワークショップ中の様子" %}}

進行役は初進行役[^実は]の[Piro](https://piro.sakura.ne.jp/)さんだった。結構ワークショップで顔をあわせていて、サポーターとしてとても経験豊富な方だったので、個人的には進行なさっている様子を完全に安心してみていた。会場もサポートメンター的によくまわってみられていて、非常にサポーター経験者やOSS開発経験者として気の利いたアドバイスをなさっていた。私は自分ではあまり踏み込んだアドバイスができてないなと毎回思っているので、見習いたいな〜と思った。

[^実は]: 実は[OSS Gate東京ワークショップ2018-07-28](https://oss-gate.doorkeeper.jp/events/76039)で初進行役をなさるはずだったけど、台風で中止になってしまった

私は15分遅刻して会場に到着してしまい、ワークショップ序盤における会場運営側の方々やPiroさんのフォローが十分にできなかった。会場についてからはサポートメンター的に会場をまわったり、主に2人のビギナーについてサポーター的にサポートしていた。

自分がついたうちの1人のビギナーについて、シナリオ通りから路線変更してサポートしてみようと思った。具体的には、なかなか動かす対象のソフトウェアが決まらなかったんだけど、たまたまUIの日本語翻訳がTODOになっているソフトウェアにたどり着いたので、それをプルリクエストにして出すことになった。結果的には順調に翻訳が済んでプルリクエストになり、後日マージされた。ビギナーの方も楽しんで取り組めたみたいだし、余った時間でシナリオに近いフィードバックのタネを思い出されたみたいで、そっちも取り組んでいる様子だったので、なんか嬉しかった。これからもビギナーの人をよく観察して柔軟にサポートしていきたいと思う。

ワークショップのアンケート回答の時間に、アンケートのプルリクエストをマージできる権限を持っている人が自分しかいないことが分かり、パニクった。前回の東京ワークショップからアンケートのYAMLの文法チェックが[CIで動くようになっており](https://github.com/oss-gate/workshop/pull/868)、これが心理的に大変助かった[^それでも]。一人で十数人のアンケートをなんとか取り込むことができた。CIがなかったら悲惨なことになっていた。

[^それでも]: それでも、アンケートファイルのファイル名が想定していないものになっていてチェックをすり抜けたものもあったりはした。難しい

ワークショップ終了後は自分含む希望者6人で懇親会に行った。会場運営側でビギナーのサポートも手伝ってくれた方から「実はOSS Gateには前から興味があったので今回参加できてよかった。自分も一度ビギナーでOSS開発を体験したくなったので、[次回の東京ワークショップ](https://oss-gate.doorkeeper.jp/events/76041)にビギナーで参加したい」という話を聞き、とても嬉しかった。

### メモしておきたいこと

#### デモについて

今回は結構な割合でビギナーの人がフィードバックまで行けた。そうなった理由のひとつとして、進行役の方針でデモの時間が少なめになっていた分、ビギナーの人が手を動かす時間を多めにとれたのではないか、という話が懇親会で出ていた。

一方でアンケートのいくつかから「やはりフィードバックのデモはほしかった」という反応もあった。デモをじっくりやる/ほぼやらないという考え方ではなく、もう少しライトにデモをやる方法を考えてみてもいいのかなと思った。

従来のデモの方法としては、

1. 完全にデモ中に動かすOSSもフィードバックの内容もライブで決めてデモしてみせる
2. 事前(当日前や当日のスキマ時間)にデモ用のissueを作って用意しておく
3. 過去のワークショップでデモに使ったissueを使う

というのが私の観測範囲とか私が進行役をしたときにあった。3\.までくるとかなり説明も準備も楽になってくる。試していないけどさらに楽な方法として、

* 過去のワークショップのビギナーのissueを使う

というのもありかなと思った。自分が説明に良さそうだと思うissueを探す手間があるけど、誰か試してみてはどうだろう？

#### ワークショップでのメモのとり方

メモのとり方の説明として、「こまめにメモをとろう」というのがある。issueでこまめに小さい粒度でコメントしてくれるのが自分は理想だと思っているんだけど、ひとつのコメントにある程度メモを書き溜める人がビギナーの半分くらいいた気がする。以前のワークショップでも手元でメモを貯める人がいたので気になっていた。

フィードバックはともかく、動かしてみる時間では小さい粒度でコメントしてくれたほうがサポートメンターをしながらissueで様子がみやすいので嬉しい。そういう方向に持っていくには、デモでGitHub issueでコメントを細かく投稿してみせるのも大事だろうなと思うし、スライドの説明を少し追加したり変えるのを検討しても良いかなと思った。