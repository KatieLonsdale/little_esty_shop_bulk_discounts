class BulkDiscountFacade
  def initialize
  end

  def next_3_holidays
    service = HolidayService.new
    json = service.holidays

    holidays = []
    json.each_with_index do |info, i|
      break if i > 2
      holidays << Holiday.new(info)
    end
    holidays
  end
end