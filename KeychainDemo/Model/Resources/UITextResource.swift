//
//  UITextResource.swift
//  KeychainDemo
//
//  Created by Huei-Der Huang on 2025/4/1.
//

import Foundation

struct UITextResource {
    static let createTitle = "Create Account"
    static let deleteTitle = "Delete Account"
    static let updateTitle = "Update Account"
    static let okAlertTitle = "OK"
    static let yesAlertTitle = "YES"
    static let cancelAlertTitle = "cancel"
    static let accountPlaceholder = "Enter your account"
    static let passwordPlaceholder = "Enter your password"
    static let createAlert = "Please check your account or password!"
    static let deleteAlert = "Do you want to delete your account?"
    static let updateAlert = "Do you want to update account and password?"
    static let SuccessAlert = "Success!"
    
    static let bundleId = {
        return Bundle.main.bundleIdentifier ?? ""
    }
}
