//
//  LoggerHelper.swift
//  location_activity
//
//  Created by phattarapon on 26/7/2565 BE.
//

import Foundation
import XCGLogger

class Logger: XCGLogger {
    
    public static let shared: Logger = {
        let instance = Logger()
        let documentDir = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first
        if let logPath: URL = documentDir?.appendingPathComponent("logs_\(Date().dateKeyString().lowercased()).log") {
           let fileDestination = FileDestination(owner: instance, writeToFile: logPath, identifier: "ddc-care.logger", shouldAppend: true,
                                                 appendMarker: "--- New session ---", attributes: nil)
            fileDestination.logQueue = DispatchQueue.global(qos: .background)
            instance.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: false, showLineNumbers: false,
                      writeToFile: logPath, fileLevel: .debug)
            instance.add(destination: fileDestination)
        }
        return instance
    }()
    
}
