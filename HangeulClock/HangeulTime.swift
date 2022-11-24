//
//  HangeulTime.swift
//  HangeulClock
//
//  Created by Hyejeong Park on 2022/11/25.
//

import Foundation

final class HangeulTime {
  
  static let shared = HangeulTime()
  
  private init() { }
  
  private var calendar = NSCalendar.current
  
  private var time: (hours: Int, minutes: Int, seconds: Int) {
    let now = Date()
    let components = calendar.dateComponents([.hour, .minute, .second], from: now)
    guard let h = components.hour, (0 ... 23).contains(h),
          let m = components.minute, (1 ... 59).contains(m),
          let s = components.second, (1 ... 59).contains(s) else { return (0, 0, 0) }
    return (h, m, s)
  }
  
  var sunOrMoon: String {
    return (7 ... 18).contains(time.hours) ? "☀️" : "🌙"
  }
  
  var amPm: String {
    return time.hours < 12 ? "오전" : "오후"
  }
  
  var hours: String {
    let numbersInKorean = ["열두", "한", "두", "세", "네", "다섯", "여섯", "일곱", "여덟", "아홉", "열", "열한"]
    return numbersInKorean[time.hours % 12] + "시"
  }
  
  var minutes: (tens: String, ones: String) {
    guard let (tens, ones) = getMinutesAndSecondsString(from: time.minutes) else { return ("", "") }
    return (tens, ones + "분")
  }
  
  var seconds: (tens: String, ones: String)? {
    guard let (tens, ones) = getMinutesAndSecondsString(from: time.seconds) else { return nil }
    return (tens, ones + "초")
  }
  
  private func getMinutesAndSecondsString(from number: Int) -> (tens: String, ones: String)? {
    guard number != 0 else { return nil }
    let numbersInKorean = ["영", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구", "십"]
    let tens = number >= 20 ? numbersInKorean[number / 10] : ""
    let ten = number >= 10 ? numbersInKorean[10] : ""
    let ones = number % 10 == 0 ? "" : numbersInKorean[number % 10]
    return (tens + ten, ones)
  }
  
}
