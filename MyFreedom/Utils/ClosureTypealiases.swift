//
//  ClosureTypealiases.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 04.04.2022.
//

import Foundation

typealias Action = () -> Void

typealias SearchAction = (Action?) -> Void

typealias IndexAction = (Int) -> Void

typealias IntArrayAction = ([Int]) -> Void

typealias BoolAction = (Bool) -> Void

typealias BoolStringAction = (Bool, String?) -> Void

typealias BoolStringStringAction = (Bool, String?, String?) -> Void

typealias InsertTextBlock = (String) -> Void

typealias InsertText2Block = (String, String) -> Void

typealias InsertText3Block = (String, String, String) -> Void

typealias SelectedURLBlock = (URL) -> Void

typealias SearchNavigationViewCallback = (_ string: String) -> Void


// API
typealias Failure = (Error?) -> Void
