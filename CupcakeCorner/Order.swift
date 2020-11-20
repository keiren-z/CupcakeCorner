//
//  Order.swift
//  CupcakeCorner
//
//  Created by Keiren on 11/15/20.
//

import Foundation

class Order: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, name, streeAddress, city, zip
    }
    
    static let types = ["Vanilla","Strawberry","Chocolate","Rainbow"]
    
    @Published var type = 0
    @Published var quantity = 3
    
    @Published var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    @Published var extraFrosting = false
    @Published var addSprinkles = false
    
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""
    
    var hasValidationAddress: Bool {
        if name.isEmpty ||
            streetAddress.isEmpty ||
            city.isEmpty ||
            zip.isEmpty {
            
            return false
        }
        
        if name.trim.isEmpty ||
            streetAddress.trim.isEmpty ||
            city.trim.isEmpty ||
            zip.trim.isEmpty {
            
            return false
        }
        
        return true
    }
    
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2
        // complicated cakes cost more
        cost += Double(type) / 2
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }
        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
    /* we need to write a new initializer that can create an order without any data whatsoever – it will rely entirely on the default property values we assigned */
    init() { }
    
    /* implement a required initializer to decode an instance of Order from
     some archived data.*/
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        
        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streeAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
    }
    
    /* an encode(to:) method,
     creates a container using the coding keys enum,
     then writes out all the properties attached to their respective key.*/
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)
        
        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streeAddress)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
    }
}
