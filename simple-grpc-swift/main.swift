//
//  main.swift
//  simple-grpc-swift
//
//  Created by Sepehr Mohammadi on 2/24/21.
//

import Foundation
import GRPC
import NIO
import SwiftProtobuf

func makeClient(host: String, port: Int, group: EventLoopGroup) -> Update_UpdateClient {
  let channel = ClientConnection.insecure(group: group)
    .connect(host: host, port: port)

  return Update_UpdateClient(channel: channel)
}


func login(using client: Update_UpdateClient, username: String, password: String) -> String {
    let loginParams : Update_LoginRequest = .with {
        $0.username = username
        $0.password = password
    }
    
    let call = client.login(loginParams)
    let loginResponse: Update_LoginResponse
    
    do {
        loginResponse = try call.response.wait()
    } catch {
        print("RPC Failed: \(error)")
        return ""
    }
    
    return loginResponse.token
}

func logout(using client: Update_UpdateClient, token: String) -> Bool {
    let logoutParams: Update_LogoutRequest = .with {
        $0.token = token
    }
    
    let call = client.logout(logoutParams)
    
    do {
        _ = try call.response.wait()
    } catch {
        print("RPC Failed: \(error)")
        return false
    }
    
    return true
}

func streamUpdates(using client: Update_UpdateClient) -> Bool {
    let call = client.serverPromotions(Google_Protobuf_Empty()) { response in
        print(response.update.type + ":" + response.update.text)
    }
    
    let status = try! call.status.recover { _ in .processingError }.wait()
    if status.code != .ok {
      print("RPC failed: \(status)")
      return false
    }
    return true
}

func main() {
    let host = "localhost"
    let port = 80
    
    let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    defer {
      try? group.syncShutdownGracefully()
    }

    print("Connecting to the server...")
    let updateClient = makeClient(host: host, port: port, group: group)
    print("Connected!")
    
    print("Logging in...")
    let token = login(using: updateClient, username: "testuser", password: "testpassword")
    if token != "" {
        print("Logged In! Token is \(token)")
    }
   
    
    print("Logging out...")
    let success = logout(using: updateClient, token: token)
    if success {
        print("Logged out successfully!")
    }
    
    print("Fetching server updates...")
    _ = streamUpdates(using: updateClient)
    
}


main()
