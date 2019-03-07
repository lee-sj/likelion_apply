require 'rubygems'
require 'mechanize'

## 로그인 과정 
mechanize = Mechanize.new
page = mechanize.get('https://apply.likelion.org/accounts/login/')
form = page.forms.first
form['username'] = 'UNIV_EMAIL' #본인학교 계정 email 을 입력합니다. 
form['password'] = 'PASSWORD'   #본인학교 계정의 비밀번호를 입력합니다. 
page = form.submit
univ = mechanize.get('https://apply.likelion.org/apply/univ/NUMBER')
# 크게 상관 없지만 NUMBER에 그래도 본인학교의 url에 있는 숫자를 입력합니다 

name = []
list = []
major = []
## 정보들 모으는 과정 
# NUMBER 에 본인 학교에서 지원서를 제출한 인원의 숫자를 적습니다. 
(1..NUMBER).each do |i|
name[i] = univ.search("#likelion_num .applicant_page a:nth-child(#{i}) .user_name").text
major[i] = univ.search("#likelion_num .applicant_page a:nth-child(#{i}) .user_profile").text.split(" ")[-1]
list[i] = univ.search("#likelion_num .applicant_page a:nth-child(#{i})")
link = univ.link_with(text: "#{list[i].text}")
user = link.click
number = user.uri.to_s.split("/")[-1]
user_page = mechanize.get("https://apply.likelion.org/apply/applicant/#{number}")
user_info = user_page.search("#likelion_num  div:nth-child(2) > div.row.s_mt").text
puts name[i] + ' ' + major[i] + ' ' + user_info.to_s.split(" ")[0] + ' ' + user_info.to_s.split(" ")[2]
end
