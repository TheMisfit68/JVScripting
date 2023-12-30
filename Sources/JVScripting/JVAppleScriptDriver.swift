//
//  JVAppleScriptDriver.swift
//
//
//  Created by Jan Verrept on 01/11/2023.
//

import Foundation
import OSLog

public class AppleScriptDriver{
    
    let fileManager = FileManager.default
    let appleScriptsFolder:URL!
    let fileExtensions:[String] = ["", ".scpt", ".applescript"]
    
    public init(){
        
        let applicationSupportDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        appleScriptsFolder = applicationSupportDirectory.appendingPathComponent("AppleScripts", isDirectory: true)
        let folderPath = appleScriptsFolder.path
        if !fileManager.fileExists(atPath: folderPath){
            do {
                try fileManager.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                let logger = Logger(subsystem: "be.oneclick.scriptdrivers", category: "LifeCycle")
                logger.error(
                    """
                    Couldn't create 'AppleScripts'-directory:
                    \(error.localizedDescription, privacy: .public)
                    """
                )
            }
        }
        
        
    }
    
    public func run(_ scriptName:String) throws{
        
        if let scriptPath = pathFor(scriptName: scriptName){
            
            let appleScript = Process()
            appleScript.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
            appleScript.standardInput = nil
            appleScript.standardOutput = nil
            appleScript.standardError = nil
            appleScript.arguments = [scriptPath]
            
            try appleScript.run()
            appleScript.waitUntilExit()
        }
        
    }
    
    
    private func pathFor(scriptName:String)->String?{
        
        let allAppleScripts = try? fileManager.contentsOfDirectory(atPath: appleScriptsFolder.path)
        var appleScriptPath:String? = nil
        var fileExtensionCounter = 0
        while (allAppleScripts != nil) && (appleScriptPath == nil) && (fileExtensionCounter < fileExtensions.count) {
            let fileName = scriptName+fileExtensions[fileExtensionCounter]
            if allAppleScripts!.contains(fileName){
                appleScriptPath = appleScriptsFolder.appendingPathComponent(fileName).path
            }
            fileExtensionCounter += 1
        }
        return appleScriptPath
        
    }
}



