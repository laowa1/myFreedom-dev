//
//  Date+extensions.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import Foundation

extension Date {
    
    func toString(format: String) -> String {
        let df = DateFormatter()
        df.dateFormat = format
        let strDate = df.string(from: self)
        return strDate
    }

    enum Format {
        public enum Time { case full, fullMilliseconds, fullTimeZone, fullMillisecondsTimeZone, display }

        case ddMMyyyy(separator: String, time: Time? = nil)
        case yyyyMMdd(separator: String, time: Time? = nil)
        case ddMMMMyyyy(separator: String, time: Time? = nil)
        case MMMMyyyy(separator: String, time: Time? = nil)
        case MMddyyyy(separator: String, time: Time? = nil)
        case dMMMM(separator: String, time: Time? = nil)
        case dMMMMyyyy(separator: String, time: Time? = nil)
        case MMyy(separator: String, time: Time? = nil)

        var string: String {
            var string: String
            switch self {
            case .ddMMyyyy(let seperator, let time):
                string = ["dd", "MM", "yyyy"].joined(separator: seperator)
                time.map { string += getString(for: $0) }
            case .yyyyMMdd(let separator, let time):
                string = ["yyyy", "MM", "dd"].joined(separator: separator)
                time.map { string += getString(for: $0) }
            case .ddMMMMyyyy(let separator, let time):
                string = ["dd", "MMMM", "yyyy"].joined(separator: separator)
                time.map { string += getString(for: $0) }
            case .MMMMyyyy(let separator, let time):
                string = ["MMMM", "yyyy"].joined(separator: separator)
                time.map { string += getString(for: $0) }
            case .MMddyyyy(let separator, let time):
                string = ["MM", "dd", "yyyy"].joined(separator: separator)
                time.map { string += getString(for: $0) }
            case .dMMMM(let separator, let time):
                string = ["d", "MMMM"].joined(separator: separator)
                time.map { string += getString(for: $0) }
            case .dMMMMyyyy(let separator, let time):
                string = ["d", "MMMM", "yyyy"].joined(separator: separator)
                time.map { string += getString(for: $0) }
            case .MMyy(let separator, let time):
                    string = ["MM", "yy"].joined(separator: separator)
                    time.map { string += getString(for: $0) }
            }

                return string
            }

            private func getString(for time: Format.Time) -> String {
                switch time {
                case .full: return "'T'HH:mm:ss"
                case .fullMilliseconds: return getString(for: .full) + ".SSS"
                case .fullTimeZone: return getString(for: .full) + "Z"
                case .fullMillisecondsTimeZone: return getString(for: .fullMilliseconds) + "Z"
                case .display: return " HH:mm"
                }
            }
        }

    func string(withFormat dateFormat: Date.Format, locale: Locale = .current) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat.string
            dateFormatter.locale = locale
            return dateFormatter.string(from: self)
        }

        func isEqual(to date: Date) -> Bool {
            return Calendar.current.startOfDay(for: self) == Calendar.current.startOfDay(for: date)
        }
}
