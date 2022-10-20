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
        ZStack {
            Image("mountains")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: UIScreen.main.bounds.width,
                       maxHeight: UIScreen.main.bounds.height)
            VStack(spacing: 50) {
                if settingUp {
                    VStack {
                        Spacer()
                        Text("Multiplication Practice")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                            
                        Spacer()
                        Spacer()
                        Text("Select times tables to practice")
                            .font(.title2)
                        Stepper("\(timesTable.formatted())", value: $timesTable, in: 2...12, step: 1)
                    }
                    
                    VStack {
                        Spacer()
                        Text("How many questions do you want?")
                            .font(.title2)
                        Picker("Question amount", selection: $selectedNum) {
                            ForEach(numQuestions, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                        .colorMultiply(selectedNum == 5 ? .green : .green)
                        Spacer()
                    }
                
                    Button {
                        withAnimation {
                            calcAnswers()
                            settingUp.toggle()
                        }
                    } label: {
                        Text("Start")
                            .font(.headline)
                            .frame(width: 100, height: 50)
                            .foregroundColor(Color.white)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    Spacer()
                }
                
                VStack {
                    if !settingUp {
                        Spacer()
                        Spacer()
                        Text("What is \(timesTable) x \(multiplier)?")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Spacer()
                        HStack(spacing: 35) {
                            ForEach(ansArray, id: \.self) { num in
                                Button {
                                    withAnimation {
                                        buttonTapped(num)
                                    }
                                } label: {
                                    Text("\(num)")
                                        .font(.headline)
                                        .frame(width: 65, height: 65)
                                        .foregroundColor(Color.black)
                                        .background(Color.green)
                                        .clipShape(Circle())
                                }
                                .alert("Game over!", isPresented: $gameOver) {
                                    withAnimation {
                                        Button("New game", action: restart)
                                    }
                                } message: {
                                    Text("Score is \(score)/\(selectedNum)")
                                }
                            }
                        }
                        HStack(spacing: 30) {
                            Image("rabbit")
                                .resizable()
                                .frame(width: 70, height: 70)
                            Image("owl")
                                .resizable()
                                .frame(width: 70, height: 70)
                            Image("duck")
                                .resizable()
                                .frame(width: 70, height: 70)
                            Image("buffalo")
                                .resizable()
                                .frame(width: 70, height: 70)
                        }
                        Spacer()
                        Button("End game", action: restart)
                            .font(.headline)
                            .frame(width: 100, height: 50)
                            .foregroundColor(Color.white)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 20)
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
        withAnimation {
            settingUp.toggle()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
