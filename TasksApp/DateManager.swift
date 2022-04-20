//
//  DateManager.swift
//  TasksApp
//
//  Created by Фаддей Гусаров on 19.04.2022.
//

import Foundation

class DateManager {
    
    static let shared = DateManager()
    
    private let date = NSDate()
    private let formatter = DateFormatter()
    
    private init(){}
    
    func getDate() -> String {
        
        let date = Date()

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd.MM.YYYY"

        return formatter.string(from: date)
    }
}
