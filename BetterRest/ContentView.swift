//
//  ContentView.swift
//  BetterRest
//
//  Created by Mykhailo Kravchuk on 24/02/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    @State private var sleep = 1.0
    
    var body: some View {
        
        VStack{
            Text(Date.now, format: .dateTime.hour().minute().month())
            Text("How long you want to slep")
                .font(.headline)
            
            DatePicker("Please enter time", selection: $wakeUp, in: Date.now...)
                .labelsHidden()
            
            Text("Desire amount of sleep")
                .font(.headline)
            Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 2...12, step: 0.25)
        }
        
    }
}
#Preview {
    ContentView()
}
