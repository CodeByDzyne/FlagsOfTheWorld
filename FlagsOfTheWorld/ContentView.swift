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

// MARK: - --------------  Main View  ---------------

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "USA"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
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
                        Button {
                            flagTapped(choiceNum)
                        } label: {
                            FlagImage(img: countries[choiceNum])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
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
        //disable buttons
        if choice == correctAnswer {score += 1}
        
        //animate buttons
        
        //wait for animations to complete
        
        rounds += 1
        if rounds == 10 {
            showSummary = true
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            // enable buttons
        }
    }
    
    func resetGame () {
        rounds = 0
        score = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
