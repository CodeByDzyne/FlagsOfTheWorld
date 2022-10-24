//
//  ContentView.swift
//  FlagsOfTheWorld
//
//  Created by Wealthy Waz on 22/10/2022.
//

import SwiftUI

// MARK: - --------------  Title Styling Modifier  ---------------

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.semibold))
            .foregroundColor(Color(red: 0.76, green: 0.15, blue: 0.26))
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

// MARK: - --------------  Flag View  ---------------

struct FlagImage: View {
    var img: String
    
    var body: some View {
        Image(img)
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10, x:5, y: 5)
    }
}

// MARK: - --------------  Correct Choice View  ---------------

struct CorrectAnswerView: View {
    var body: some View {
        Image(systemName: "checkmark.circle")
            .foregroundColor(.green)
            .font(.system(size: 72, weight: .bold))
            .background(Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.75))
            .clipShape(Circle())
    }
}

// MARK: - --------------  Wrong Choice View  ---------------

struct WrongAnswerView: View {
    let country: String
    
    var body: some View {
        Text(country)
            .foregroundColor(.red)
            .font(.title2.bold())
            .padding(10)
            .background(Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.85))
            .clipShape(Capsule())
    }
}


// MARK: - --------------  Main View  ---------------

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "USA"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var selectedFlag = -1
    @State private var btnsDisabled = false
    
    @State private var rounds = 0
    @State private var score = 0
    @State private var showSummary = false

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red:0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess The Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 30) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                            .padding(.bottom, 1)
                        Text(countries[correctAnswer])
                            .titleStyle()
                    }
                    
                    ForEach(0..<3) {choiceNum in
                        ZStack {
                            Button {
                                flagTapped(choiceNum)
                            } label: {
                                FlagImage(img: countries[choiceNum])
                            }
                            .disabled(btnsDisabled)
                            .rotation3DEffect(.degrees(selectedFlag == choiceNum ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                            .scaleEffect((selectedFlag == -1)  ? 1 : ((selectedFlag == choiceNum) ? 1.1 : 0.75))
                            .opacity(((selectedFlag == choiceNum) || (selectedFlag == -1))  ? 1 : 0.5)
                            .animation(.default, value: countries[choiceNum])
                            
                            // TODO: not reflecting correct answer - need to check logic
                            if selectedFlag == choiceNum {
                                if choiceNum == correctAnswer {
                                    CorrectAnswerView()
                                        .transition(.asymmetric(
                                            insertion: .scale.animation(.default),
                                            removal: .opacity.animation(.default)))
                                } else {
                                    WrongAnswerView(country: countries[choiceNum])
                                        .transition(.asymmetric(
                                            insertion: .scale.animation(.default),
                                            removal: .opacity.animation(.default)))
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert("Game Over", isPresented: $showSummary) {
            Button("Play Again", action: resetGame)
        } message: {
            Text("You guessed \(score) flags right out of 10")
        }
    }
    
    func flagTapped(_ choice: Int) {
        btnsDisabled = true
        
        if choice == correctAnswer {score += 1}
        withAnimation {
            selectedFlag = choice
        }
        
        //wait for animations to complete then move to next round
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            rounds += 1
            if rounds == 10 {
                showSummary = true
            } else {
                countries.shuffle()
                correctAnswer = Int.random(in: 0...2)
                withAnimation {
                    selectedFlag = -1
                }
                btnsDisabled = false
            }
        }
        
    }
    
    func resetGame () {
        rounds = 0
        score = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        withAnimation {
            selectedFlag = -1
        }
        btnsDisabled = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
