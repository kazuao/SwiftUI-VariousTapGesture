//
//  ContentView.swift
//  FingerGesture
//
//  Created by kazunori.aoki on 2022/07/14.
//

import SwiftUI

struct Map {
    var location: CGPoint?
    var offset: CGSize = .zero
    var newOffset: CGSize = .zero
    var lastScale: CGFloat = 1.0
    var scale: CGFloat = 1.0 // ここを変更すると初期表示のサイズを変えられる
}

struct ContentView: View {

    @State private var model: Map = .init()

    @State private var aTap: Bool = false
    @State private var bTap: Bool = false

    var topRight: CGPoint {
        return .init(x: UIScreen.main.bounds.maxX, y: 0)
    }

    var body: some View {

        VStack(spacing: 20) {
            // MARK: Double taps
            Rectangle()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(.green)
                .onTapGesture(count: 2) {
                    print("double taps")
                }

            // MARK: Double finger taps
            Rectangle()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(.red)
                .overlay(
                    MultipleFingerTapView(fingers: 2) { _ in
                        print("two finger tap")
                    }
                )

            // MARK: Long tap
            Rectangle()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(.gray)
                .onLongPressGesture(minimumDuration: 3) {
                    print("on long tap")
                } onPressingChanged: { bool in
                    print(bool ? "tap now" : "tap was")
                }

            // MARK: Sync tap
            HStack {
                Rectangle()
                    .frame(width: 100, height: 100, alignment: .center)
                    .foregroundColor(.orange)
                    .onLongPressGesture(minimumDuration: 1) {
                        print("a long tap")
                    } onPressingChanged: { bool in
                        print("a tap: \(bool)")
                        aTap = bool

                        syncTap()
                    }

                Spacer()

                Rectangle()
                    .frame(width: 100, height: 100, alignment: .center)
                    .foregroundColor(.pink)
                    .onLongPressGesture(minimumDuration: 1) {
                        print("b long tap")
                    } onPressingChanged: { bool in
                        print("b tap: \(bool)")
                        bTap = bool

                        syncTap()
                    }
            }
            .padding()


            // MARK: 右上にドラッグ
            Color.clear.contentShape(Rectangle())
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(.clear)
                .offset(x: model.offset.width, y: model.offset.height)
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .global)
                        .onChanged { value in
                            model.offset.width  = value.translation.width  + model.newOffset.width
                            model.offset.height = value.translation.height + model.newOffset.height
                        }
                        .onEnded { value in
                            calcTapArea(point: CGPoint(x: value.location.x, y: value.location.y))

                            model.offset.width = 0
                            model.offset.height = 0
                        }
                )
        }
    }

    // 指定の位置にドラッグしたら処理
    func calcTapArea(point: CGPoint) {
        print(point)
        if case (314...414, 0...100) = (point.x, point.y) {
            print("ここ")
        } else {
            print("ちがう")
        }
    }

    func syncTap() {
        print("sync")
        if aTap, bTap {
            print("sync tap!!!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
