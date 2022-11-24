//
//  ViewController.swift
//  HangeulClock
//
//  Created by Hyejeong Park on 2022/11/24.
//

import UIKit

final class ViewController: UIViewController {
  
  private let timeManager = TimeManager(locale: .current)
 
  override func viewDidLoad() {
    super.viewDidLoad()
    doEverySeconds { [weak self] in
      guard let self else { return }
      let comps = self.timeManager.getTimeComps()
      self.printTime(from: comps)
    }
  }
  
  private func printTime(from components: (h: Int, m: Int, s: Int)) {
    let str = "\(components.h):\(components.m):\(components.s)"
    print(str)
  }
  
  private func doEverySeconds(_ theThing: @escaping () -> ()) {
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
      theThing()
    }
  }

}

final class TimeManager {
  
  var calendar = NSCalendar.current
  
  init(locale: Locale) {
    calendar.locale = .current
  }
  
  func getTimeComps() -> (Int, Int, Int) {
    let now = Date()
    let components = calendar.dateComponents([.hour, .minute, .second], from: now)
    guard let h = components.hour,
          let m = components.minute,
          let s = components.second else { return (0, 0, 0) }
    return (h, m, s)
  }
  
}
