require 'application_system_test_case'

class SequencesTest < ApplicationSystemTestCase
  setup do
    @driver = Capybara.current_session.driver.browser
    @vars = {}
  end

  test 'checking input to be equal string with user input' do
    @driver.get(root_url)
    @driver.find_element(:id, 'values').send_keys('0 3 6 8')
    @driver.find_element(:id, 'btn_commit').click
    assert_selector '#typed_output', text: '0 3 6 8'
  end
  test 'checking error message for incorrect input' do
    @driver.get(root_url)
    @driver.find_element(:id, 'values').send_keys('0 3 abc')
    @driver.find_element(:id, 'btn_commit').click
    assert_selector '#error_output', text: 'Введены посторонние символы'
  end
  test 'checking error message for empty input' do
    @driver.get(root_url)
    @driver.find_element(:id, 'values').send_keys('')
    @driver.find_element(:id, 'btn_commit').click
    assert_selector '#error_output', text: 'Вы ничего не ввели'
  end
  test 'checking error message for sequence len < 10' do
    @driver.get(root_url)
    @driver.find_element(:id, 'values').send_keys('0 3 1')
    @driver.find_element(:id, 'btn_commit').click
    assert_selector '#error_output', text: 'Последовательность короче 10 чисел'
  end
  test 'checking correct answer for sequence with 1 subsequence' do
    @driver.get(root_url)
    @driver.find_element(:id, 'values').send_keys(' 1 2 3   4 5 7 78  4 3 2')
    @driver.find_element(:id, 'btn_commit').click
    assert_selector '#result_field', text: '1 2 3 4 5 7 78'
    assert_selector '#result_field0', text: '1 2 3 4 5 7 78'
  end
  test 'checking correct answer for sequence with 4 subsequences' do
    @driver.get(root_url)
    @driver.find_element(:id, 'values').send_keys('1  2 -3 4 -5 -3  7 -78   4 3 2')
    @driver.find_element(:id, 'btn_commit').click
    assert_selector '#result_field', text: '-5 -3 7'
    assert_selector '#result_field0', text: '1 2'
    assert_selector '#result_field1', text: '-3 4'
    assert_selector '#result_field2', text: '-5 -3 7'
    assert_selector '#result_field3', text: '-78 4'
  end
end