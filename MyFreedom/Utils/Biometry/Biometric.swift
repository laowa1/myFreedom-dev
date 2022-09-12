//
//  Biometric.swift
//  MyFreedom
//
//  Created by m1pro on 05.04.2022.
//

import LocalAuthentication

class Biometric {

    enum Result {
        case success
        case cancelled
        case failure(_ error: Error)
    }

    var biometricType: BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                return .none
            case .touchID:
                return .touch
            case .faceID:
                return .face
            @unknown default:
                return .unowned
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
        }
    }

    public func authenticate(onCompletion pass: @escaping (_ result: Result) -> Void) {
        let _ = LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)

        let biometryType: String
        switch self.biometricType {
        case .touch: biometryType = "Touch ID"
        case .face: biometryType = "Face ID"
        default: fatalError("Couldn't identify biometry type")
        }

        let localizedReason = "Logging in with " + biometryType

        LAContext().evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: localizedReason
        ) { success, evaluateError in
            if success {
                DispatchQueue.main.async {
                    pass(.success)
                }
                return
            }

            let errorMessage: String
            if let evaluateError = evaluateError {
                switch evaluateError {
                case LAError.authenticationFailed:
                    errorMessage = "There was a problem verifying your identity"
                case LAError.userCancel:
                    NSLog("User cancelled \"" + biometryType + "\" identification")
                    pass(.cancelled)
                    return
                case LAError.userFallback:
                    NSLog("User decided to use password instead of \"" + biometryType + "\"")
                    pass(.cancelled)
                    return
                default:
                    if #available(iOS 11.0, *) {
                        switch evaluateError {
                        case LAError.biometryNotAvailable:
                            errorMessage = biometryType + " is not available"
                        case LAError.biometryNotEnrolled:
                            errorMessage = biometryType + " is not set up"
                        case LAError.biometryLockout:
                            errorMessage = biometryType + " is locked"
                        default:
                            errorMessage = biometryType + " may not be configured"
                        }
                    } else {
                        errorMessage = biometryType + " may not be configured"
                    }
                }
            } else {
                errorMessage = "Problem occurred on authentication!"
            }
            DispatchQueue.main.async {
                let error = NSError(domain: errorMessage, code: -1, userInfo: nil)
                pass(.failure(error))
            }
        }
    }
}
