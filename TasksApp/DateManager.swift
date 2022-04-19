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
        
        let formatterDate = self.formatter.string(from: self.date as Date)
        
        self.formatter.dateFormat = "dd.MM.YYYY"
        self.formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return "\(formatterDate)"
    }
}
