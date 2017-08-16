//
//  Date+converToString.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/15/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation

extension Date {
    func convertToString() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
    }
}

extension NSDate {
    func convertToString() -> String {
        return DateFormatter.localizedString(from: (self as Date), dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
    }
}
