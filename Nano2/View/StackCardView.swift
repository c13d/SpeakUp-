//
//  StackCardView.swift
//  Nano2
//
//  Created by Christophorus Davin on 25/07/22.
//

import SwiftUI

struct StackCardView: View {
    
    @EnvironmentObject var homeData: HomeViewModel
    var challenge: Challenge
    
    // Gesture
    @State var offset: CGFloat = 0
    @GestureState var isDragging: Bool = false
    @Binding var geser: Int
    @State var endSwipe: Bool = false
    
    @State var colors: [Color] = [.red, .blue, .yellow, .cyan, .brown]
    
    var body: some View {
        
        GeometryReader{proxy in
            let size = proxy.size
            
            let index = CGFloat(homeData.getIndex(challenge: challenge))
            let topOffset = (index <= 2 ? index : 2) * 15
            
            ZStack{
                
                Text("\(challenge.text)")
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width - topOffset,  height: size.height)
                    .background(LinearGradient(gradient: Gradient(colors: [colors[1], colors[2]]), startPoint: .top, endPoint: .bottom))
                    //.border(.black)
                    .cornerRadius(15)
                    .offset(y: -topOffset)
                    .offset(x: topOffset/2)
                
            }
            
            //.frame(width: .infinity, height: .infinity, alignment: .center)
        }
        .offset(x: offset)
        .rotationEffect(.init(degrees: getRotation(angle: 8)))
        .contentShape(Rectangle().trim(from: 0, to: endSwipe ? 0 : 1))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .gesture(
            DragGesture()
                .updating($isDragging, body: {value, out, _ in
                    out = true
                })
                .onChanged({value in
                    let translation = value.translation.width
                    offset = (isDragging ? translation: .zero)
                    
                    geser = Int(translation)
                })
                .onEnded({value in
                    
                    geser = 0
                    let width = getRect().width - 50
                    let translation = value.translation.width
                    
                    let checkingStatus = (translation > 0 ? translation : -translation)
                    
                    withAnimation{
                        if checkingStatus > (width / 2){
                            // remove card
                            offset = (translation > 0 ? width : -width) * 2
                            // endSwipe = true
                            endSwipeActions()
                            
                            if translation > 0 {
                                rightSwipe()
                            }else{
                                leftSwipe()
                            }
                        }
                        else{
                            // reset
                            offset = .zero
                        }
                    }
                })
        )
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("Swipe"), object: nil)){
            data in
            
            guard let info = data.userInfo else{
                return
            }
            
            let id = info["id"] as? String ?? ""
            let rightSwipe = info["rightSwipe"] as? Bool ??
                false
            let width = getRect().width - 50
            
            if challenge.id == id{
                // remove card
                
                withAnimation{
                    offset = (rightSwipe ? width : -width) * 2
                    endSwipeActions()
                    
                    if rightSwipe{
                        self.rightSwipe()
                    }else{
                        leftSwipe()
                    }
                }
            }
        }
    }
    
    func restoreCard(){
        //let currentCard = homeData.displaying_challenges.first
        //homeData.displaying_challenges!.append(currentCard!)
        
        homeData.addRandomChallenge()
        //homeData.displaying_challenges.append(Challenge(text: currentCard!.text, count: currentCard!.count))
        
    }
    
    
    func getRotation(angle: Double) -> Double{
        let rotation = (offset / (getRect().width - 50)) * angle
        return rotation
    }
    
    func endSwipeActions(){
        withAnimation(.none){endSwipe = true}
        
        restoreCard()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            if let _ = homeData.displaying_challenges.first{
                
                
                let _ = withAnimation{
                    homeData.displaying_challenges.removeFirst()
                }
                
            }
        }
    }
    
    func leftSwipe(){
         print("Left")
    }
    
    func rightSwipe(){
        print("Right")
    }
}

struct StackCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}
