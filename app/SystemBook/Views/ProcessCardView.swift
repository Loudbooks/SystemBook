// ProcessCardView.swift created by Loudbook on 6/22/24.

import SwiftUI

struct ProcessCardView: View {
    let process: Process;
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(Favorites.self) var favorites
        
    private var backgroundColor: Color {
        return Color(.secondarySystemGroupedBackground)
//        if colorScheme == .dark {
//            return Color(.secondarySystemGroupedBackground)
//        } else {
//            return .white
//        }
    }
    
    var body: some View {
        ZStack() {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 360, height: 116)
                .background(backgroundColor)
                .cornerRadius(25)
                .offset(x: 0, y: 0)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.10), radius: 25.80
                )
            
            VStack(alignment: .leading) {
                HStack {
                    Text(process.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Ellipse()
                        .foregroundColor(.clear)
                        .frame(width: 6, height: 6)
                        .background(process.running ? Color(red: 0.24, green: 0.82, blue: 0.03) : .red)
                        .cornerRadius(23)
                        
                    Spacer()
                    Button {
                        if favorites.contains(id: process.name) {
                            withAnimation {
                                favorites.remove(id: process.name)
                            }
                        } else {
                            withAnimation {
                                favorites.add(id: process.name)
                            }
                        }
                        
                        let impactMed = UIImpactFeedbackGenerator(style: .light)
                        impactMed.impactOccurred()
                        
                    } label: {
                        let glyph = favorites.contains(id: process.name) ? "star.fill" : "star"
                        
                        Image(systemName: glyph)
                            .padding(.trailing, 40)
                            .symbolRenderingMode(favorites.contains(id: process.name) ? .multicolor : .monochrome)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                    }
                }
                .padding(.leading, 40)
                .padding(.top, 17)
                
                HStack {
                    Text(process.description)
                        .font(.caption2)
                        .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47))
                        .multilineTextAlignment(.leading)
                }.padding([.leading, .trailing], 40)
                
                Spacer()
                
                HStack() {
                    HStack(spacing: 15) {
                        HStack (spacing: 2){
                            Image(systemName: "cpu")
                                .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47, opacity: 0.8))
                                .font(.caption2)
                            Text(process.cpu)
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
                            Text(process.time)
                                .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47))
                                .font(.system(size: 9, weight: .regular, design: .default))
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 18) {
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
                    }.padding(.trailing, 40)
                }
                .padding(.leading, 40)
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
                        Process(name: "Process", description: "Hello test", running: false, enabled: true, cpu: "10m, 38s", memory: "625.6M", time: "6d, 21h"))
    .environment(Favorites())
}
