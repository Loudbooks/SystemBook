// ProcessCardView.swift created by Loudbook on 6/22/24.

import SwiftUI

struct ProcessCardView: View {
    let process: Process;
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(Favorites.self) var favorites
    
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
                    Spacer()
                    Button {
                        if favorites.contains(id: process.title) {
                            favorites.remove(id: process.title)
                        } else {
                            favorites.add(id: process.title)
                        }
                        
                        executeButtonHaptics()
                    } label: {
                        let glyph = favorites.contains(id: process.title) ? "star.fill" : "star"
                        
                        Image(systemName: glyph)
                            .padding(.trailing, 30)
                            .symbolRenderingMode(favorites.contains(id: process.title) ? .multicolor : .monochrome)
                            .foregroundStyle(.black)
                    }
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
                            Button {
                                executeButtonHaptics()
                            } label: {
                                Text("Disable")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                        } else {
                            Button {
                                executeButtonHaptics()
                            } label: {
                                Text("Enable")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                        }
                        
                        if process.running {
                            Button {
                                executeButtonHaptics()
                            } label: {
                                Text("Stop")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                        } else {
                            Button {
                                executeButtonHaptics()
                            } label: {
                                Text("Start")
                                    .font(.caption)
                                    .fontWeight(.bold)
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
    }
    
    func executeButtonHaptics() {
        let impactMed = UIImpactFeedbackGenerator(style: .rigid)
        impactMed.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            impactMed.impactOccurred()
        })
    }
}

#Preview {
    ProcessCardView(process:
                        Process(title: "Process", description: "Hello test", running: false, enabled: true, cpu: 10.1, memory: "10mb", runningTime: "10h"))
    .environment(Favorites())
}
