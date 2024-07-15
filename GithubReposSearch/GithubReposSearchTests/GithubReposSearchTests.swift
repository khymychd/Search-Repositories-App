import XCTest
@testable import GithubReposSearch

final class GithubApiClientTests: XCTestCase {
  
  var sut: GithubApiClient!
  var session: URLSession!
  var baseURL: URL!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    baseURL = URL(string: "https://api.github.com")
    session = URLSession(configuration: .ephemeral)
    sut = GithubApiClient(baseURL: baseURL, session: session)
  }
  
  override func tearDownWithError() throws {
    sut = nil
    session = nil
    baseURL = nil
    try super.tearDownWithError()
  }
  
  func testGetApiToken() {
    // Test the initialization of the client to ensure the token is set.
    XCTAssertNotNil(sut.token)
  }
  
  func testFindRepositories() async throws {
    // Mock session configuration with injected data and response
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    let mockSession = URLSession(configuration: configuration)
    
    // Mock data and response
    let mockResponse = HTTPURLResponse(url: baseURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
    let mockData = Data("{\"totalCount\": 1, \"items\": []}".utf8)
    MockURLProtocol.requestHandler = { request in
      return (mockResponse, mockData)
    }
    
    sut = GithubApiClient(baseURL: baseURL, session: mockSession)
    
    let result = await sut.findRepositories(by: "swift", numberElementsPerPage: 10, currentPage: 1)
    switch result {
    case .success(let searchResult):
      XCTAssertEqual(searchResult.totalCount, 1)
    case .failure(let error):
      XCTFail("Expected success but got \(error)")
    }
  }
}

/// Custom URL protocol for mocking network requests.
class MockURLProtocol: URLProtocol {
  static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
  
  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  override func startLoading() {
    guard let handler = MockURLProtocol.requestHandler else {
      fatalError("Handler is unavailable.")
    }
    
    do {
      let (response, data) = try handler(request)
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      client?.urlProtocol(self, didLoad: data)
      client?.urlProtocolDidFinishLoading(self)
    } catch {
      client?.urlProtocol(self, didFailWithError: error)
    }
  }
  
  override func stopLoading() {
    // No-op
  }
}
