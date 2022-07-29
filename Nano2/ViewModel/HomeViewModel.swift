//
//  HomeViewModel.swift
//  Nano2
//
//  Created by Christophorus Davin on 25/07/22.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var displaying_challenges: [Challenge] = []
    @StateObject var coreDataViewModel = CoreDataViewModel()
    
    init(){
        
        if coreDataViewModel.savedEntities.isEmpty == false
        {
            coreDataViewModel.addChallenge(text: "Say hello to your team member")
            for _ in 1...coreDataViewModel.savedEntities.count {
                addRandomChallenge()
            }
        }
        
        
    }
    
    func addRandomChallenge(){
        let randomInt = Int.random(in: 0..<coreDataViewModel.savedEntities.count)
        let challenge = coreDataViewModel.savedEntities[randomInt]
        displaying_challenges.append(Challenge(text: challenge.text!, count: Int(challenge.count)))
        
    }
    
    func getIndex(challenge: Challenge)->Int{
        
        let index = displaying_challenges.firstIndex(where: {currentChallenge in
            return challenge.id == currentChallenge.id
        }) ?? 0
        
        return index 
    }
    
    
}

