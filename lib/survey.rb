class Survey < ActiveRecord::Base
  has_many(:questions)
  validates(:title, :presence => true)
  before_save(:upcase_title)

private

  def upcase_title()
    title_arr = self.title.split(' ')
    return_arr= []
    title_arr.each do |word|
      word_arr = word.split('')
      word_arr[0].upcase!
      return_arr.push(word_arr.join())
    end
    self.title = return_arr.join(' ')
  end
end
