//
//  ContentView.swift
//  BabyColors WatchKit Extension
//
//  Created by Guillermo Moraleda on 16.11.20.
//

import SwiftUI

struct ViewItem: Identifiable {
    var id = UUID()
    var color = Color.random
}

class ListViewModel: ObservableObject {
    
    @Published var items = [ViewItem]()
    
    init() {
        reload()
    }
    
    func reload() {
        let intArray = [Int](repeating: 0, count: 50)
        items = intArray.map { _ in ViewItem() }
    }
}

let cellHeight: CGFloat = {
    WKInterfaceDevice.current().screenBounds.height / 2
}()



struct ContentView: View {
    @ObservedObject var viewModel = ListViewModel()
    
    var body: some View {
        List(){
            ForEach(viewModel.items) { item in
                Button (action: {
                    viewModel.reload()
                }) {
                    item.color.edgesIgnoringSafeArea(.all)
                }
            }
        }.environment(\.defaultMinListRowHeight, cellHeight)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
