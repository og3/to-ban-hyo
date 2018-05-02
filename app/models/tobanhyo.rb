class Tobanhyo < ApplicationRecord
  belongs_to :role
  belongs_to :room

  def rotate
    tobanhyo = Tobanhyo.where(fixed: 0)
    new_roles = tobanhyo.map{ |hyo| hyo.role_id }.rotate!
    tobanhyo.zip(new_roles).each do |hyo, role|
      hyo.role_id = role
      hyo.save!
    end
  end

  def create_line_msg
    tobanhyo = Tobanhyo.all
    puts "今週の掃除当番です！"
    puts "[#{Time.now.strftime('%Y/%m/%d')} 〜 #{Time.now.since(7.days).strftime('%Y/%m/%d')}]"
    tobanhyo.each do |hyo|
      puts "#{hyo.room.name}: #{hyo.role.name}"
    end
  end
end
