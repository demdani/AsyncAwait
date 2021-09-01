//
//  ViewController.swift
//  AsnycAwait
//
//  Created by Demjen Daniel on 2021. 08. 29..
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var calculateButton: UIButton!
    
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculateButton.configurationUpdateHandler = { [weak self] button in
            guard let self = self else { return }
            
            var config = button.configuration
            config?.showsActivityIndicator = self.isLoading
            config?.title = self.isLoading ? "" : "Calculate"
            button.configuration = config
        }
    }
    
    @IBAction func ditTapButton(_ sender: Any) {
        numberLabel.text = "Calculating..."
        isLoading = true
        calculateButton.setNeedsUpdateConfiguration()
        calculate()
    }
    
    @MainActor func updateUI(number: Int) {
        numberLabel.text = "\(number)"
        isLoading = false
        calculateButton.setNeedsUpdateConfiguration()
    }
    
    func calculate() {
        Task {
            let x = await calculateFirstNumber()
            let y = await calculateSecondNumber()
            updateUI(number: x + y)
        }
    }
    
    func calculateFirstNumber() async -> Int {
        return await withUnsafeContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                continuation.resume(returning: .random(in: 1 ... 100))
            }
        }
    }
    
    func calculateSecondNumber() async -> Int {
        return await withUnsafeContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                continuation.resume(returning: .random(in: 100 ... 200))
            }
        }
    }
}

