//
//  KeyboardService.swift
//  Remote Keyboard
//
//  Created by Xiao Shi on 1/2/18.
//  Copyright © 2018 devbycm. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol KeyboardServiceDelegate {
    func service(_: KeyboardService, didInsert text: String)
    func service(_: KeyboardService, didUpdate text: String)
    func service(_: KeyboardService, didDelete count: Int)
    func service(_: KeyboardService, didEnter count: Int)
}

class KeyboardService: NSObject {
    private let serviceType = "rkb"
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceBrowser: MCNearbyServiceBrowser
    private let session: MCSession
    var delegate: KeyboardServiceDelegate?
    var isConnected = false
    
    override init() {
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        self.session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        super.init()
        self.serviceBrowser.delegate = self
        self.session.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    func start() {
    }
    
    func disconnect() {
//        self.session.disconnect()
    }
    
    deinit {
//e        self.serviceBrowser.stopBrowsingForPeers()
        self.session.disconnect()
    }
}


extension KeyboardService: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("[didNotStartBrowsingForPeers] \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        print("[foundPeer] \(peerID.displayName)")
        if !session.connectedPeers.contains(peerID) {
            self.serviceBrowser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 0.0)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("[lostPeer] \(peerID.displayName)")
    }
}

extension KeyboardService: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("[Connected]", peerID.displayName)
            isConnected = true
//            do {
//                try self.session.send("456".data(using: .utf8)!, toPeers: [peerID], with: .reliable)
//            } catch {
//                print("_err", error)
//            }
        case .connecting:
            print("[Connecting]", peerID.displayName)
        case .notConnected:
            print("[NotConnected]", peerID.displayName)
            if session.connectedPeers.count == 0 {
                isConnected = false
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("[rcv]\(peerID.displayName):", String.init(data: data, encoding: .utf8)!)
        //        try! self.session.send(data, toPeers: [peerID], with: .reliable)
        let json = JSON(data)
        let instruction = json[0].stringValue
        switch instruction {
        case "update":
            let text = json[1].stringValue
            delegate?.service(self, didUpdate: text)
        case "insert":
            let text = json[1].stringValue
            delegate?.service(self, didInsert: text)
        case "delete":
            delegate?.service(self, didDelete: 0)
        case "enter":
            delegate?.service(self, didEnter: 0)
        default:
            break
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
}

