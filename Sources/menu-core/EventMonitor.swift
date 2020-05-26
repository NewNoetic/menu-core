//
//  EventMonitor.swift
//  KeepMenu
//
//  Created by Sidhant Gandhi on 4/10/20.
//  Copyright © 2020 newnoetic. All rights reserved.
//

import Cocoa

public class EventMonitor {
    public enum Context {
        case local
        case global
    }
    
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let context: Context
    private let handler: (NSEvent?) -> NSEvent?
    public init(mask: NSEvent.EventTypeMask, context: Context, handler: @escaping (NSEvent?) -> NSEvent?) {
        self.mask = mask
        self.context = context
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    public func start() {
        switch self.context {
        case .local:
            monitor = NSEvent.addLocalMonitorForEvents(matching: mask, handler: handler)
            break
        case .global:
            let hand: (NSEvent?) -> Void = { event in
                let _ = self.handler(event)
            }
            monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: hand)
            break
        }
    }
    
    public func stop() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}
