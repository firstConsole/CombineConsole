//
//  FourthViewController.swift
//  CombineConsole
//
//  Created by Алексей Артамонов on 25.05.2023.

import UIKit
import Combine

final class FourthViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var lattitudeLabel: UILabel!
    @IBOutlet weak var longtitudeLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var localTimeLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    // MARK: - Properties
    
    private var cancellable = Set<AnyCancellable>()
    private var weatherData: [WeatherModel] = []
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        getRequest(with: URL(string: "https://api.weatherapi.com/v1/current.json?key=06b4c688cd3647e18b9153239232805&q=Moscow"))

    }
    
    // MARK: - Class's methods
    
    private func getRequest(with url: URL?) {
        guard let url = url else {
            print("Broken URL \(String(describing: url?.description))")
            fatalError("Can't create URL")
        }
        
        let publisher = URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherModel.self, decoder: JSONDecoder())
        
        publisher
            .sink { [weak self] completion in
                guard let self = self else {
                    return
                }
                
                if case .failure(let error) = completion {
                    print(error)
                }
                print(completion)
                print(self.weatherData)
                DispatchQueue.main.async {
                    self.configureUI(with: self.weatherData)
                }
            } receiveValue: { [weak self] data in
                guard let self = self else {
                    return
                }
                
                self.weatherData.append(data)
            }
            .store(in: &cancellable)
    }
    
    private func configureUI(with data: [WeatherModel]) {
        self.cityLabel.text = "Город: \(data[0].location.name)"
        self.regionLabel.text = "Регион: \(data[0].location.region)"
        self.countryLabel.text = "Страна: \(data[0].location.country)"
        self.lattitudeLabel.text = "Долгота: \(data[0].location.latitude)"
        self.longtitudeLabel.text = "Широта: \(data[0].location.longitude)"
        self.timeZoneLabel.text = "Time Zone: \(data[0].location.timeZone)"
        self.localTimeLabel.text = "Дата и время: \(data[0].location.localTime)"
        self.lastUpdateLabel.text = "Последнее обновление: \(data[0].current.lastUpdatedTime)"
        self.tempLabel.text = "Температура (С): \(data[0].current.celsiusTemp)"
        self.windSpeedLabel.text = "Скорость ветра (км/ч): \(data[0].current.windSpeed)"
        
        if data[0].current.isDay == 1 {
            self.view.backgroundColor = #colorLiteral(red: 0.9497745633, green: 1, blue: 0.6887305379, alpha: 1)
        } else {
            self.view.backgroundColor = #colorLiteral(red: 0.6566378474, green: 0.6553579569, blue: 1, alpha: 1)
        }
        
        getImage(from: URL(string: data[0].current.condition.icon))
        
    }
    
    private func getImage(from url: URL?) {
        guard let url = url else {
            return
        }
        
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] data in
                guard let self = self else {
                    return
                }
                self.iconImage.image = UIImage(data: data)
                    
                print(data)
            }
            .store(in: &cancellable)

    }
}
