//
//  TimeInterval+extensions.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 17.03.2022.
//

import Foundation

extension TimeInterval {

    var timerString: String {
        let totalSeconds = Int(self)
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60

        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
}
