// ContentView.swift created by Loudbook on 6/19/24.

import SwiftUI

struct ContentView: View {
    @State private var favorites = Favorites()
    
    @State private var searchText = ""
    
    @StateObject private var websocketManager = WebsocketManager(address: "")


    var filteredProcesses: [Process] {
        let array = if searchText.isEmpty {
            websocketManager.processes
        } else {
            websocketManager.processes.filter { $0.name.contains(searchText) || $0.description.contains(searchText) }
        }
        
        return array.sorted() { $0.name.lowercased() < $1.name.lowercased()}
    }
        
    
    var body: some View {
        if websocketManager.isLoading {
            withAnimation {
                LoadingView(reason: "processses")
            }
        } else {
            NavigationStack {
                ScrollView {
                    let filteredFavorites = filteredProcesses.filter({ favorites.contains(id: $0.name) })
                    LazyVStack(alignment: .leading) {
                        ForEach(filteredFavorites) { process in
                            NavigationLink(destination: ProcessDetailsView(process: process)) {
                                ProcessCardView(process: process)
                                    .listRowInsets(EdgeInsets())
                                    .listRowBackground(Color.clear)
                                    .padding(.vertical, 4)
                                    .environment(favorites)
                            }
                        }
                        .listRowSeparator(.hidden)
                        
                        if filteredFavorites.count > 0 {
                            Divider().zIndex(-1)
                        }
                        
                        let unfavorated = filteredProcesses.filter({ !favorites.contains(id: $0.name) })
                        
                        withAnimation {
                            ForEach(unfavorated) { process in
                                NavigationLink(destination: ProcessDetailsView(process: process)) {
                                    ProcessCardView(process: process)
                                        .listRowInsets(EdgeInsets())
                                        .listRowBackground(Color.clear)
                                        .padding(.vertical, 4)
                                        .environment(favorites)
                                }
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search processes")
                .navigationTitle("Processes")
                .refreshable {
                    await websocketManager.requestProcesses()
                }
                .transition(.opacity)
            }
            .accentColor(.blue)
        }
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
