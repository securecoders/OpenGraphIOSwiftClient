import XCTest
@testable import OpenGraphIOSwiftClient

final class OpenGraphClientTests: XCTestCase {

    func testDefaultGetSiteInfo() {
        // Initialize an XCTestExpectation
        let expectation = XCTestExpectation(description: "OpenGraphIO getSiteInfo with appId and default configs Test")

        // Ensure that the URL is valid
       let url = "https://www.psychologytoday.com/sg/blog/mindful-leadership/202308/remote-work-is-less-productive-study"
        
        // Initialize OpenGraphIO.Options
        let options = OpenGraphIO.Options(appId: "xxx")
        // Initialize OpenGraphIO
        let client = OpenGraphIO(options: options)

        client.getSiteInfo(for: url) { result in
            switch result {
            case .success(let response):
                // Ensure that the response is not nil
                XCTAssertNotNil(response, "Expected response to not be nil, but it was.")
            case .failure(let error):
                // If there's an error, fail the test
                XCTFail("Error occurred: \(error)")
            }
            // Fulfill the expectation in the completion handler of the asynchronous task
            expectation.fulfill()
        }

        // Wait until the expectation is fulfilled
        wait(for: [expectation], timeout: 30.0)
    }
    
    
    func testDefaultElementsExtractGetSiteInfo() {
        // Initialize an XCTestExpectation
        let expectation = XCTestExpectation(description: "OpenGraphIO getSiteInfo with appId and default configs Test")

        // Ensure that the URL is valid
       let url = "https://www.psychologytoday.com/sg/blog/mindful-leadership/202308/remote-work-is-less-productive-study"

        // Initialize OpenGraphIO.Options
        let options = OpenGraphIO.Options(appId: "xxx", service: "extract")
        // Initialize OpenGraphIO
        let client = OpenGraphIO(options: options)

        client.getSiteInfo(for: url) { result in
            switch result {
            case .success(let response):
                // Ensure that the response is not nil
                XCTAssertNotNil(response, "Expected response to not be nil, but it was.")
            case .failure(let error):
                // If there's an error, fail the test
                XCTFail("Error occurred: \(error)")
            }
            // Fulfill the expectation in the completion handler of the asynchronous task
            expectation.fulfill()
        }

        // Wait until the expectation is fulfilled
        wait(for: [expectation], timeout: 30.0)
    }
    
    
    func testCustomHtmlElementsGetSiteInfo() {
        // Initialize an XCTestExpectation
        let expectation = XCTestExpectation(description: "OpenGraphIO getSiteInfo with appId and default configs Test")

        // Ensure that the URL is valid
       let url = "https://www.psychologytoday.com/sg/blog/mindful-leadership/202308/remote-work-is-less-productive-study"

        // Initialize OpenGraphIO.Options
        let options = OpenGraphIO.Options(appId: "xxx", service: "extract", htmlElements: "h1,h2")
        // Initialize OpenGraphIO
        let client = OpenGraphIO(options: options)

        client.getSiteInfo(for: url) { result in
            switch result {
            case .success(let response):
                // Ensure that the response is not nil
                XCTAssertNotNil(response, "Expected response to not be nil, but it was.")
            case .failure(let error):
                // If there's an error, fail the test
                XCTFail("Error occurred: \(error)")
            }
            // Fulfill the expectation in the completion handler of the asynchronous task
            expectation.fulfill()
        }

        // Wait until the expectation is fulfilled
        wait(for: [expectation], timeout: 30.0)
    }
    
    func testDefaultScrapeGetSiteInfo() {
        // Initialize an XCTestExpectation
        let expectation = XCTestExpectation(description: "OpenGraphIO getSiteInfo with appId and default configs Test")

        // Ensure that the URL is valid
       let url = "https://www.psychologytoday.com/sg/blog/mindful-leadership/202308/remote-work-is-less-productive-study"

        // Initialize OpenGraphIO.Options
        let options = OpenGraphIO.Options(appId: "xxx", service: "scrape")
        // Initialize OpenGraphIO
        let client = OpenGraphIO(options: options)

        client.getSiteInfo(for: url) { result in
            switch result {
            case .success(let response):
                // Ensure that the response is not nil
                XCTAssertNotNil(response, "Expected response to not be nil, but it was.")
            case .failure(let error):
                // If there's an error, fail the test
                XCTFail("Error occurred: \(error)")
            }
            // Fulfill the expectation in the completion handler of the asynchronous task
            expectation.fulfill()
        }

        // Wait until the expectation is fulfilled
        wait(for: [expectation], timeout: 30.0)
    }
}
