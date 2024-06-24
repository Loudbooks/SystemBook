import SwiftUI

struct ContentView: View {
    @State private var searchText = ""

    let exampleProcesses = [
        ProcessCardView(title: "Testing", description: "Descipriotn test", running: false, enabled: true, cpu: 10.1, memory: "10mb", runningTime: "10h"),
        ProcessCardView(title: "Huh", description: "aaa test", running: false, enabled: true, cpu: 10.1, memory: "10mb", runningTime: "10h"),
        ProcessCardView(title: "Another process", description: "asdasd test", running: false, enabled: true, cpu: 10.1, memory: "10mb", runningTime: "10h"),
        ProcessCardView(title: "Process", description: "Hello test", running: false, enabled: true, cpu: 10.1, memory: "10mb", runningTime: "10h"),
        ProcessCardView(title: "Process4", description: "Hello test", running: false, enabled: true, cpu: 10.1, memory: "10mb", runningTime: "10h"),
        ProcessCardView(title: "Process2", description: "Hello test", running: false, enabled: true, cpu: 10.1, memory: "10mb", runningTime: "10h"),
        ProcessCardView(title: "Process1", description: "Hello test", running: false, enabled: true, cpu: 10.1, memory: "10mb", runningTime: "10h"),
        ProcessCardView(title: "Process3", description: "Hello test", running: false, enabled: true, cpu: 10.1, memory: "10mb", runningTime: "10h")
    ]
    
    var filteredProcesses: [ProcessCardView] {
        if searchText.isEmpty {
            return exampleProcesses
        } else {
            return exampleProcesses.filter { $0.title.contains(searchText) || $0.description.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(filteredProcesses) { process in
                    process
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .padding(.vertical, 4)
                }
                .listRowSeparator(.hidden)
            }
            .searchable(text: $searchText, prompt: "Search processes")
            .navigationTitle("Processes")
        }
        .accentColor(.blue)
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
