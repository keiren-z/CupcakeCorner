//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Keiren on 11/15/20.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text("Your total is $\(self.order.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("Place order") {
                        self.placeOrder()
                    }
                    
                    .padding()
                }
            }
        }
        .navigationBarTitle("Checkout", displayMode: .inline)
        
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                // Challenge 2
                if let nsError = error as NSError? {
                    let errorCode = nsError.code
                    /// -1009 is the offline error code
                    /// HTTP load failed (error code: -1009)
                    if errorCode == -1009 {
                        alert(title: "Warning‼️", message: "Please check your internet connection and try again.")
                    }
                }
                
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                alert(title: "Thank you🥰", message: "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way")
            } else {
                print("Invalid response from server")
            }
            
        }.resume()
    }
    
    func alert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
