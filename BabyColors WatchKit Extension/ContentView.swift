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

struct ContentView: View {
    @State var crownRotation = 0.0
    @State var crownRotationDelta = 0.0
    @State var rotationDelta = 0.0
    @State var cellHeight = WKInterfaceDevice.current().screenBounds.height / 2
    @State var isEmojiVisible = true
    @ObservedObject var viewModel = ListViewModel()

    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                ZStack {
                    Button(action: {
                        viewModel.reload()
                        isEmojiVisible.toggle()
                    }) {
                        item.color.edgesIgnoringSafeArea(.all)
                    }
                    Text(isEmojiVisible ? String.randomEmoji : "").font(.title)
                }.listRowInsets(EdgeInsets())
            }
        }
        .environment(\.defaultMinListRowHeight, cellHeight)
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0 ... 1),
            green: .random(in: 0 ... 1),
            blue: .random(in: 0 ... 1)
        )
    }
}

extension String {
    static var randomEmoji: String {
        let range = 0x1F300 ... 0x1F3F0
        let index = Int(arc4random_uniform(UInt32(range.count)))
        let ord = range.lowerBound + index
        guard let scalar = UnicodeScalar(ord) else { return "❓" }
        return String(scalar)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
