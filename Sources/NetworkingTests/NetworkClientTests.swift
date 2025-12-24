//
//  NetworkClientTests.swift
//  Networking
//
//  Created by Anzori Kizikelashvili on 23.12.25.
//

import XCTest
@testable import Networking

@available(iOS 15.0, macOS 12.0, *)
final class NetworkClientTests: XCTestCase {

    private var client: NetworkClient!

    override func setUp() {
        super.setUp()

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)

        client = NetworkClient(session: session)
    }

    func testRequestSuccess() async throws {
        let expectedJSON = """
        {
            "id": 1,
            "name": "Test Event"
        }
        """.data(using: .utf8)!

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, expectedJSON)
        }

        struct Event: Decodable {
            let id: Int
            let name: String
        }

        let event: Event = try await client.request(
            urlString: "https://test.com/event"
        )

        XCTAssertEqual(event.id, 1)
        XCTAssertEqual(event.name, "Test Event")
    }

    func testRequestFailureStatusCode() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }

        do {
            let _: String = try await client.request(
                urlString: "https://test.com/notfound"
            )
            XCTFail("Expected error was not thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
}
