# frozen_string_literal: true

# Контроллер для последовательности
class SequenceController < ApplicationController
  def input; end

  def view
    raise 'Ошибочный GET-запрос' if params[:values].nil?
    raise 'Вы ничего не ввели' if params[:values].empty?

    @input = params[:values].split.map { |el| Integer el }
    raise 'Последовательность короче 10 чисел' if @input.length < 10

    @result = @subs = find_increasing_subs.filter { |arr| arr.count > 1 }
    @result = @result.max_by(&:length).join(' ')
    @subs.map! { |subseq| subseq.join(' ') }
    @input = @input.join(' ')
  rescue StandardError => e
    @error = case e.class.to_s
             when 'ArgumentError' then 'Введены посторонние символы'
             when 'NoMethodError' then 'Последовательность не найдена'
             else e
             end
  end

  private

  def find_increasing_subs
    @input.each_with_object([[]]) do |el, acc|
      acc << [] if acc[-1].any? && el <= acc[-1][-1]
      acc[-1] << el
    end
  end
end
