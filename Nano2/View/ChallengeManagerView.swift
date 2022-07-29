//
//  CoreData.swift
//  Nano2
//
//  Created by Christophorus Davin on 26/07/22.
//

import SwiftUI
import CoreData


struct ChallengeManagerView: View {
    @StateObject var coreDataViewModel = CoreDataViewModel()
    @State var textFieldText: String = ""
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20){
                TextField("Add Challenge here...", text: $textFieldText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(height: 55)
                    .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button(action: {
                    guard !textFieldText.isEmpty else{ return }
                    coreDataViewModel.addChallenge(text: textFieldText)
                    textFieldText = ""
                }, label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .cornerRadius(10)
                })
                .padding(.horizontal)
                
                
                List{
                    
        
                    ForEach(coreDataViewModel.savedEntities){ entity in
                        Text(entity.text ?? "No Challenge")
                            .onTapGesture {
                                coreDataViewModel.updateChallenge(entity: entity)
                            }
                    }
                    .onDelete(perform: coreDataViewModel.deleteChallenge)
                }.listStyle(PlainListStyle())
            }
            .navigationBarTitle("List Challenge", displayMode: .inline)
            
            
            
        }
        
    }
}

struct CoreData_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeManagerView()
    }
}
