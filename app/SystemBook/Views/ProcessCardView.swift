// ProcessCardView.swift created by Loudbook on 6/22/24.

import SwiftUI

struct ProcessCardView: View {
    let process: Process;
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isButtonTapped = false;
    
    private var backgroundColor: Color {
        if colorScheme == .dark {
            return Color(.secondarySystemGroupedBackground)
        } else {
            return .white
        }
    }
    
    var body: some View {
        ZStack() {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 372, height: 116)
                .background(backgroundColor)
                .cornerRadius(23)
                .offset(x: 0, y: 0)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.10), radius: 25.80
                )
            
            VStack(alignment: .leading) {
                HStack {
                    Text(process.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Ellipse()
                        .foregroundColor(.clear)
                        .frame(width: 6, height: 6)
                        .background(Color(red: 0.24, green: 0.82, blue: 0.03))
                        .cornerRadius(23)
                        .padding(.trailing, 30)
                }
                .padding(.leading, 30)
                .padding(.top, 17)
                
                HStack {
                    Text(process.description)
                        .font(.caption2)
                        .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47))
                }.padding(.leading, 30)
                
                Spacer()
                
                HStack(spacing: 20) {
                    HStack (spacing: 2){
                        Image(systemName: "cpu")
                            .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47, opacity: 0.8))
                            .font(.caption2)
                        Text(process.cpu.description + "%")
                            .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47))
                            .font(.system(size: 9, weight: .regular, design: .default))
                    }
                    
                    HStack (spacing: 2){
                        Image(systemName: "memorychip")
                            .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47, opacity: 0.8))
                            .font(.caption2)
                        Text(process.memory)
                            .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47))
                            .font(.system(size: 9, weight: .regular, design: .default))
                    }
                    
                    HStack (spacing: 2){
                        Image(systemName: "timer")
                            .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47, opacity: 0.8))
                            .font(.caption2)
                        Text(process.runningTime)
                            .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47))
                            .font(.system(size: 9, weight: .regular, design: .default))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 22) {
                        if process.enabled {
                            Button {} label: {
                                Text("Disable")
                                    .font(.caption)
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
                                    .font(.caption)
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
                        
                        if process.running {
                            Button {} label: {
                                Text("Stop")
                                    .font(.caption)
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
                                    .font(.caption)
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
                    }.padding(.trailing, 30)
                }
                .padding(.leading, 30)
                .padding(.bottom, 17)
            }
            .padding([.top, .leading], 0)
            .frame(maxHeight: 116)
        }
        .pressEvents {
            if !isButtonTapped {
                let impactMed = UIImpactFeedbackGenerator(style: .soft)
                impactMed.impactOccurred()
            }
        } onRelease: {
        }
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
    ProcessCardView(process:
                        Process(title: "Process", description: "Hello test", running: false, enabled: true, cpu: 10.1, memory: "10mb", runningTime: "10h"))
}
