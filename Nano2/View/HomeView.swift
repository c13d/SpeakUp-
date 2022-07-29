//
//  Home.swift
//  Nano2
//
//  Created by Christophorus Davin on 22/07/22.
//

import SwiftUI
import UIKit


struct Triangle: Shape{
    func path(in rect: CGRect) -> Path {
        Path {path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        }
    }
}


struct HomeView: View {
    @StateObject var homeData: HomeViewModel = HomeViewModel()
    @State var geser: Int = 0
    
    
    var body: some View {
        
        NavigationView{
            
            ZStack(alignment: .leading){
                //Color(.red).opacity(0.6)
                

                
                VStack{
                    // User Stack
                    ZStack{
                               
                        if let challenges = homeData.displaying_challenges{
                            if challenges.isEmpty{
                                Text("Mantap Kelar").font(.caption).foregroundColor(.gray)
                            }else{
                                
                                // atur challenge nya disini (bikin logic random aja)
                                                            
                                ForEach(challenges.reversed()){ challenge in
                                    // Card View
                                    StackCardView(challenge: challenge, geser: $geser)
                                        .environmentObject(homeData)
                                }
                                
                            }
                            
                        }
                        
                        

                    }
                    .padding(.top, 30)
                    .padding()
                    .padding(.vertical)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // Action Button
                    HStack(spacing: 15){
                       
                        Button{
                            doSwipe()
                        }label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                                .padding(13)
                                .background(.red)
                                .clipShape(Circle())
                        }
            
                        Button{
                            doSwipe(rightSwipe: true)
                        }label: {
                            Image(systemName: "checkmark")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                                .padding(13)
                                .background(.blue)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.bottom)
                    .disabled(homeData.displaying_challenges.isEmpty ?? false)
                    .opacity((homeData.displaying_challenges.isEmpty ?? false) ? 0.6 : 1)
                    
                }
                
                
                Ellipse()
                    .trim(from: 0, to: 0.5)
                    .fill(.blue)
                    .scaleEffect(CGSize(width: 3, height: 1))
                    .rotationEffect(.degrees(90))
                    .offset(x: UIScreen.main.bounds.width)
                    .opacity(Double(geser)/500)
                
//                    .overlay(
//                        Text("\(Double(geser)/250) + overlay")
//                    )
                
//                    .fill(LinearGradient(gradient: Gradient(colors: [Color.red, Color.red
//                                                                    ]), startPoint: .leading, endPoint: .trailing)).ignoresSafeArea()
                
                Ellipse()
                    .trim(from: 0, to: 0.5)
                    .fill(.red)
                    .scaleEffect(CGSize(width: 3, height: 1))
                    .rotationEffect(.degrees(-90))
                    .offset(x: -UIScreen.main.bounds.width)
                    .opacity(-Double(geser)/500)
                

 
                    
                    
                    
                    
//                Triangle()
//                    .trim(from: 0, to: 0.5)
//                    .fill(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
//                    .frame(width: 300, height: 300)
                
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            .navigationBarTitle("Challenge", displayMode: .inline)
            
            .navigationBarItems(
                trailing:
                    HStack{
                        
                        NavigationLink(destination: ListChallengeGridView()){
                                Image(systemName: "star")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 22, height: 22)
                        }
                        
                        NavigationLink(destination: ChallengeManagerView()){
                                Image(systemName: "plus.square.on.square")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 22, height: 22)
                        }
                        
                        
                    }
            )
        }

        
        
    }
        
    
    func doSwipe(rightSwipe: Bool = false){
        guard let first = homeData.displaying_challenges.first else{
            return
        }
        
        // Using notification
        NotificationCenter.default.post(name: NSNotification.Name("Swipe"), object: nil,
            userInfo: [
            "id": first.id,
            "rightSwipe": rightSwipe
        ])
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
