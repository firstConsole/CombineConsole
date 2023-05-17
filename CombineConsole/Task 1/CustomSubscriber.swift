//
//  CustomSubscriber.swift
//  CombineConsole
//
//  Created by Алексей Артамонов on 13.05.2023.
//

import UIKit
import Combine

class CustomSubscriber: Subscriber {
    typealias Failure = Never
    typealias Input = String
    
    let textView: UITextView
    
    init(textView: UITextView) {
        self.textView = textView
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print("Received value \(input)")
        textView.text = input
        return .unlimited
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Received completion \(completion)")
    }
}
