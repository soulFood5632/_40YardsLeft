//
//  Encodable.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-26.
//

import Foundation

extension Encodable {
    

    var toDictionary: [String : Any]? {
        guard let data =  try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}
