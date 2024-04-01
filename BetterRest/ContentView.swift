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
    @State private var wakeUp = defoultWakeUp
    @State private var coffeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage  = ""
    @State private var showingAlert = false

    
    static var defoultWakeUp: Date{
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack{
            Form{
                VStack(alignment: .leading){
                    Text("When do you want to wakeup ?")
                        .font(.headline)
                    
                    DatePicker("Please enter time", selection: $wakeUp, displayedComponents:
                            .hourAndMinute)
                    .labelsHidden()
                }
                VStack(alignment: .leading){
                    Text("Desire amount of sleep")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 2...12, step: 0.25)
                }
                VStack(alignment: .leading){
                    Text("Daily coffe amount")
                    Stepper("^[\(coffeAmount) cup](inflect: true)", value: $coffeAmount, in: 1...20)
                }
            }
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
