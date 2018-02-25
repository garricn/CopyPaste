//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import Foundation

public final class DataStore {
    
    private let encoder: JSONEncoding
    private let decoder: JSONDecoding
    private let location: URL
    
    public init(encoder: JSONEncoding = JSONEncoder(),
         decoder: JSONDecoding = JSONDecoder(),
         location: URL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!) {
        self.encoder = encoder
        self.decoder = decoder
        self.location = location
    }
    
    public func encode<E: Encodable>(_ encodable: E) {
        do {
            try encoder.encode(encodable.self).write(to: location.appendingPathComponent(E.pathComponent))
        } catch {
            fatalError("\(error)")
        }
    }
    
    public func decode<D: Decodable>(_ type: D.Type) -> D? {
        do {
            let data = try Data(contentsOf: location.appendingPathComponent(D.pathComponent))
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
}

public protocol JSONEncoding {
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}

public protocol JSONDecoding {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONEncoder: JSONEncoding {}
extension JSONDecoder: JSONDecoding {}

private extension Encodable {
    static var pathComponent: String {
        return String.init(describing: self)
    }
}

private extension Decodable {
    static var pathComponent: String {
        return String.init(describing: self)
    }
}
