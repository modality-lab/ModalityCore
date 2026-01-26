import Foundation

extension Calendar.Component {
  
  public func labelForDate(_ date: Date, in calendar: Calendar = .current, today: Date = .now) -> String {
    
    switch self {
    case .day:
      if calendar.isDateInToday(date) {
        return "Today"
      } else if calendar.isDateInYesterday(date) {
        return "Yesterday"
      } else {
        return date.formatted(.dateTime.weekday(.abbreviated))
      }
    case .weekOfYear:
      let thisWeek = calendar.component(.weekOfYear, from: today)
      let dateWeek = calendar.component(.weekOfYear, from: date)
      let thisYear = calendar.component(.year, from: today)
      let dateYear = calendar.component(.year, from: date)
      
      if thisYear == dateYear && thisWeek == dateWeek {
        return "This week"
      } else if thisYear == dateYear && thisWeek - 1 == dateWeek {
        return "Last week"
      } else {
        return "Week \(dateWeek)"
      }
    case .month:
      return date.formatted(.dateTime.month(.narrow))
    default:
      return date.formatted(.dateTime.month(.abbreviated).day())
    }
  }
}

extension Calendar {
  public func date(offsetedBy dayOffset: Int, to endDate: Date) -> Date {
    let day = date(byAdding: .day, value: dayOffset, to: endDate)!
    return startOfDay(for: day)
  }
}
