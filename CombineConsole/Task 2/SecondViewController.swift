//
//  SecondViewController.swift
//  CombineConsole
//
//  Created by Алексей Артамонов on 14.05.2023.
//

import UIKit
import Combine

final class SecondViewController: UIViewController {
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    private let numSequence = (0...100)
    private let stringSequence: [String] = ["1", "15", "9", "45", "33", "28"]
    private var intArray: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeTaskOne(sequence: numSequence)
        
        intArray = transformFromString(sequence: stringSequence)
        arithmeticMean(intArray: intArray)
    }
    
    private func makeTaskOne(sequence: (ClosedRange<Int>)) {
        print("Task 1 \n")
        
        sequence.publisher
            .dropFirst(50)
            .prefix(20)
            .filter { $0 % 2 == 0 }
            .collect()
            .sink(receiveValue: { print("\($0) \n") })
            .store(in: &cancellable)
    }
    
    private func transformFromString(sequence: [String]) -> [Int] {
        print("Task 2 \n")
        var intArray: [Int] = []
        
        sequence.publisher
            .compactMap { Int($0) }
            .collect()
            .sink(receiveValue: { intArray = $0 })
            .store(in: &cancellable)
        
        print("Transformed array: \(intArray)")
        print("Elements in array: \(intArray.count)")
        
        return intArray
    }
    
    private func arithmeticMean(intArray: [Int]) {
        intArray.publisher
            .reduce(0) { $0 + $1 / intArray.count }
            .sink(receiveValue: { print("Arithmetic Mean = \($0)") })
            .store(in: &cancellable)
    }
}
