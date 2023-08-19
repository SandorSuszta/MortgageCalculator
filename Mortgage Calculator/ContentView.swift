//
//  ContentView.swift
//  Mortgage Calculator
//
//  Created by Nataliia Shusta on 19/08/2023.
//
import SwiftUI

struct ContentView: View {
    
    @State private var propertyPrice = 0.0
    @State private var deposit = 0.0
    @State private var loanTerm = 35
    @State private var interestRate = 0.0
    
    @State private var monthlyPayment = 0
    
    @State private var isMortgageFee = false
    @State private var mortgageFee = 0
    
    @FocusState private var isPriceFieldActive
    @FocusState private var isDepositActive
    
    private var depositPercentage: Int {
        guard propertyPrice > 0 else { return 0}
        
        return Int(deposit / propertyPrice * 100)
    }
    
    var body: some View {
        
        NavigationStack {
            Form {
                
                Section ("Property price") {
                    HStack {
                        TextField("Property price", value: $propertyPrice, formatter: .MCPriceFormatter)
                            .font(.title2)
                            .keyboardType(.numberPad)
                            .focused($isPriceFieldActive)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button {
                                        isPriceFieldActive = false
                                        isDepositActive = false
                                    } label: {
                                        Text("Done")
                                    }
                                }
                            }
                        
                        Stepper("Price stepper", value: $propertyPrice, in: 0...1_000_000, step: 1000)
                            .labelsHidden()
                    }
                    
                    Slider(value: $propertyPrice, in: 0...1_000_000, step: 10_000)
                }
                
            
                Section("Deposit (\(depositPercentage)%)") {
                    
                    HStack {
                        TextField("Property price", value: $deposit, formatter: .MCPriceFormatter)
                            .font(.title2)
                            .keyboardType(.numberPad)
                            .focused($isPriceFieldActive)
                        
                        Stepper("Deposit stepper",
                                value: $deposit,
                                in: 0...max(propertyPrice, 10000),
                                step: 1000)
                        .labelsHidden()
                    }
                    
                    Slider(value: $deposit,
                           in: 0...max(propertyPrice, 10000),
                           step: 10_000)
                }
                .disabled(propertyPrice < 10_000)
                .onChange(of: propertyPrice) { newValue in
                    if deposit > newValue {
                        deposit = newValue
                    }
                }
                .onChange(of: deposit) { newValue in
                    if newValue > propertyPrice {
                        deposit = propertyPrice
                    }
                }
        
                
                Section("Term") {
                    Picker("Term", selection: $loanTerm) {
                        ForEach(Array(stride(from: 35, to: 10, by: -5)), id: \.self) {
                            Text("\($0)")
                                .font(.title2)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section("Interest rate") {
                    HStack {
                        TextField("Interest rate", value: $interestRate, format: .percent)
                            .font(.title2)
                            .keyboardType(.decimalPad)
                        Stepper("Interest stepper", value: $interestRate, in: 0...0.1, step: 0.0001)
                            .labelsHidden()
                    }
                    
                    Slider(value: $interestRate, in: 0...0.1, step: 0.001)
                }
            }
            .navigationTitle("Mortgage calculator")
            .onAppear() {
                isPriceFieldActive = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView {
    private func validatePriceEntry(_ entry: String) {
        
    }
    
    private func calculateMonthlyPayment() {
        guard deposit < propertyPrice else {
            monthlyPayment = 0
            return
        }
        
        let principal = propertyPrice - deposit
        let monthlyInterestRate = interestRate / 12
        let totalPayments = loanTerm * 12
        
        if monthlyInterestRate > 0 {
            let numerator = monthlyInterestRate * pow(1 + monthlyInterestRate, Double(totalPayments))
            let denominator = pow(1 + monthlyInterestRate, Double(totalPayments)) - 1
            let monthlyPayment = Int(Double(principal) * (numerator / denominator))
            self.monthlyPayment = monthlyPayment
        } else {
            self.monthlyPayment = Int(principal) / totalPayments
        }
    }
}
