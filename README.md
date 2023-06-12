# 勤怠システムを開発しよう！

これはセレブエンジニアサロンの教材で作られたサンプルアプリケーションです。

## 開発環境

* AWS Cloud9
* Ruby
* Rails
* Git
* Git(HTTPSからSSH通信へ変更)
* 
<% @total_working_hours += working_hours %>
              <%= str_times = working_times(day.started_at, day.finished_at) %>
              <% @total_working_times = @total_working_times.to_f + str_times.to_f %>