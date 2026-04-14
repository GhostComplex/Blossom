//
//  DragWheelColumn.swift
//  Blossom (拾月)
//
//  Reusable drag-based wheel picker column.
//  Extracted from OnboardingView for shared use.
//

import SwiftUI

struct DragWheelColumn: View {
    let items: [String]
    @Binding var selectedIndex: Int

    private let rowHeight: CGFloat = 40
    @State private var dragOffset: CGFloat = 0

    private var prevIndex: Int? {
        selectedIndex > 0 ? selectedIndex - 1 : nil
    }

    private var nextIndex: Int? {
        selectedIndex < items.count - 1 ? selectedIndex + 1 : nil
    }

    var body: some View {
        VStack(spacing: 0) {
            // Previous row
            Text(prevIndex != nil ? items[prevIndex!] : "")
                .font(.system(size: 14))
                .foregroundStyle(Color.n300.opacity(0.25))
                .frame(maxWidth: .infinity)
                .frame(height: rowHeight)

            // Selected row
            Text(items[selectedIndex])
                .font(.custom("NotoSerifSC-Regular", size: 22))
                .foregroundStyle(Color(hex: "A87CC0"))
                .frame(maxWidth: .infinity)
                .frame(height: rowHeight)

            // Next row
            Text(nextIndex != nil ? items[nextIndex!] : "")
                .font(.system(size: 14))
                .foregroundStyle(Color.n300.opacity(0.25))
                .frame(maxWidth: .infinity)
                .frame(height: rowHeight)
        }
        .offset(y: dragOffset)
        .frame(height: 120, alignment: .center)
        .clipped()
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation.height
                }
                .onEnded { value in
                    let threshold: CGFloat = rowHeight / 3
                    withAnimation(.easeOut(duration: 0.2)) {
                        if value.translation.height > threshold && selectedIndex > 0 {
                            selectedIndex -= 1
                        } else if value.translation.height < -threshold && selectedIndex < items.count - 1 {
                            selectedIndex += 1
                        }
                        dragOffset = 0
                    }
                }
        )
    }
}
