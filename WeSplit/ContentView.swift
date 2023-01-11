//
//  ContentView.swift
//  WeSplit
//
//  Created by Fernando Gomez on 1/2/23.
//

import SwiftUI

struct ContentView: View {
    @State private var currencyCode = Locale.current.currency?.identifier ?? "USD"
    @State private var checkAmount = ""
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    @State private var noTipInRed = false

    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var grandTotal: Double {
        let tipSelection = Double(tipPercentage)
        let tipValue =  (Double(checkAmount) ?? 0.00 ) / 100 * tipSelection
        let total = (Double(checkAmount) ?? 0.00 ) + tipValue
        return total
    }
    
    var totalPerPerson: Double {
        // calculate the total per person
        let peopleCount = Double(numberOfPeople + 2)
//        let tipSelection = Double(tipPercentage)
//
//        let tipValue = checkAmount / 100 * tipSelection
//        let grandtotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        
        return amountPerPerson
    }
    
    
    
    var body: some View {
        
        NavigationView {
            Form {
                Section {
                    
                    TextField("Amounts", text: $checkAmount, prompt: Text(((Locale.current.currencySymbol ?? "USD") + " 0.00")) ,axis: .horizontal).modifier(TextFieldClearButton(text: $checkAmount))
                    
                        .keyboardType(.decimalPad)
                        .focused(($amountIsFocused))
                        
                                        
                }
            header: {
                Text("What is the total check amount?")
            }
                
                Section {
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                    .pickerStyle(.menu)
                }
            header: {
                Text("How many people will split the check?")
            }
                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent).tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: tipPercentage) { tag in
                        print(tag)
                        if tag == 0 {
                            noTipInRed = true
                        } else {
                            noTipInRed = false
                        }
                    }
                       
                } header: {
                    Text("How much tip do you want to leave?")
                }
                Section{
                    Text(grandTotal, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            header: {
                Text("Total Before Split")
            }
                Section {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .foregroundColor(noTipInRed ? .red : .black)
                }
                
            header: {
                Text("Total")
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
                
            }
            
            .navigationTitle("WeSplit")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
      
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
