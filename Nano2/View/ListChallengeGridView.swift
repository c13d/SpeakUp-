//
//  ListChallenge.swift
//  Nano2
//
//  Created by Christophorus Davin on 25/07/22.
//

import SwiftUI

struct ListChallengeGridView: View {
    private var data: [Int] = Array(1...30)
    private let colors: [Color] = [.red, .green, .blue, .yellow]
    
    private let addaptiveColumns = [
        GridItem(.adaptive(minimum: 75))
    ]
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: addaptiveColumns, spacing: 20){
                ForEach(data, id: \.self) {  number in
                    ZStack{
                        Rectangle()
                        .frame(width: 75, height: 75)
                        .foregroundColor(.yellow)
                        .cornerRadius(15)
                        
                        Image(systemName: "lock.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .shadow(radius: 5)
                            .padding(13)
                            .background(.white)
                            .clipShape(Circle())
                        
                        /*
                        Text("\(number)")
                            .foregroundColor(.white)
                            .font(.system(size: 30, weight: .medium, design: .rounded))
                         */
                    }
                }
            }
        }
    }
}

struct ListChallenge_Previews: PreviewProvider {
    static var previews: some View {
        ListChallengeGridView()
    }
}
