// ContentView.swift created by Loudbook on 6/19/24.

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""

    let exampleProcesses = [
        Process(title: "Testing", description: "Descipriotn test", running: false, enabled: true, cpu: 10.1, memory: "10mb", runningTime: "10h"),
        Process(title: "Huh", description: "aaa test", running: false, enabled: true, cpu: 10.1, memory: "10mb", runningTime: "10h"),
        Process(title: "Another process", description: "asdasd test", running: false, enabled: true, cpu: 10.1, memory: "10mb", runningTime: "10h"),
        Process(title: "Process", description: "Hello test", running: false, enabled: true, cpu: 10.1, memory: "10mb", runningTime: "10h"),
        Process(title: "Process4", description: "Hello test", running: false, enabled: true, cpu: 10.1, memory: "10mb", runningTime: "10h"),
        Process(title: "Process2", description: "Hello test", running: false, enabled: true, cpu: 10.1, memory: "10mb", runningTime: "10h"),
        Process(title: "Process1", description: "Hello test", running: false, enabled: true, cpu: 10.1, memory: "10mb", runningTime: "10h"),
        Process(title: "Process3", description: "Hello test", running: false, enabled: true, cpu: 10.1, memory: "10mb", runningTime: "10h")
    ]
    
    var filteredProcesses: [Process] {
        if searchText.isEmpty {
            return exampleProcesses
        } else {
            return exampleProcesses.filter { $0.title.contains(searchText) || $0.description.contains(searchText) }
        }
    }
    
    var body: some View {
//        NavigationStack {
//            ScrollView {
//                ForEach(filteredProcesses) { process in
//                    ProcessCardView(process: process)
//                        .listRowInsets(EdgeInsets())
//                        .listRowBackground(Color.clear)
//                        .padding(.vertical, 4)
//                }
//                .listRowSeparator(.hidden)
//            }
//            .searchable(text: $searchText, prompt: "Search processes")
//            .navigationTitle("Processes")
//        }
//        .accentColor(.blue)
        
        ProcessDetailsView(process: exampleProcesses[0])
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
