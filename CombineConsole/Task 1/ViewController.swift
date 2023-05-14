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
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Properties
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    private var message = CurrentValueSubject<String, Never>("Hello Combine")
    private let titleTextView: String = "---------- Combine test app swift ----------"
    
    // MARK: - Class methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.isEditable = false
        textView.refreshControl?.addTarget(self, action: #selector(updateText), for: .allEditingEvents)
        
        message.assign(to: \.text, on: textView)
            .store(in: &cancellable)
        
        customSubscriberAction(textView: textView)
        changeViewColor(view: backgroundView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            NotificationCenter.default.post(Notification(name: Notification.publisherNotification))
        }
    }
    
    // MARK: - Private methods
    
    private func createPublisher(notificationName: Notification.Name) -> NotificationCenter.Publisher {
        let publisher = NotificationCenter.default.publisher(for: notificationName)
        
        return publisher
    }
    
    private func changeViewColor(view: UIView) {
        let colors: [UIColor] = [.blue, .brown, .cyan, .green, .red, .magenta]
        
        Timer.publish(every: 1.0, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.backgroundView.backgroundColor = colors.randomElement()
            }
            .store(in: &cancellable)
    }
    
    private func customSubscriberAction(textView: UITextView) {
        let names = ["James", "Maksim", "Anna", "Maria", "Sveta"]
            .compactMap { $0 }
            .publisher
        let customSubscriber = CustomSubscriber(textView: self.textView)
        
        names.subscribe(customSubscriber)
    }
    
    @objc private func updateText() {
        guard let text = textView.text else {
            return
        }
        
        message.value = text
    }
}

extension Notification {
    static var publisherNotification: Notification.Name {
        Notification.Name("publisherNotification")
    }
}
