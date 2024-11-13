//
//  PPColor.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 19.07.23.
//

import SwiftUI

extension Color: @retroactive RawRepresentable {
    public init(rawValue: String) {
        guard let data = Data(base64Encoded: rawValue) else {
            self = .clear
            return
        }
        
        do {
            if let color = try NSKeyedUnarchiver.unarchivedObject(
                ofClass: UIColor.self, from: data
            ) {
                self = Color(color)
            } else {
                self = .clear
            }
            
        } catch {
            self = .clear
        }
    }
    
    public var rawValue: String {
        do {
            let data = try NSKeyedArchiver.archivedData(
                withRootObject: UIColor(self), requiringSecureCoding: false
            ) as Data
            
            return data.base64EncodedString()
            
        } catch {
            return ""
        }
    }

    public init(data: Data) {
        var color: UIColor = .red
        do {
            color = try NSKeyedUnarchiver.unarchivedObject(
                ofClass: UIColor.self, from: data
            )!
                
        } catch {
            print(error)
        }
            
        self.init(color)
    }

    public func data() -> Data {
        var data = Data()
        do {
            try data = NSKeyedArchiver.archivedData(
                withRootObject: UIColor(self), requiringSecureCoding: false
            )
                
        } catch {
            print(error)
        }
            
        return data
    }
}
