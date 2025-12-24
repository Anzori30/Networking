//
//  File.swift
//  Networking
//
//  Created by Anzori Kizikelashvili on 24.12.25.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingFailed
    case noData
}

public enum APIServiceError: Error {
    case backend(statusCode: Int, data: Data)
}
struct APIErrorResponse: Codable, Error {
    let error: APIError
    let timestamp: String
}

struct APIError: Codable {
    let code: String
    let message: String
}
