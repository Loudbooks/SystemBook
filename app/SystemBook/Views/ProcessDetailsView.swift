// ProcessDetailsView.swift created by Loudbook on 6/25/24.

import SwiftUI

struct ProcessDetailsView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isButtonTapped = false;
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0

    let process: Process;
    let console: String = """

asdasd

a
sd

"""
    
    private var backgroundColor: Color {
        if colorScheme == .dark {
            return Color(.secondarySystemGroupedBackground)
        } else {
            return .white
        }
    }
    
    var body: some View {
        VStack {
            HStack() {
                Text(process.title)
                    .font(Font.system(size: 35))
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .padding(.leading, 20)
                    .frame(maxHeight: 25)
                Ellipse()
                    .foregroundColor(.clear)
                    .frame(width: 10, height: 10)
                    .background(Color(red: 0.24, green: 0.82, blue: 0.03))
                    .cornerRadius(23)
                    .padding(.trailing, 20)
                    .offset(x: 0, y: 2)
                Spacer()
            }
            
            HStack {
                Text(process.description)
                    .font(.title3)
                    .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47))
                    .padding(.bottom, 10)
                Spacer()
            }
            .padding(.leading, 20)
            
            HStack(spacing: 22) {
                if process.running {
                    Button {} label: {
                        Text("Stop")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .pressEvents {
                        isButtonTapped = true
                        executeButtonHaptics()
                    } onRelease: {
                        isButtonTapped = false
                        executeButtonHaptics()
                    }
                } else {
                    Button {} label: {
                        Text("Start")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .pressEvents {
                        isButtonTapped = true
                        executeButtonHaptics()
                    } onRelease: {
                        isButtonTapped = false
                        executeButtonHaptics()
                    }
                }
                if process.enabled {
                    Button {} label: {
                        Text("Disable")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .pressEvents {
                        isButtonTapped = true
                        executeButtonHaptics()
                    } onRelease: {
                        isButtonTapped = false
                        executeButtonHaptics()
                    }
                } else {
                    Button {} label: {
                        Text("Enable")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .pressEvents {
                        isButtonTapped = true
                        executeButtonHaptics()
                    } onRelease: {
                        isButtonTapped = false
                        executeButtonHaptics()
                    }
                }
                
                Spacer()
            }
            .padding(.leading, 20)
            .frame(maxHeight: 10)
            
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .background(backgroundColor)
                    .cornerRadius(23)
                    .offset(x: 0, y: 0)
                    .shadow(
                        color: Color(red: 0, green: 0, blue: 0, opacity: 0.10), radius: 25.80
                    )
                    .padding(10)
                    .padding(.bottom, 0)
                    .padding(.top, 0)

                
                VStack {
                    HStack {
                        ScrollView {
                            Text(console)
                                .padding([.leading, .top], 0)
                                .multilineTextAlignment(.leading)
                                .font(Font.system(size: 7).monospaced())
                                .clipped()
                                .textSelection(.enabled)
                        }
                        .defaultScrollAnchor(.bottom)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .padding(30)
            }
            
            HStack(spacing: 110) {
                VStack (spacing: 2){
                    Image(systemName: "cpu")
                        .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47, opacity: 0.8))
                        .font(.title)
                    Text(process.cpu.description + "%")
                        .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47))
                        .font(.system(size: 15, weight: .regular, design: .default))
                        .bold()
                }
                
                VStack (spacing: 2){
                    Image(systemName: "memorychip")
                        .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47, opacity: 0.8))
                        .font(.title)
                    Text(process.memory)
                        .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47))
                        .font(.system(size: 15, weight: .regular, design: .default))
                        .bold()
                }
                
                VStack (spacing: 2){
                    Image(systemName: "timer")
                        .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47, opacity: 0.8))
                        .font(.title)
                    Text(process.runningTime)
                        .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47))
                        .font(.system(size: 15, weight: .regular, design: .default))
                        .bold()
                }
            }
            .padding(.bottom, 10)
        }
        .padding(.leading, 0)
    }
    
    func executeButtonHaptics() {
        if !isButtonTapped {
            let impactMed = UIImpactFeedbackGenerator(style: .rigid)
            impactMed.impactOccurred()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                impactMed.impactOccurred()
            })
        }
    }
}

#Preview {
    ProcessDetailsView(
        process:
            Process(title: "systemd-process", description: "Hello test", running: false, enabled: true, cpu: 10.1, memory: "10mb", runningTime: "10h")
    )
}
