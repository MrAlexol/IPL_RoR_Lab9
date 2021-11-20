# frozen_string_literal: true

# Контроллер для последовательности
class SequenceController < ApplicationController
  def input; end

  def view
    @input = params[:values]&.split&.map { |el| Integer el }
    raise StandardError, 'Seq length is less than 10' if @input.length < 10

    @result = find_increasing_subseq&.map { |subseq| subseq.join(' ') }
  rescue ArgumentError
    @error = 'Некорректный ввод'
  rescue NoMethodError
    @error = 'Последовательность не найдена'
  rescue StandardError
    @error = 'Последовательность короче 10 чисел'
  end

  private

  def find_increasing_subseq
    @input.each_with_object([[]]) do |el, acc|
      acc << [] if el <=> acc[-1][-1] && el <= acc[-1][-1]
      acc[-1] << el
    end.filter { |arr| arr.count > 1 }.yield_self { |this| this.append(this.max_by(&:length)) }
  end
end
