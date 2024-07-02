// SystemBookUnitTest.swift created by Loudbook on 6/26/24.

import Testing
@testable import SystemBook

struct SystemBookUnitTest {
    @Test func runTest() async throws {
        let websocketManager = WebsocketManager(address: "ws://11ea-72-79-51-92.ngrok-free.app")
        
        print("Connecting")
        
        websocketManager.addMessageHandler { message in
            print(message)
        }
        
        websocketManager.sendString(message: "LIST")
        
        while true {}
    }

}
