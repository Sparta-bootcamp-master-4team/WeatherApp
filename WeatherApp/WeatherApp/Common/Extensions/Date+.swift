//
//  Date+.swift
//  WeatherApp
//
//  Created by 양원식 on 5/21/25.
//

import Foundation

// MARK: - Date 확장
extension Date {
    
    /// 주어진 Unix 타임스탬프(TimeInterval)를 "MM월 dd일" 형식의 문자열로 변환합니다.
    ///
    /// - Parameter timestamp: 1970년 1월 1일 기준 초 단위 타임스탬프
    /// - Returns: "05월 24일"과 같은 날짜 문자열
    ///
    /// ## 사용 예시:
    /// ```
    /// let text = Date.formattedMonthDay(from: 1684926000)
    /// // 출력: "05월 24일"
    /// ```
    static func formattedMonthDay(from timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        return DateFormatter.monthDay.string(from: date)
    }
    
    /// 주어진 Unix 타임스탬프(TimeInterval)를 요일 문자열로 변환합니다.
    /// 오늘 날짜라면 "오늘"을 반환합니다.
    ///
    /// - Parameter timestamp: 1970년 1월 1일 기준 초 단위 타임스탬프
    /// - Returns: "오늘" 또는 "월", "화", "수" 등 한글 요일 문자열
    ///
    /// ## 사용 예시:
    /// ```
    /// let label = Date.weekdayOrToday(from: 1684926000)
    /// // 출력: "오늘" 또는 "수"
    /// ```
    static func weekdayOrToday(from timestamp: TimeInterval) -> String {
        let inputDate = Date(timeIntervalSince1970: timestamp)
        let calendar = Calendar.current
        
        if calendar.isDateInToday(inputDate) {
            return "오늘"
        } else {
            return DateFormatter.weekday.string(from: inputDate)
        }
    }
    
    /// 주어진 Unix 타임스탬프(TimeInterval)를 기준으로 현재 시각대면 "지금"을 반환하고,
    /// 그렇지 않으면 "오전/오후 h시" 형식의 문자열을 반환합니다.
    ///
    /// - Parameter timestamp: 1970년 1월 1일 기준 초 단위 타임스탬프
    /// - Returns: "지금" 또는 "오전 1시", "오후 3시" 등의 문자열
    ///
    /// ## 사용 예시:
    /// ```
    /// let timeLabel = Date.ampmHourOrNow(from: 1684926000)
    /// // 출력: "지금" 또는 "오후 1시"
    /// ```
    static func ampmHourOrNow(from timestamp: TimeInterval) -> String {
        let inputDate = Date(timeIntervalSince1970: timestamp)
        let now = Date()
        let calendar = Calendar.current
        
        guard let nextHour = calendar.date(byAdding: .hour, value: 1, to: inputDate) else {
            return DateFormatter.ampmHour.string(from: inputDate)
        }
        
        if inputDate <= now && now < nextHour {
            return "지금"
        } else {
            return DateFormatter.ampmHour.string(from: inputDate)
        }
    }
}

