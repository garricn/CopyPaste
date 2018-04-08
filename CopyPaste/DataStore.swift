//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import Foundation

public final class DataStore {
    
    let name: String
    let baseURL: URL
    let encoder: JSONEncoding
    let decoder: JSONDecoding
    let manager: FileManager
    
    var location: URL {
        return baseURL.appendingPathComponent(name)
    }
    
    public init(name: String,
                baseURL: URL = Globals.dataDirectoryURL,
                encoder: JSONEncoding = JSONEncoder(),
                decoder: JSONDecoding = JSONDecoder(),
                manager: FileManager = FileManager.default) {
        self.name = name
        self.baseURL = baseURL
        self.encoder = encoder
        self.decoder = decoder
        
        self.manager = manager
        
        do {
            try self.manager.createDirectory(at: baseURL, withIntermediateDirectories: false, attributes: nil)
        } catch {
            if (error as NSError).code != 516 {
                fatalError("Unexpected error!")
            }
        }
    }
    
    public func encode<E: Encodable>(_ encodable: E) {
        do {
            try encoder.encode(encodable).write(to: location)
        } catch {
            fatalError("\(error)")
        }
    }
    
    public func decode<D: Decodable>(_ type: D.Type) -> D? {
        do {
            let data = try Data(contentsOf: location)
            let decodable = try decoder.decode(type, from: data)
            return decodable
        } catch {
            return nil
        }
    }

    public func decode<D: Decodable>(type: D.Type, from data: Data) -> D? {
        do {
            let decodable = try decoder.decode(type, from: data)
            return decodable
        } catch {
            return nil
        }
    }
    
    public func removeData<E: Encodable>(for type: E.Type) throws {
        try FileManager.default.removeItem(at: location)
    }
}

public protocol JSONEncoding {
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}

public protocol JSONDecoding {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONEncoder: JSONEncoding {}
extension JSONDecoder: JSONDecoding {}
