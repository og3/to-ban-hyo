# このアプリについて
　このアプリは中央区のシェアハウス「couri八丁堀」向けに作成した、掃除当番ローテーション、LINE匿名投稿のLINEbotです
 
 ## 掃除当番ローテーション
 ### 仕様
 - 毎日ゴミ出しのリマインドメッセージと掃除当番表をLINEの専用グループに投稿する
 - DBには住人、掃除当番、掃除当番表（住人と掃除当番の組み合わせ）を保存している
 ### 開発の中止
 - DBに保存した掃除当番表にフラグを持たせ、「誰がどの当番を完了させたか」を記録したかったが、シェアハウスを退去してしまったため、開発は行なっていない
 ### 投稿例
 - 下記issuesにて
 https://github.com/og3/to-ban-hyo/issues/55
 
 ## LINE匿名投稿
 ### 仕様
 - システムの画面にテキストを入力し、LINEのグループにLINEbotを介して投稿されるようにする
 - 入力内容は保存しない
 
