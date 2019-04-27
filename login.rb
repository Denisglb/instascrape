require 'mechanize'

agent = Mechanize.new
pp agent.get('https://www.instagram.com/accounts/login/?force_classic_login')
pp agent.page.forms[0]['username'] = 'denisglb28'
pp agent.page.forms[0]['password'] = 'Verysecurepass1'
agent.page.forms[0].submit