//
//  ContentView.swift
//  Edutainment
//
//  Created by Mitch on 10/17/22.
//

import SwiftUI

struct ContentView: View {
    @State private var gameOver = false
    @State private var settingUp = true
    
    @State private var timesTable = 2
    @State private var selectedNum = 5
    @State private var numQuestions = [5, 10, 20]
    
    @State private var ansArray: [Int] = []
    @State private var multiplier = 1
    
    @State private var score = 0
    @State private var round = 0
    @State private var ans = Int()
    
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Stepper("\(timesTable.formatted())", value: $timesTable, in: 2...12, step: 1)
                } header: {
                    Text("Select times tables to practice")
                }
                
                Section {
                    Picker("Question amount", selection: $selectedNum) {
                        ForEach(numQuestions, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("How many questions do you want?")
                }
                
                if settingUp {
                    Button {
                        calcAnswers()
                        settingUp.toggle()
                    } label: {
                        Text("Start")
                    }
                }
                
                Section {
                    if !settingUp {
                        Text("What is \(timesTable) x \(multiplier)")
                        
                        ForEach(ansArray, id: \.self) { num in
                            Button {
                                buttonTapped(num)
                            } label: {
                                Text("\(num)")
                            }
                            .alert("Game over!", isPresented: $gameOver) {
                                Button("New game", action: restart)
                            } message: {
                                Text("Score is \(score)/\(selectedNum)")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edutainment")
        }
    }
    
    func calcAnswers() {
        for _ in 1...4 {
            multiplier = Int.random(in: 1..<13)
            ans = timesTable * multiplier
            ansArray.append(ans)
            ansArray.shuffle()
        }
    }
    
    func buttonTapped(_ num: Int) {
        if round == selectedNum {
            gameOver = true
            return
        }
        if num == ans {
            score += 1
            round += 1
            ansArray.removeAll()
            calcAnswers()
        } else {
            round += 1
            ansArray.removeAll()
            calcAnswers()
        }
    }
    
    func restart() {
        score = 0
        round = 0
        ansArray.removeAll()
        settingUp.toggle()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
