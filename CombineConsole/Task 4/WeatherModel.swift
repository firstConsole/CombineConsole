//
//  WeatherModel.swift
//  CombineConsole
//
//  Created by Алексей Артамонов on 31.05.2023.
//

import Foundation

struct WeatherModel: Codable {
    let location: Location
    let current: Current
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let latitude: Double
    let longitude: Double
    let timeZone: String
    let localTime: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case region
        case country
        case latitude = "lat"
        case longitude = "lon"
        case timeZone = "tz_id"
        case localTime = "localtime"
    }
}
struct Current: Codable {
    let lastUpdatedTime: String
    let celsiusTemp: Double
    let isDay: Int
    let condition: Condition
    let windSpeed: Double
    
    enum CodingKeys: String, CodingKey {
        case lastUpdatedTime = "last_updated"
        case celsiusTemp = "temp_c"
        case isDay = "is_day"
        case condition
        case windSpeed = "wind_kph"
    }
}

struct Condition: Codable {
    let text: String
    let icon: String
    let code: Int
}
