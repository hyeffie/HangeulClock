//
//  ViewController.swift
//  HangeulClock
//
//  Created by Hyejeong Park on 2022/11/24.
//

import UIKit

final class ViewController: UIViewController {
  
  private let hangeulTime = HangeulTime.shared
  
  @IBOutlet var amPmLabels: [UILabel]!
  
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
    symbolLabel.text = hangeulTime.sunOrMoon
    update(amPmLabels, with: hangeulTime.amPm)
    
    let hour = hangeulTime.hours
    update(hoursLabels, with: hour)
    configureState(of: firstOf6Label, for: hour.contains("섯"))
    configureState(of: firstOf8Label, for: hour.contains("덟"))
    
    let minute = hangeulTime.minutes
    update(tensOfMinutesLabels, with: minute.tens)
    update(onesOfMinutesLabels, with: minute.ones)
    
    let maybeSecondString = hangeulTime.seconds
    tensAndOnesStackView.isHidden = maybeSecondString == nil
    zeroSecondLabel.isHidden = !tensAndOnesStackView.isHidden
    guard let seconds = maybeSecondString else { return }
    tensOfSecondsLabel.text = seconds.tens
    onesOfSecondsLabel.text = seconds.ones
  }
  
  private func configureState(of label: UILabel, for isOn: Bool) {
    label.textColor = isOn ? .white : .gray
  }
  
  private func update(_ labels: [UILabel], with timeString: String) {
    labels.forEach { label in
      guard let text = label.text,
            let char = text.trimmingCharacters(in: .whitespaces).first else { return }
      configureState(of: label, for: timeString.contains(char))
    }
  }

}
