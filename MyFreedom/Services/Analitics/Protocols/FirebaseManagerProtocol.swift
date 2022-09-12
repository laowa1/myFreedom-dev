//
//  FirebaseManagerProtocol.swift
//  MyFreedom
//
//  Created by m1pro on 17.04.2022.
//

import Foundation

protocol FirebaseManagerProtocol {
    func initialize()
    func logEvent(eventName: String, parameters: [String: Any])
    func logError(_ error: NSError)
}
