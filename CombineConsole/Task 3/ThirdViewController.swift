//
//  ThirdViewController.swift
//  CombineConsole
//
//  Created by Алексей Артамонов on 20.05.2023.
//

import UIKit
import Combine

final class ThirdViewController: UIViewController {
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stringArray = prependPublisher()
        
        stringToUnicodeScalar(stringArrayPublisher: stringArray)
        
    }
    
    private func prependPublisher() -> Publishers.Sequence<[String], Never> {
        let subject = PassthroughSubject<String, Never>()
        let stringArrayPublisher = ["Hello", "world", "!"].publisher
        
        print("---------- Function prependPublisher completed ----------")
        
        stringArrayPublisher
            .prepend(subject)
            .compactMap { $0 }
            .collect(.byTime(RunLoop.main, .milliseconds(500)))
            .map { stringArrayPublisher.append($0) }
            .sink(receiveValue: { print($0) })
            .store(in: &cancellable)
        
        subject.send("Swift")
        subject.send("loves")
        subject.send("you")
        subject.send("!")
        subject.send(completion: .finished)
        
        print(stringArrayPublisher)
        return stringArrayPublisher
    }
    
    private func stringToUnicodeScalar(stringArrayPublisher: Publishers.Sequence<[String], Never>) {
        print("---------- Function stringToUnicodeScalar completed ----------")
        
        stringArrayPublisher
            .map { string in
                string.unicodeScalars.first
            }
            .compactMap { $0 }
            .map({ unicodeValue in
                Character(unicodeValue)
            })
            .sink(receiveValue: { print($0) })
            .store(in: &cancellable)
    }
}

