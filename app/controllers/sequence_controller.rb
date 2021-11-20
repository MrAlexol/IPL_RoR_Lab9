# frozen_string_literal: true

# Контроллер для последовательности
class SequenceController < ApplicationController
  def input; end

  def view
  begin
    @input = validate_input params[:values]
    subs_arr = find_increasing_subs.filter { |arr| arr.count > 1 }
    @subs = subs_arr.map { |subseq| subseq.join(' ') }
    @result = subs_arr.max_by(&:length).join(' ')
    @input = @input.join(' ')

  rescue StandardError => e
    @error = case e.class.to_s
             when 'ArgumentError' then 'Введены посторонние символы'
             when 'NoMethodError' then 'Последовательность не найдена'
             else e
             end
  ensure
    respond_to do |format|
      format.html
      format.json do
        render json: [{ name: :result, type: @result.class.to_s, value: @result }, 
                      { name: :subs, type: @subs.class.to_s, value: @subs },
                      { name: :error, type: @error.class.to_s, value: @error }]
      end
    end
  end
  end

  private

  def find_increasing_subs
    @input.each_with_object([[]]) do |el, acc|
      acc << [] if acc[-1].any? && el <= acc[-1][-1]
      acc[-1] << el
    end
  end

  def validate_input(input)
    raise 'Ошибочный GET-запрос' if input.nil?
    raise 'Вы ничего не ввели' if input.empty?

    result = input.split.map { |el| Integer el }
    raise 'Последовательность короче 10 чисел' if result.length < 10

    result
  end
end
