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
                if settingUp {
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
                

                    Button {
                        withAnimation {
                            calcAnswers()
                            settingUp.toggle()
                        }
                    } label: {
                        Text("Start")
                    }
                }
                
                Section {
                    if !settingUp {
                        Text("What is \(timesTable) x \(multiplier)")
                        
                        ForEach(ansArray, id: \.self) { num in
                            Button {
                                withAnimation {
                                    buttonTapped(num)
                                }
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
                .toolbar {
                    Button("End game", action: restart)
                }
            }
            .navigationTitle("Edutainment")
        }
    }
    
    func calcAnswers() {
        var tempMults = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        
        multiplier = tempMults.randomElement() ?? 1
        ans = timesTable * multiplier
        tempMults.remove(at: multiplier - 1)
        ansArray.append(ans)

        for _ in 1...3 {
            let dummyRand = tempMults.randomElement() ?? 1
            let newLoc = tempMults.firstIndex(of: dummyRand)
            
            tempMults.remove(at: newLoc ?? 0)
            ansArray.append(timesTable * dummyRand)
        }
        
        ansArray.shuffle()
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
