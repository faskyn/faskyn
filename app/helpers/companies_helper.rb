module CompaniesHelper

  def revenue_text( revenue_type, revenue)
    if revenue_type == "no revenue"
      "No revenue yet"
    elsif revenue_type == "recurring revenue"
      "Recurring: #{revenue} ARR"
    elsif revenue_type == "non-recurring revenue"
      "Non-Recurring: #{revenue} AR"
    end
  end
end