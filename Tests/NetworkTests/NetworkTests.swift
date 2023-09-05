import XCTest
import core_architecture
import ManagedAppConfigLib
@testable import Network



final class NetworkTests: NetworkBaseTestCase {
    
    func testNoNetworkConfiguration() throws {
        let expectation = XCTestExpectation(description: "Network Test Call")
        register { _ in [] }
        Task {
            let manager = self.sendNetworkRequest(
                action: NoActionMockNetworkDebugAction().action,
                session: MockErrorSessionManager(error: .network(.noNetworkConfigurationFound))
            )
            do {
                _ = try await manager.send(
                    to: Endpoint.signup,
                    with: LoginRequest(email: "a@a.com", password: "123123"),
                    type: User.self
                )
                XCTFail("No Error Thrown")
            }
            catch let error {
                if let error = error as? SystemError {
                    XCTAssertTrue(error.isEqual(to: .network(.noNetworkConfigurationFound)))
                }
                expectation.fulfill()
            }
            
        }
        
        wait(for: [expectation], timeout: .init(10))
    }
    func testNoDebugConfiguration() throws {
        register { registrar in
            [
                registrar.networkRegister(endpoint: Endpoint.signup, method: .post, contentType: .applicationJSON, responseType: User.self, headers: [:])
            ]
        }
        
        let expectation = XCTestExpectation(description: "Network Test Call")
        Task {
            let manager = self.sendNetworkRequest(
                action: NoActionMockNetworkDebugAction().action,
                session: MockErrorSessionManager(error: .debugger(.noConfigurationFound))
            )
            do {
                _ = try await manager.send(
                    to: Endpoint.signup,
                    with: LoginRequest(email: "a@a.com", password: "123123"),
                    type: User.self
                )
                XCTFail("No Error Thrown")
            }
            catch let error {
                if let error = error as? SystemError {
                    XCTAssertTrue(error.isEqual(to: .debugger(.noConfigurationFound)))
                }
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: .init(10))
    }
    func testSuccessfullApi() throws {
        register { registrar in
            [
                // Network Registration
                registrar.networkRegister(endpoint: Endpoint.signup, method: .post, contentType: .applicationJSON, responseType: User.self, headers: [:]),
                // Debug Registration
                registrar.debuggerRegister(type: NetworkRequestDebug.self, debugable: Endpoint.signup, breakPoint: .ignore),
                registrar.debuggerRegister(type: NetworkDataDebug.self, debugable: Endpoint.signup, breakPoint: .ignore),
                registrar.debuggerRegister(type: NetworkErrorDebug.self, debugable: Endpoint.signup, breakPoint: .ignore),
            ]
        }
        let expectation = XCTestExpectation(description: "Network Test Call")
        Task {
            let manager = self.sendNetworkRequest(
                action: NoActionMockNetworkDebugAction().action,
                session: MockSessionManager(data: User.testExample)
            )
            do {
                let data = try await manager.send(
                    to: Endpoint.signup,
                    with: LoginRequest(email: "a@a.com", password: "123123"),
                    type: User.self
                )
                XCTAssertTrue(data.isEqual(to: .testExample))
            }
            catch _ {
                XCTFail("No Error Thrown")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: .init(10))
    }
    func testSuccessfullApiAfterDataDebugEditing() throws {
        register { registrar in
            [
                // Network Registration
                registrar.networkRegister(endpoint: Endpoint.signup, method: .post, contentType: .applicationJSON, responseType: User.self, headers: [:]),
                // Debug Registration
                registrar.debuggerRegister(type: NetworkRequestDebug.self, debugable: Endpoint.signup, breakPoint: .ignore),
                registrar.debuggerRegister(type: NetworkDataDebug.self, debugable: Endpoint.signup, breakPoint: .console),
                registrar.debuggerRegister(type: NetworkErrorDebug.self, debugable: Endpoint.signup, breakPoint: .ignore),
            ]
        }
        let expectation = XCTestExpectation(description: "Network Test Call")
        Task {
            let manager = self.sendNetworkRequest(
                action: DataActionMockNetworkDebugAction().action,
                session: MockSessionManager(data: User.testExample)
            )
            do {
                let data = try await manager.send(
                    to: Endpoint.signup,
                    with: LoginRequest(email: "a@a.com", password: "123123"),
                    type: User.self
                )
                XCTAssertTrue(data.isEqual(to: .testExample2))
            }
            catch _ {
                XCTFail("No Error Thrown")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: .init(10))
    }
    
}




