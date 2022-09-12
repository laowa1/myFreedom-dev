//
//  Event.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 15.04.2022.
//

import Foundation

enum AuthorizationEvent: String {
    case auth_register_START
    case auth_register_PHONE
    case auth_register_IIN
    case auth_register_FACE
    case auth_register_FACE_SCAN_BEGIN
    case auth_register_FACE_SCAN_SUCCESS
    case auth_register_FACE_SCAN_SEND
    case auth_register_FACE_SCAN_RESULT
    case auth_register_FACE_DECLINED
    case auth_register_SUCCESS

    case auth_register_FORM
    case auth_register_QUICK_PIN
    case auth_register_TOUCH_ID
    case auth_error
    
    enum ParameterKey: String {
        case screenName = "name"
    }
}

enum AuthorizationCommand: String {
    
    case initialization = "init"
    case login          = "show_login_form"
    case pin            = "show_pin_form"
    case pinFirst       = "show_pin_first_form"
    case email          = "show_email_form"
    case sms            = "show_sms_form"
    case info           = "show_info_form"
    case confirm        = "show_confirm_form"
    case facerecognition = "show_face_recognition_form"
    case submit
    case saveState      = "save_state"
    case showChangePhone = "show_change_phone_form"
    
    case enterOtp = "enter_otp"
    case completed
}
