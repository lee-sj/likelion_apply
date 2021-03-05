require 'rubygems'
require 'mechanize'
require 'spreadsheet'
print "Login to applylion!\n"
## 로그인 과정 
mechanize = Mechanize.new
page = mechanize.get('https://apply.likelion.org/accounts/login/')
form = page.forms.first
form['username'] = 'UNIV_EMAIL' #본인학교 계정 email 을 입력합니다. 
form['password'] = 'PASSWORD'   #본인학교 계정의 비밀번호를 입력합니다. 
page = form.submit
univ = mechanize.get('https://apply.likelion.org/apply/univ/NUMBER')
#  NUMBER에 본인학교의 url에 있는 숫자를 입력합니다 

name = []
list = []
major = []
row = []
apply_info_1, apply_info_2, apply_info_3, apply_info_4, apply_info_5 = []
row_0 = ['이름', '전공','전화번호','이메일', '1. 지원동기', '2.만들고싶은서비스', '3. 학교별 질문 1', '4. 학교별 질문 2', '5. 학교별 질문 3']
# 학교별 개별질문 커스텀
print "Spreadsheet Generate...\n"
new_book = Spreadsheet::Workbook.new
new_book.create_worksheet :name => 'Sheet Name'
new_book.worksheet(0).insert_row(0, row_0)


## 정보들 모으는 과정 
# NUMBER 에 본인 학교에서 지원서를 제출한 인원의 숫자를 적습니다. 
(1..NUMBER).each do |i|
print "#{i} 번째 지원자 내용 생성중... \n"
name[i] = univ.search("#likelion_num .applicant_page a:nth-child(#{i}) .user_name").text
major[i] = univ.search("#likelion_num .applicant_page a:nth-child(#{i}) .user_profile").text.split(" ")[-1]
list[i] = univ.search("#likelion_num .applicant_page a:nth-child(#{i})")
link = univ.link_with(text: "#{list[i].text}")
user = link.click
number = user.uri.to_s.split("/")[-1]
user_page = mechanize.get("https://apply.likelion.org/apply/applicant/#{number}")
user_info = user_page.search("#likelion_num  div:nth-child(2) > div.row.s_mt").text
apply_info_1 = user_page.search("body > div.answer_view > div > div:nth-child(1) > div.row.m_mt > div > p").text
apply_info_2 = user_page.search("body > div.answer_view > div > div:nth-child(2) > div.row.m_mt > div > p").text
apply_info_3 = user_page.search("body > div.answer_view > div > div:nth-child(3) > div.row.m_mt > div > p").text
apply_info_4 = user_page.search("body > div.answer_view > div > div:nth-child(4) > div.row.m_mt > div > p").text
apply_info_5 = user_page.search("body > div.answer_view > div > div:nth-child(5) > div.row.m_mt > div > p").text
row[i] = [ name[i], major[i], user_info.to_s.split(" ")[0], user_info.to_s.split(" ")[2] , apply_info_1, apply_info_2, apply_info_3, apply_info_4, apply_info_5]
new_book.worksheet(0).insert_row(i, row[i])
end
new_book.write('apply.xls') # 원하는 생성 파일명으로 수정가능합니다. 
print "Done!\n"