//
//  JVTerminalDriver.swift
//
//
//  Created by Jan Verrept on 04/06/2021.
//

import Foundation
import JVSwiftCore

public class TerminalDriver:Shell{
	
	public init(){}
	
	public func execute(commandString:String) throws -> String{
        
        let outputPipe = Pipe()
        
        let shell = Process()
        shell.executableURL = URL(fileURLWithPath: "/bin/zsh")
        shell.arguments = ["-c", "\(commandString)"]

        shell.standardInput = nil
        shell.standardOutput = outputPipe
        shell.standardError = nil
        
        try shell.run()
        shell.waitUntilExit()

		let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
		let output = String(data: data, encoding: .utf8)!
		
		return output
	}
	
	public func run(commandString:String) throws -> String{
		try execute(commandString: commandString)
	}
	
}


public class TerminalCommand{
    
    let terminal = TerminalDriver()
    let command:String
    
    public init(_ commandString:String){
        self.command = commandString
    }
    
    public func execute() throws -> String{
		try terminal.execute(commandString: self.command)
    }
    
	// Just an alias for execute()
	public func run() throws -> String{
		try execute()
	}
}
