//
//  ViewController.swift
//  TestProj
//
//  Created by Ivan Sabaleuski on 28.01.22.
//

import UIKit

protocol ViewInternal: AnyObject {
  @MainActor func doSmthOnMain()
}

class ViewController: UIViewController {
  
  private let presenter: PresenterProtocol
  private let workQueue = DispatchQueue(label: "111")
  
  required init?(coder: NSCoder) {
    let presenter = Presenter()
    self.presenter = presenter
    super.init(coder: coder)
    presenter.view = self
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    print("did load")
    workQueue.asyncAfter(deadline: .now() + 3) {
      print("do smth")
      self.presenter.doSmth()
    }
  }

}

extension ViewController: ViewInternal {
  
  @MainActor
  func doSmthOnMain() {
    dispatchPrecondition(condition: .onQueue(.main))
  }
  
}

protocol PresenterProtocol: AnyObject {
  func doSmth()
}

final class Presenter: PresenterProtocol {
  
  @MainActor weak var view: ViewInternal?
  
  func doSmth() {
    Task {
      await view?.doSmthOnMain()
    }
  }
  
}
