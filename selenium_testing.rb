#!/usr/bin/env ruby

require 'rubygems'
require 'test/unit'
require 'watir-webdriver'

class ExampleTest < Test::Unit::TestCase
	
	#The setup method:  runs once before the tests inside this class
	def setup
		caps = Selenium::WebDriver::Remote::Capabilities.chrome
		caps.platform = 'Windows 7'
		caps.version = '31'
		caps[:name] = "Testing Chrome 31 on Windows 7"

		@browser = Watir::Browser.new(
				  :remote,
				  :url => "http://joestowe:b3b132fe-fd91-4265-83fa-0c287c041143@ondemand.saucelabs.com:80/wd/hub",
				  :desired_capabilities => caps)  
	end
	
	#This is a test to browse to bosstest, the AccountSearch page, and an AccountView page
	def test_axiom_account_search_pg
		#Tell the browser to go to bosstest
        @browser.goto "http://bosstest.careerbuilder.com/axiom"
		wait_for_text_present(@browser, "BOSSTEST")
		#Hover the cursor over the 'Account' menu item
		top_td = @browser.td :id => 'tdMenuBarItemAccount'
		wait_for_element_present(top_td, "Failed to load tdMenuBarItemAccount element.")
		top_td.hover
		#Find and click on the AccountSearch link
		sub_link = @browser.link :href => '/Axiom/Account/AccountSearch.aspx'
		wait_for_link_present(sub_link)
		spin_click_link(sub_link, "Failed to click link: [#{sub_link.text}]!")
		wait_for_text_present(@browser, "Search Accounts")
		#Click on the 'Advanced Search' tab / link
		adv_search_link = @browser.link :text => 'Advanced Search'
		wait_for_link_present(adv_search_link)
		adv_search_link.click
		wait_for_text_present(@browser, "Additional Search Options")
		#Click on an account link in the search results
		acct_view_links = @browser.links
		acct_view_link = acct_view_links.find {|l| (l.href.include? 'http://bosstest.careerbuilder.com/Axiom/Account/AccountView.aspx?Acct_DID=') && (l.text != '{Not Set}')}
		wait_for_link_present(acct_view_link)
		acct_view_link.click
		wait_for_text_present(@browser, "View Account Information")
		#Click on the 'Users' tab / link
		users_link = @browser.links.find {|l| l.href.include? 'http://bosstest.careerbuilder.com/Axiom/Account/AccountUserView.aspx'}
		wait_for_link_present(users_link)
		users_link.click
		user_name_font = @browser.font :text => 'User Name'
		wait_for_element_present(user_name_font, "Failed to display [User Name] font element.")
    end

    def teardown
        @browser.close
    end
	
	def wait_for_text_present(browser, text, msg=nil)
		msg = msg or "waiting for text %s to appear" % text
		assertion = lambda {browser.text.include? text}
		spin_assert(msg, assertion)
	end
	
	def wait_for_link_present(link, msg=nil)
		msg = msg or "waiting for link %s to appear" % link.text
		assertion = lambda {link.present?}
		spin_assert(msg, assertion)
	end
	
	def wait_for_element_present(element, msg=nil)
		msg = msg or "Failed to verify presence of element."
		assertion = lambda{element.present?}
		spin_assert(msg, assertion)
	end
	
	def spin_assert(msg, assertion)
		for i in 0..60
			begin
				assert assertion
				return
			rescue Exception => e
				#Do nothing
			end
			sleep 1
		end
		assert false, msg
	end
	
	def spin_click_link(link, msg=nil)
		for i in 0..60
			begin
				link.click
				return
			rescue Exception => e
				#Do nothing
			end
			sleep 1
		end
		assert false, msg
	end
end
	
	

