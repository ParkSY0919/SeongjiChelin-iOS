//
//  Log.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/28/25.
//

import OSLog

class Log {
    
    private static let log = OSLog(subsystem: "EutCha-iOS", category: "General")
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
    
    /// 일반적인 로그를 찍을 때 사용합니다.
    class func i(_ message: String, file: String = #file, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let timestamp = dateFormatter.string(from: Date())
        os_log(.info, log: log, "ℹ️ [\(timestamp)] [\(fileName):\(line)] \(message)")
        #endif
    }
    
    /// Debug 시 사용합니다. Info와 유사하나, 실제 Console 앱에서 로그를 확인할 수 있습니다.
    class func d(_ message: String, file: String = #file, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let timestamp = dateFormatter.string(from: Date())
        os_log(.debug, log: log, "🛠 [\(timestamp)] [\(fileName):\(line)] \(message)")
        #endif
    }
    
    /// Error 로그를 찍을 때 사용합니다.
    class func e(_ message: String, file: String = #file, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let timestamp = dateFormatter.string(from: Date())
        os_log(.error, log: log, "⚠️ [\(timestamp)] [\(fileName):\(line)] \(message)")
        #endif
    }
    
    /// Decodable 객체를 로깅할 수 있습니다. 다만 dump나, debugPrint와 같이 정렬된 형태로는 출력되지 않습니다.
    class func dump<T: Decodable>(_ object: T, file: String = #file, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let timestamp = dateFormatter.string(from: Date())
        let logMessage = "🖨 [\(timestamp)] [\(fileName):\(line)] \(String(describing: object))"
        os_log(.debug, log: log, "%{public}s", logMessage)
        #endif
    }
}

