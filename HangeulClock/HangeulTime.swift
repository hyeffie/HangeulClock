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
          let m = components.minute, (0 ... 59).contains(m),
          let s = components.second, (0 ... 59).contains(s) else { return (0, 0, 0) }
    return (h, m, s)
  }
  
  var sunOrMoon: String {
    return (7 ... 18).contains(time.hours) ? "βοΈ" : "π"
  }
  
  var amPm: String {
    return time.hours < 12 ? "μ€μ " : "μ€ν"
  }
  
  var hours: String {
    let numbersInKorean = ["μ΄λ", "ν", "λ", "μΈ", "λ€", "λ€μ―", "μ¬μ―", "μΌκ³±", "μ¬λ", "μν", "μ΄", "μ΄ν"]
    return numbersInKorean[time.hours % 12] + "μ"
  }
  
  var minutes: (tens: String, ones: String) {
    guard let (tens, ones) = getMinutesAndSecondsString(from: time.minutes) else { return ("", "") }
    return (tens, ones + "λΆ")
  }
  
  var seconds: (tens: String, ones: String)? {
    guard let (tens, ones) = getMinutesAndSecondsString(from: time.seconds) else { return nil }
    return (tens, ones + "μ΄")
  }
  
  private func getMinutesAndSecondsString(from number: Int) -> (tens: String, ones: String)? {
    guard number != 0 else { return nil }
    let numbersInKorean = ["μ", "μΌ", "μ΄", "μΌ", "μ¬", "μ€", "μ‘", "μΉ ", "ν", "κ΅¬", "μ­"]
    let tens = number >= 20 ? numbersInKorean[number / 10] : ""
    let ten = number >= 10 ? numbersInKorean[10] : ""
    let ones = number % 10 == 0 ? "" : numbersInKorean[number % 10]
    return (tens + ten, ones)
  }
  
}
