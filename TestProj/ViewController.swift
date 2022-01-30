//
//  ViewController.swift
//  TestProj
//
//  Created by Ivan Sabaleuski on 28.01.22.
//

import UIKit

class ViewController: UIViewController {
  
  private let presenter: Presenter
  
  required init?(coder: NSCoder) {
    let presenter = Presenter()
    self.presenter = presenter
    super.init(coder: coder)
    presenter.view = self
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    print("did load")
    presenter.doSmth()
  }

}

extension ViewController {
  
  @MainActor
  func doSmthOnMain() {
    dispatchPrecondition(condition: .onQueue(.main))
  }
  
}

final class Presenter {
  
  @MainActor weak var view: ViewController?
  
  func doSmth() {
    Task {
      await view?.doSmthOnMain()
    }
  }
  
}
