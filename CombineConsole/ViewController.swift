//
//  ViewController.swift
//  CombineConsole
//
//  Created by Алексей Артамонов on 13.05.2023.
//

import UIKit
import Combine

final class ViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Class methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.isEditable = false
    }
}

