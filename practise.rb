# frozen_string_literal: true

require 'date'

def put_periods
  puts 'Введите цепочку периодов по примеру: 2023M1D30 2023M1 2023M2 2023 2024M3 2024M4D30 2024M5'
  @periods = gets.to_s
  @periods.match?(/[MD0-9]/) ? @periods = @periods.split(' ') : put_periods
end

def put_start_date
  puts 'Введите дату по примеру: 30.01.2023'
  @start_date = gets.to_s
  @start_date.match?(/^[0-9]+.[0-9]+.[0-9]+/) ? @start_date = @start_date.split('.') : put_start_date
  if Date.valid_date?(@start_date[2].to_i, @start_date[1].to_i,
                      @start_date[0].to_i)
    @start_date = Date.new(@start_date[2].to_i, @start_date[1].to_i,
                           @start_date[0].to_i)
  else
    put_start_date
  end
end

def check(date)
  flag = true
  date_day = date.day
  @periods.each do |i|
    if i.scan(/\D/).empty? && date.year == i.to_i
      date = date.next_year
    elsif i.count('M') == 1 && i.count('D').zero? && date.month == i.partition('M').last.to_i
      date = if Date.valid_date?(date.year, date.month + 1,
                                 date_day)
               Date.new(date.year, date.month + 1, date_day)
             else
               date.next_month
             end
    elsif i.count('D').positive? && date.day == i.partition('D').last.to_i
      date = date.next_day
      date_day = date.day
    else
      flag = false
    end
  end
  [date, flag]
end

def add
  p 'Выберите, какой тип Вы хотите добавить к существующей цепочке: Annually, Monthly, Daily'
  c = gets
  checking = check(@start_date)[0]
  case c.strip
  when 'Annually'
    @periods.push(checking.year.to_s)
  when 'Monthly'
    @periods.push("#{checking.year}M#{checking.month}")
  when 'Daily'
    @periods.push("#{checking.year}M#{checking.month}D#{checking.day}")
  else
    p 'Вы неправильно ввели тип, попробуйте ещё раз'
    add
  end
end

put_periods
put_start_date
p 'Заданная цепочка периодов корректна?'
p check(@start_date)[1]
if check(@start_date)[1] 
  add
  p @periods
else
  p 'Так как заданная цепочка периодов некорректна, то добавление нового периода к концу цепочки невозможно'
end
