//
//  NetworkError.swift
//  Networking
//
//  Created by Anzori Kizikelashvili on 23.12.25.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingFailed
    case noData
}
