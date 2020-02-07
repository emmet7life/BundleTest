//
//  Date+Extension.swift
//  BundleTest
//
//  Created by jianli chen on 2019/6/6.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation

extension Date {
    // 7.9.0 - 格式化“最新章节更新时间”
    func formattedNewChapterTime() -> String {
        // 转成中国时区
        let dateFormat = "yyyy-MM-dd"
        guard let today = Date().formatterDate(dateFormat: dateFormat),
            let targetDay = self.formatterDate(dateFormat: dateFormat) else {
                return self.formatterString(dateFormat: dateFormat)
        }
        let dayTimeInterval: TimeInterval = 86400
        let yesterday = Date(timeInterval: -dayTimeInterval, since: today)
        let todayStr = today.formatterString(dateFormat: dateFormat)
        let targetDayStr = targetDay.formatterString(dateFormat: dateFormat)
        if todayStr == targetDayStr {
            return "今天"
        } else if yesterday.formatterString(dateFormat: dateFormat) == targetDayStr {
            return "昨天"
        } else {
            for offset in 2...6 {
                let offsetDay = Date(timeInterval: -TimeInterval(offset) * dayTimeInterval, since: today)
                if offsetDay.formatterString(dateFormat: dateFormat) == targetDayStr {
                    return "\(offset)天前"
                }
            }
            let weekDay = Date(timeInterval: -TimeInterval(7) * dayTimeInterval, since: today)
            if weekDay.formatterString(dateFormat: dateFormat) == targetDayStr {
                return "一周前"
            }
            return targetDayStr
        }
    }
}

// 根据时区来格式化时间 - Start By CJL
// 三个可用时区缩写： HKT / PHT / SGT，在东八区，也就是中国时间。
extension TimeZone {
    // 中国时区TimeZone
    static var chinaTimeZone: TimeZone? {
        for abbreviation in ["HKT", "PHT", "SGT"] {
            if let timeZone = TimeZone(abbreviation: abbreviation) {
                return timeZone
            }
        }
        return nil
    }
}

extension Date {
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func formatterString(timeZone: TimeZone? = TimeZone.chinaTimeZone,
                         dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = timeZone ?? TimeZone.chinaTimeZone ?? NSTimeZone.local
        let string = dateFormatter.string(from: self)
        return string
    }
    
    func formatterDate(timeZone: TimeZone? = TimeZone.chinaTimeZone,
                       dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = timeZone ?? TimeZone.chinaTimeZone ?? NSTimeZone.local
        let string = dateFormatter.string(from: self)
        if let date = dateFormatter.date(from: string) {
            return date
        }
        return nil
    }
}

extension String {
    func formatterDate(timeZone: TimeZone? = TimeZone.chinaTimeZone,
                       dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = timeZone ?? TimeZone.chinaTimeZone ?? NSTimeZone.local
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return nil
    }
}
// 根据时区来格式化时间 - End By CJL

extension Date {
    // date 大于self 返回正数
    func dayDifferenceBySecond(_ date: Date) -> Int64 {
        return Int64(ceil((date - self) / (24 * 60 * 60)))
    }
    
    func convertToString(_ formatStr: String) -> String {
        let format = DateFormatter()
        format.dateFormat = formatStr
        //        format.locale = Locale.current
        //        format.timeZone = NSTimeZone.local
        //        format.timeZone = NSTimeZone.default
        return format.string(from: self)
    }
    
    static func dateFromString(_ dateStr: String, formatStr: String) -> Date? {
        let format = DateFormatter()
        format.dateFormat = formatStr
        if let date = format.date(from: dateStr) {
            return date.convertToCurrentTimeZone()
        }
        return nil
    }
    
    // 转化成当前时区的时间
    func convertToCurrentTimeZone() -> Date {
        let timeZone = NSTimeZone.local
        let timeOffset = timeZone.secondsFromGMT(for: self)
        return self.addingTimeInterval(TimeInterval(timeOffset))
    }
}


// MARK:
func +(date: Date, timeInterval: Int) -> Date {
    return date + TimeInterval(timeInterval)
}

func -(date: Date, timeInterval: Int) -> Date {
    return date - TimeInterval(timeInterval)
}

func +=(date: inout Date, timeInterval: Int) {
    date = date + timeInterval
}

func -=(date: inout Date, timeInterval: Int) {
    date = date - timeInterval
}

func -(date: Date, otherDate: Date) -> TimeInterval {
    return date.timeIntervalSince(otherDate)
}
