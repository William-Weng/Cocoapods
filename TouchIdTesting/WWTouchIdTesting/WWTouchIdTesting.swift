//
//  WWTouchIdTesting.swift
//  WWTouchIdTesting
//
//  Created by William-Weng on 2019/2/15.
//  Copyright © 2019年 William-Weng. All rights reserved.
//

import UIKit

import UIKit
import LocalAuthentication

/// MARK: - 功能
open class WWTouchIdTesting {

    /// 物理檢測的類型
    public enum BiometryType : Int {
        case none
        case touchID
        case faceID
        
        /// 輸入字串
        public func toString() -> String {
            switch self {
            case .none: return "None"
            case .touchID: return "Touch ID"
            case .faceID: return "Face ID"
            }
        }
    }
    
    /// 結果類型
    public enum Result<T> {
        case success(T)
        case failure(T)
    }
    
    /// 使用ID辨識功能
    static public func run(reason: String, result: @escaping (Result<Any?>) -> (Void)) -> BiometryType {
        
        let policyResult = canEvaluatePolicy()
        var myBiometryType = BiometryType.none
        
        switch policyResult {
        case .failure(let error):
            result(.failure(error)); break
        case .success(let biometryType):
            myBiometryType = (biometryType as? BiometryType) ?? BiometryType.none
        }
        
        let myContext = LAContext()
        
        myContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (isOK, error) in
            if isOK {
                result(.success(isOK))
            } else {
                result(.failure(error))
            }
        }
        
        return myBiometryType
    }
}

// MARK: - 小工具
extension WWTouchIdTesting {
    
    /// 有開啟ID辨識功能
    static private func canEvaluatePolicy() -> Result<Any?> {
        
        guard canUseTouchID() else { return .success(BiometryType.none) }
        
        let myContext = LAContext()
        var authError: NSError?
        
        if myContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            
            var myBiometryType = BiometryType.none
            
            if #available(iOS 11.0, *) {
                let biometryType = myContext.biometryType
                if let type = BiometryType(rawValue: biometryType.rawValue) { myBiometryType = type }
            } else {
                myBiometryType = BiometryType.touchID
            }
            
            return .success(myBiometryType)
        }
        
        return .failure(authError)
    }
    
    /// 檢測是使用哪一種ID辨識功能
    static private func detectBiometryType(with context: LAContext) -> BiometryType {
        
        guard canUseTouchID() else { return .none }
        
        if #available(iOS 11.0, *) {
            let _biometryType = context.biometryType
            guard let biometryType = BiometryType(rawValue: _biometryType.rawValue) else { return .none }
            return biometryType
        }
        
        return .touchID
    }
    
    /// 開始iPhone有TouchID的版本
    static private func canUseTouchID() -> Bool {
        if #available(iOS 8.0, *) { return true }
        return false
    }
}
