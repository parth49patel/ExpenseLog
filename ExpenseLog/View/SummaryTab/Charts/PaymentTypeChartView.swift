//
//  PaymentTypeChartView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-03-27.
//

import SwiftUI
import Charts

struct PaymentTypeChartView: View {
    
    let expenseByPaymentType: [(paymentType: PaymentType, total: Double)]
    
    var body: some View {
        Chart {
            ForEach(expenseByPaymentType, id: \.paymentType) { data in
                BarMark(x: .value("Payment Type", data.paymentType.rawValue.capitalized),
                        y: .value("Amount", data.total))
                .foregroundStyle(data.paymentType.background)
                .annotation(position: .top) {
                    VStack {
//                        Image(systemName: data.paymentType.rawValue)
//                            .imageScale(.large)
//                        .foregroundStyle(data.paymentType.rawValue)
                        Text("$\(String(format:"%.2f", data.total))")
                            .font(.subheadline)
                    }
                }
            }
        }
        .frame(height: 400)
        .padding()
    }
}

#Preview {
    PaymentTypeChartView(expenseByPaymentType: [
        (paymentType: .visa, total: 213.78),
        (paymentType: .mastercard, total: 123.45),
        (paymentType: .cash, total: 100.00),
    ])
}
