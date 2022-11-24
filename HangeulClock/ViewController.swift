//
//  ViewController.swift
//  HangeulClock
//
//  Created by Hyejeong Park on 2022/11/24.
//

import UIKit

final class ViewController: UIViewController {
  
  private let timeManager = TimeManager()
  
  @IBOutlet var noonLables: [UILabel]!
  
  @IBOutlet var hoursLabels: [UILabel]!
  
  @IBOutlet weak var firstOf6Label: UILabel!
  
  @IBOutlet weak var firstOf8Label: UILabel!
  
  @IBOutlet weak var symbolLabel: UILabel!
  
  @IBOutlet var tensOfMinutesLabels: [UILabel]!
  
  @IBOutlet var onesOfMinutesLabels: [UILabel]!
  
  @IBOutlet weak var zeroSecondLabel: UILabel!
  
  @IBOutlet weak var tensAndOnesStackView: UIStackView!
  
  @IBOutlet weak var tensOfSecondsLabel: UILabel!
  
  @IBOutlet weak var onesOfSecondsLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
      guard let self else { return }
      self.updateTimeLabels()
    }
  }
  
  private func updateTimeLabels() {
    updateSymbol()
    updateNoonLabels()
    updateHourLabels()
    updateMinuteLabels()
    updateSecondsLabel()
  }
  
  private func configureState(of label: UILabel, for isOn: Bool) {
    label.textColor = isOn ? .white : .gray
  }
  
  private func updateSymbol() {
    guard let sunOrMoon = timeManager.getSunOrMoon() else { return }
    symbolLabel.text = sunOrMoon ? "☀️" : "🌙"
  }
  
  private func updateNoonLabels() {
    guard let noon = timeManager.getNoonString() else { return }
    update(noonLables, with: noon)
  }
  
  private func updateHourLabels() {
    guard let hour = timeManager.getHoursString() else { return }
    update(hoursLabels, with: hour)
    configureState(of: firstOf6Label, for: hour.contains("섯"))
    configureState(of: firstOf8Label, for: hour.contains("덟"))
  }
  
  
  private func updateMinuteLabels() {
    guard let minute = timeManager.getMinutesAndSecondsString(isMinute: true) else { return }
    update(tensOfMinutesLabels, with: minute.tens)
    update(onesOfMinutesLabels, with: minute.ones)
  }
  
  private func update(_ labels: [UILabel], with timeString: String) {
    labels.forEach { label in
      guard let text = label.text,
            let char = text.trimmingCharacters(in: .whitespaces).first else { return }
      configureState(of: label, for: timeString.contains(char))
    }
  }
  
  private func updateSecondsLabel() {
    let maybeSecondString = timeManager.getMinutesAndSecondsString(isMinute: false)
    tensAndOnesStackView.isHidden = maybeSecondString == nil
    zeroSecondLabel.isHidden = !tensAndOnesStackView.isHidden
    #warning("처음 화면 고려하기")
    guard let seconds = maybeSecondString else { return }
    tensOfSecondsLabel.text = seconds.tens
    #warning("이십초 일 때는 초가 가운데에?!")
    onesOfSecondsLabel.text = seconds.ones
  }

}

final class TimeManager {
  
  var calendar = NSCalendar.current
  
  private func getTimeComps() -> (hours: Int, minutes: Int, seconds: Int) {
    let now = Date()
    let components = calendar.dateComponents([.hour, .minute, .second], from: now)
    guard let h = components.hour,
          let m = components.minute,
          let s = components.second else { return (0, 0, 0) }
    return (h, m, s)
  }
  
  func getSunOrMoon() -> Bool? {
    let hours = getTimeComps().hours
    guard (0 ... 23).contains(hours) else { return nil }
    return (7 ... 18).contains(hours)
  }
  
  func getNoonString() -> String? {
    let hours = getTimeComps().hours
    guard (0 ... 23).contains(hours) else { return nil }
    return hours < 12 ? "오전" : "오후"
  }
  
  func getHoursString() -> String? {
    let hours = getTimeComps().hours
    guard (0 ... 23).contains(hours) else { return nil }
    let numbersInKorean = ["열두", "한", "두", "세", "네", "다섯", "여섯", "일곱", "여덟", "아홉", "열", "열한"]
    return numbersInKorean[hours % 12] + "시"
  }
  
  func getMinutesAndSecondsString(isMinute: Bool) -> (tens: String, ones: String)? {
    let number = isMinute ? getTimeComps().minutes : getTimeComps().seconds
    guard (1 ... 59).contains(number) else { return nil }
    let numbersInKorean = ["영", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구", "십"]
    let tens = number >= 20 ? numbersInKorean[number / 10] : ""
    let ten = number >= 10 ? numbersInKorean[10] : ""
    let ones = number % 10 == 0 ? "" : numbersInKorean[number % 10]
    return (tens + ten, ones + (isMinute ? "분" : "초"))
  }
}
