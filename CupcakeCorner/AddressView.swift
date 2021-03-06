//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Keiren on 11/15/20.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                    .disableAutocorrection(true)
                TextField("Street Address", text: $order.streetAddress)
                    .disableAutocorrection(true)
                TextField("City", text: $order.city)
                    .disableAutocorrection(true)
                TextField("Zip", text: $order.zip)
                    .disableAutocorrection(true)
            }
            
            Section {
                NavigationLink(destination: CheckoutView(order: order)) {
                    Text("Check out")
                }
            }
            .disabled(order.hasValidationAddress == false)
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
