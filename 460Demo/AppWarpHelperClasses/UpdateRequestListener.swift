//
//  UpdateRequestListener.swift
//  460Demo
//
//  Created by Robert Ko on 2/8/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import UIKit

class UpdateReqListener: NSObject, UpdateRequestListener
{
    func onSendUpdatePeersDone(result: Byte) {
        if (Int(result) != 0) {
            println("!!!WARNING: sendUpdatePeers() failed with error code: \(result)!!!")
        }
    }
    
    func onSendPrivateUpdateDone(result: Byte) {
        println("onSendPrivateUpdateDone")
    }
}
