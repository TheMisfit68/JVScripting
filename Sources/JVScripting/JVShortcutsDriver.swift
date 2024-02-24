//
//  JVShortcutsDriver.swift
//
//
//  Created by Jan Verrept on 01/11/2023.
//

import Foundation
import OSLog
import JVSwiftCore

public class ShortcutsDriver{
	let logger = Logger(subsystem: "be.oneclick.scriptdrivers", category: "ShortcutsDriver")
    
    public init(){}
    
    public func run(_ shortcutName:String, withParameter:String? = nil) throws{
        
        
        if let shortcutParameter = withParameter{
            
            let ioPipe = Pipe()
            
            // The parameter needs to be piped with the rest of the command because the parameter normally is a filename, not a String and
            // and the normal pipe operator doesn't seem to  work when used on the second process
            let prepareParameter = Process()
            prepareParameter.executableURL = URL(fileURLWithPath: "/bin/zsh")
            prepareParameter.standardInput = nil
            prepareParameter.standardOutput = ioPipe
            prepareParameter.standardError = nil
            prepareParameter.arguments = ["-c", "echo '\(shortcutParameter)'"]
            
            try prepareParameter.run()
            prepareParameter.waitUntilExit()
                    
            let shortcuts = Process()
            shortcuts.executableURL = URL(fileURLWithPath: "/usr/bin/shortcuts")
            shortcuts.standardInput = ioPipe
            shortcuts.standardOutput = nil
            shortcuts.standardError = nil
            shortcuts.arguments = ["run", shortcutName]
            
            try shortcuts.run()
            shortcuts.waitUntilExit()
            
        }
    }
}
