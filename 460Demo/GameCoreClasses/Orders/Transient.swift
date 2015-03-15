//
//  Transient.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/13/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
/*
 * Orders that implement Transient WILL NOT remove an already existing order
 * on a unit when they are sent. Useful if you dont want an ability to interrupt
 * a move or attack order.
 */
@objc(Transient)
protocol Transient{}