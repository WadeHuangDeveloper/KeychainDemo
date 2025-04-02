//
//  AppResource.swift
//  KeychainDemo
//
//  Created by Huei-Der Huang on 2025/4/1.
//

import Foundation

struct AppResource {
    static var bundleId: String {
        return Bundle.main.bundleIdentifier ?? ""
    }
}
