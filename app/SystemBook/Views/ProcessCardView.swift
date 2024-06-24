import SwiftUI

struct ProcessCardView: View, Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let running: Bool
    let enabled: Bool
    let cpu: Double
    let memory: String
    let runningTime: String
    
    var body: some View {
        ZStack() {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 372, height: 116)
                .background(.white)
                .cornerRadius(23)
                .offset(x: 0, y: 0)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.10), radius: 25.80
                )
            
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Ellipse()
                        .foregroundColor(.clear)
                        .frame(width: 6, height: 6)
                        .background(Color(red: 0.24, green: 0.82, blue: 0.03))
                        .cornerRadius(23)
                        .offset(x: 0, y: 3)
                        .padding(.trailing, 30)
                }
                .padding(.leading, 30)
                .padding(.top, 17)
                
                HStack {
                    Text(description)
                        .font(.caption2)
                        .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47))
                }.padding(.leading, 30)
                
                Spacer()
                
                HStack(spacing: 20) {
                    HStack (spacing: 2){
                        Image(systemName: "cpu")
                            .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47, opacity: 0.8))
                            .font(.caption2)
                        Text(cpu.description + "%")
                            .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47))
                            .font(.system(size: 9, weight: .regular, design: .default))
                    }
                                        
                    HStack (spacing: 2){
                        Image(systemName: "memorychip")
                            .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47, opacity: 0.8))
                            .font(.caption2)
                        Text(memory)
                            .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47))
                            .font(.system(size: 9, weight: .regular, design: .default))
                    }
                    
                    HStack (spacing: 2){
                        Image(systemName: "timer")
                            .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47, opacity: 0.8))
                            .font(.caption2)
                        Text(runningTime)
                            .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47))
                            .font(.system(size: 9, weight: .regular, design: .default))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 22) {
                        if enabled {
                            Button {
                                
                            } label: {
                                Text("Disable")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                        } else {
                            Button {
                                
                            } label: {
                                Text("Enable")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                        }
                        
                        if running {
                            Button {
                                
                            } label: {
                                Text("Stop")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                        } else {
                            Button {
                                
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
}

#Preview {
    ProcessCardView(title: "Process", description: "Hello test", running: false, enabled: true, cpu: 10.1, memory: "10mb", runningTime: "10h")
}
