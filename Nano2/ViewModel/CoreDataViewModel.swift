//
//  CoreDataViewModel.swift
//  Nano2
//
//  Created by Christophorus Davin on 26/07/22.
//

import SwiftUI
import CoreData

class CoreDataViewModel: ObservableObject{
    
    let container: NSPersistentContainer
    @Published var savedEntities: [ChallengeEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "ChallengeContainer")
        container.loadPersistentStores{ (description, error) in
            if let error = error {
                print("Error load core data. \(error)")
            }else{
                print("Successfully load core data ...")
            }
        }
        fetchChallenge()
        
        if(savedEntities.isEmpty){
            addSampleData()
        }
    }
    
    func addSampleData(){
        if savedEntities.isEmpty {
            for i in 1...10 {
                addChallenge(text: "Sample \(i)")
            }
        }
        
        fetchChallenge()
    }
    
    func fetchChallenge(){
        let request = NSFetchRequest<ChallengeEntity>(entityName: "ChallengeEntity")
        
        do{
           savedEntities = try container.viewContext.fetch(request)
        }catch let error{
            print("Error fetching. \(error)")
        }
    }
    
    func addChallenge(text: String){
        let newChallenge = ChallengeEntity(context: container.viewContext)
        newChallenge.id = UUID()
        newChallenge.text = text
        newChallenge.count = 0
        
        saveData()
    }
    
    func deleteChallenge(indexSet: IndexSet){
        guard let index = indexSet.first else { return }
        let entity = savedEntities[index]
        container.viewContext.delete(entity)
        
        saveData()
    }
    
    func updateChallenge(entity: ChallengeEntity){
        let currentText = entity.text ?? ""
        let newChallenge = currentText + "!"
        //entity.text = newChallenge
        entity.count += 1
        
        saveData()
    }
    
    func findChallenge(text: String) -> ChallengeEntity{
        for challenge in savedEntities{
            if(challenge.text == text){
                return challenge
            }
        }
        
        return savedEntities.first!
    }
    
    func addCount(text: String){
        let entity: ChallengeEntity = findChallenge(text: text)
        updateChallenge(entity: entity)
        print("\(entity.text) \(entity.count)")
    }
    

    
    func saveData(){
        do{
            try container.viewContext.save()
            fetchChallenge()
        }catch let error{
            print("Error save data \(error)")
        }
    }

    
}

