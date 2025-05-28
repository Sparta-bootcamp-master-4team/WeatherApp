//
//  DateFormatter+.swift
//  WeatherApp
//
//  Created by 양원식 on 5/21/25.
//
import Foundation

// MARK: - DateFormatter 확장 (날짜, 요일, 시간 포맷)
extension DateFormatter {
    
    /// 한국 시간 기준 "MM월 dd일" 형식 반환 포맷터
    /// 예: 05월 24일
    static var monthDay: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }
    
    /// 한국 시간 기준 요일 문자열 반환 포맷터
    /// 예: 월, 화, 수, 목, 금, 토, 일
    static var weekday: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }
    
    /// 예: 오전 1시, 오후 3시
    static var ampmHour: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h시" // "a" → 오전/오후, "h" → 12시간제
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }
}

