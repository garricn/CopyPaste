//
//  DataStore.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 11/22/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import Foundation

import Foundation

final class DataStore {
    
    private let encoder: JSONEncoding
    private let decoder: JSONDecoding
    private let location: URL
    
    init(encoder: JSONEncoding, decoder: JSONDecoding, location: URL) {
        self.encoder = encoder
        self.decoder = decoder
        self.location = location
    }
    
    func encode<E: Encodable>(_ encodable: E) {
        do {
            try encoder.encode(encodable.self).write(to: location.appendingPathComponent(E.pathComponent))
        } catch {
            fatalError("\(error)")
        }
    }
    
    func decode<D: Decodable>(_ type: D.Type) -> D {
        do {
            let data = try Data(contentsOf: location.appendingPathComponent(D.pathComponent))
            let decodable = try decoder.decode(type, from: data)
            return decodable
        } catch {
            fatalError("\(error)")
        }
    }
}

protocol JSONEncoding {
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}

protocol JSONDecoding {
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
