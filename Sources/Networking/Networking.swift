import Foundation

@available(iOS 15.0, macOS 12.0, *)
public actor NetworkClient {

    public static let shared = NetworkClient()
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func request<T: Decodable>(
        urlString: String,
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        body: Data? = nil
    ) async throws -> T {

        let (data, _) = try await performRequest(
            urlString: urlString,
            method: method,
            headers: headers,
            body: body
        )

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }

    public func send(
        urlString: String,
        method: HTTPMethod,
        headers: [String: String] = [:],
        body: Data? = nil
    ) async throws {

        _ = try await performRequest(
            urlString: urlString,
            method: method,
            headers: headers,
            body: body
        )
    }

    private func performRequest(
        urlString: String,
        method: HTTPMethod,
        headers: [String: String],
        body: Data?
    ) async throws -> (Data, HTTPURLResponse) {

        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body

        headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(http.statusCode) else {
            throw APIServiceError.backend(
                statusCode: http.statusCode,
                data: data
            )
        }

        return (data, http)
    }
}
