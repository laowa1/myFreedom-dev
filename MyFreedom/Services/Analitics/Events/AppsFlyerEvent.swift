//
//  AppsFlyerEvent.swift
//  MyFreedom
//
//  Created by m1pro on 17.04.2022.
//

import Foundation

enum AppsFlyerEvent: String {
   case registration = "registration"
   
   public var params: [String: Any] {
        return ["user_id" : "USER_ID" as Any, "service_name": "lastChoosedServiceType"]
   }
}
