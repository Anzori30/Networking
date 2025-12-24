//
//  HTTPMethod.swift
//  Networking
//
//  Created by Anzori Kizikelashvili on 24.12.25.
//

import Foundation

public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
