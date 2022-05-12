//
//  ContentView.swift
//  AnimationDemo
//
//  Created by Sebastian Strus on 2022-05-12.
//

import SwiftUI

struct ContentView: View {
    
    
    @State private var animationState: AnimationState = .stopped
    @State private var degrees = 0.0
    @State var timer = Timer.publish(every: 2, on: .main, in: .common)

    
    var body: some View {
        VStack(spacing: 20) {
            Image("climate")
                .resizable()
                .frame(width: 300, height: 300, alignment: .center)
                .rotationEffect(Angle.degrees(degrees))
                .onReceive(timer) { _ in
                    withAnimation(.linear(duration: 2)){
                        animationState = .running
                        self.degrees += 360
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.85) {
                        if (animationState == .stopped || animationState == .stopping) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                animationState = .stopped
                            }
                            withAnimation(.easeOut(duration: 4)) {
                                self.degrees += 360
                            }
                        }
                    }
                }
            Button("Toggle") {
                switch animationState {
                case .stopped:
                    animationState = .starting
                    withAnimation(.easeIn(duration: 4)) {
                        self.degrees += 360
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.88) {
                        timer = Timer.publish(every: 2, on: .main, in: .common)
                        _ = timer.connect()
                    }
                case .running:
                    timer.connect().cancel()
                    animationState = .stopping
                default:
                    print("Unknown state")
                }
            }
            .disabled(animationState == .starting || animationState == .stopping)
        }
    }
}

enum AnimationState {
    case stopped
    case starting
    case running
    case stopping
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ResetRect: View {
    @State private var sz: CGFloat = 80
    var body: some View {
        Rectangle().frame(width: sz, height: sz)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                    sz *= 2
                }
            }
    }
}
