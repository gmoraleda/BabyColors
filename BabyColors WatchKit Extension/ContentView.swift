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
        .focusable(true)
        .digitalCrownRotation($crownRotation, from: 1, through: 5, by: 0.1, sensitivity: .low, isContinuous: true, isHapticFeedbackEnabled: true)
        .onChange(of: crownRotation) { value in

            var calculatedHeight: CGFloat = 0.0

            print("Height \(calculatedHeight)")
            print("Delta \(crownRotationDelta)")
            print("Value \(value)")

            
            if value > crownRotationDelta {
                calculatedHeight = cellHeight + 1
                cellHeight = min(WKInterfaceDevice.current().screenBounds.height, calculatedHeight)

            } else {
                calculatedHeight = cellHeight - 1
                cellHeight = max(WKInterfaceDevice.current().screenBounds.height / 2, calculatedHeight)
            }
            
            crownRotationDelta = value

        }
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
        let range = [UInt32](0x1F601 ... 0x1F64F)
        let ascii = range[Int(drand48() * Double(range.count))]
        let emoji = UnicodeScalar(ascii)?.description
        return emoji!
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
