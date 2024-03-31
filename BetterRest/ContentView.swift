//
//  ContentView.swift
//  BetterRest
//
//  Created by Mykhailo Kravchuk on 24/02/2024.
//
import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    @State private var coffeAmount = 1.0
    @State private var alertTitle = ""
    @State private var alertMessage  = ""
    @State private var showingAlert = false

    var body: some View {
        NavigationStack{
            VStack{
                Text("When do you want to wakeup ?")
                    .font(.headline)
                
                DatePicker("Please enter time", selection: $wakeUp, displayedComponents:
                    .hourAndMinute)
                    .labelsHidden()
                
                Text("Desire amount of sleep")
                    .font(.headline)
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 2...12, step: 0.25)
                
                Text("Daily coffe amount")
                Stepper("\(coffeAmount.formatted()) cup(s)", value: $coffeAmount, in: 0...20)
            }
            .padding()
            .navigationTitle("BetterRest")
            .toolbar{
                Button("Calculate", action: calculateBedTime)
        }
            .alert(alertTitle, isPresented: $showingAlert){
                Button("Ok"){}
            } message:{
                Text(alertMessage)
            }
        
        
        }
    }
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Int64(Double(hour + minute)), estimatedSleep: sleepAmount, coffee: Int64(Double(coffeAmount)))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "YOur ideal time sleep is.."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        }catch{
            alertTitle = "Error"
            alertMessage = "Sorry, there was problem"
        }
        showingAlert = true
}
}
#Preview {
    ContentView()
}
