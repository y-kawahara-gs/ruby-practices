#!/usr/bin/env ruby

#optparseライブラリとdate クラスを読み込み
require 'optparse'
require 'date'

#月・年の変数宣言
month = 0
year = 0

#optparseライブラリでオブジェクトの生成
opt = OptionParser.new

#各オプションの仕様を指定
opt.on('-m int') {|v| month = v.to_i }
opt.on('-y int') {|v| year = v.to_i }

#配列に格納されているARGVを引数で処理できるようにする
opt.parse!(ARGV)
#今日の日付の取得
day = DateTime.now

#オプション指定のない場合、今月の月表示をする処理
if month == 0 && year == 0
  month = day.month
  year = day.year
elsif year == 0
  year = day.year
end

#月の始めを変数に代入
date_f = Date.new(year, month, 1)
#月の終わりを変数に代入
date_l = Date.new(year, month,-1)

#カレンダーのヘッダー
puts"#{month}月 #{year}".center(21)
puts "日 月 火 水 木 金 土"

#月始めまでの余白
wday_f = date_f.wday
blank = "   " * wday_f
print blank

#1桁の場合と土曜日で改行を行う処理
(date_f..date_l).each do |x|
  #1桁かつ土曜日の場合：スペースと改行
  if x.strftime('%a') == "Sat" && x.strftime('%-d').to_i < 10
    print " #{x.strftime('%-d')}\n"
  #土曜日の場合：改行
  elsif x.strftime('%a') == "Sat" 
    print "#{x.strftime('%-d')}\n"
  #1桁の場合：スペース
  elsif x.strftime('%-d').to_i < 10
    print  " #{x.strftime('%-d')} "
  #それ以外
  else
    print "#{x.strftime('%-d')} "
  end
end


