//
//  ContentView.swift
//  BasicCalculator
//
//  Created by Macmaurice Osuji on 2/28/24.
//

import SwiftUI

enum AllButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    
    case add = "+"
    case subtract = "-"
    case divide = "÷"
    case mutliply = "x"
    
    case equal = "="
    case clear = "AC"
    case decimal = "."
    
    case cosine = "cos("
    case sine = "sin("
    case tangent = "tan("

    var buttonColor: Color {
        switch self {
        case .cosine, .sine, .tangent, .decimal:
            return .green
        case .clear:
            return Color(.lightGray)
        case .divide, .add, .subtract,.mutliply, .equal:
            return Color.blue
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
}

enum Operation {
    case add, subtract, multiply, divide, sine, cosine, tangent, none
}

struct ContentView: View {
    @State private var inputInt = 0.0
    @State private var inputString = "0"
    @State private var displayInput = ""
    @State private var answer = "0"
    @State private var decimalAnswer = false
    @State private var currentOperation: Operation = .none
    
    let buttonsArrangement: [[AllButton]] = [
        [.clear, .sine, .tangent, .cosine],
        [.one, .two, .three, .decimal],
        [.four, .five, .six, .zero],
        [.seven, .eight, .nine, .equal],
        [.divide, .add, .subtract, .mutliply],
    ]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.black).edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    Text(answer)
                        .bold()
                        .font(.system(size: 90))
                        .foregroundColor(.white)
                        .padding()

                    VStack {
                        Text(displayInput)
                    }
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .background(
                        Color.blue
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    )
                    
                    .padding()
                    
                    ForEach(buttonsArrangement, id: \.self) { row in
                        HStack(spacing: 12) {
                            ForEach(row, id: \.self) { item in
                                Button(action: {
                                    self.tappedButton(button: item)
                                }, label: {
                                    Text(item.rawValue)
                                        .font(.system(size: 32))
                                        .frame(
                                            width: self.buttonWidth(item: item),
                                            height: self.buttonHeight()
                                        )
                                        .background(item.buttonColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(self.buttonWidth(item: item)/2)
                                })
                            }
                        }
                        .padding(.bottom, 3)
                       }
                    }
                }
            }
        }
    
    func tappedButton(button: AllButton) {
        if button != .equal {
            if displayInput.hasSuffix("(") && (button == .sine || button == .cosine || button == .tangent) {
                // Do nothing if displayInput ends with "(" and button is .sine, .cosine, or .tangent
            } else {
                displayInput.append(button.rawValue)
            }
        }

        switch button {
            
        case .add, .subtract, .mutliply, .divide, .sine, .cosine, .tangent, .equal:
            if button == .add {
                self.currentOperation = .add
                self.inputInt = Double(self.inputString) ?? 0
            }
            else if button == .subtract {
                self.currentOperation = .subtract
                self.inputInt = Double(self.inputString) ?? 0
            }
            else if button == .mutliply {
                self.currentOperation = .multiply
                self.inputInt = Double(self.inputString) ?? 0
            }
            else if button == .divide {
                self.currentOperation = .divide
                self.inputInt = Double(self.inputString) ?? 0
            }
            else if button == .sine {
                self.currentOperation = .sine
                self.inputInt = Double(self.inputString) ?? 0
            }
            else if button == .cosine {
                self.currentOperation = .cosine
                self.inputInt = Double(self.inputString) ?? 0
            }
            else if button == .tangent {
                self.currentOperation = .tangent
                self.inputInt = Double(self.inputString) ?? 0
            }
            else if button == .equal {
                let runningValue = self.inputInt
                let currentValue = Double(self.inputString) ?? 0
                
                switch self.currentOperation {
                case .add: self.inputString = "\(runningValue + currentValue)"
                case .subtract: self.inputString = "\(runningValue - currentValue)"
                case .multiply: self.inputString = "\(runningValue * currentValue)"
                case .divide: self.inputString = "\(runningValue / currentValue)"
                case .sine: self.inputString = sinCosTan(number: currentValue, sign: "sin")
                case .cosine: self.inputString = sinCosTan(number: currentValue, sign: "cos")
                case .tangent: self.inputString = sinCosTan(number: currentValue, sign: "tan")
                case .none:
                    break
                }
                    answer = inputString

            }

            if button != .equal {
                self.inputString = "0"
            }
        case .clear:
            self.inputString = "0"
            self.displayInput = ""
            self.answer = "0"

        default:
            let number = button.rawValue
            if self.inputString == "0" {
                inputString = number
            }
            else {
                self.inputString = "\(self.inputString)\(number)"
            }
        }
    }
    
    func sinCosTan(number: Double, sign: String) -> String {
        let doubleNum = Double(number)
        var calculate: Double = 0
        
        switch sign {
        case "sin":
            calculate = sin(doubleNum * Double.pi / 180)
        case "cos":
            calculate = cos(doubleNum * Double.pi / 180)
        case "tan":
            calculate = tan(doubleNum * Double.pi / 180)
        default:
            break
        }
        
        let result = String(format: "%.5f", calculate)
        return result
    }

func buttonWidth(item: AllButton) -> CGFloat {

    return (UIScreen.main.bounds.width - (5*12)) / 4
}

func buttonHeight() -> CGFloat {
    return (UIScreen.main.bounds.width - (5*12)) / 4
}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
