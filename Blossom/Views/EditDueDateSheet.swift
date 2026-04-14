//
//  EditDueDateSheet.swift
//  Blossom (拾月)
//
//  修改预产期 bottom sheet (Issue #166)
//

import SwiftUI
import SwiftData

struct EditDueDateSheet: View {
    let profile: UserProfile
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var selectedYear: Int
    @State private var selectedMonth: Int
    @State private var selectedDay: Int

    private let years: [Int]
    private let months = Array(1...12)

    private var days: [Int] {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = selectedYear
        components.month = selectedMonth
        if let date = calendar.date(from: components),
           let range = calendar.range(of: .day, in: .month, for: date) {
            return Array(range)
        }
        return Array(1...31)
    }

    init(profile: UserProfile) {
        self.profile = profile
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        self.years = Array(currentYear...(currentYear + 2))
        self._selectedYear = State(initialValue: calendar.component(.year, from: profile.dueDate))
        self._selectedMonth = State(initialValue: calendar.component(.month, from: profile.dueDate))
        self._selectedDay = State(initialValue: calendar.component(.day, from: profile.dueDate))
    }

    private var selectedDate: Date {
        let calendar = Calendar.current
        let clampedDay = min(selectedDay, days.last ?? 31)
        return calendar.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: clampedDay))
            ?? profile.dueDate
    }

    private var isDateValid: Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let maxDate = calendar.date(byAdding: .day, value: 280, to: today) ?? today
        let selected = calendar.startOfDay(for: selectedDate)
        return selected >= today && selected <= maxDate
    }

    private var currentDateFormatted: String {
        let calendar = Calendar.current
        let y = calendar.component(.year, from: profile.dueDate)
        let m = calendar.component(.month, from: profile.dueDate)
        let d = calendar.component(.day, from: profile.dueDate)
        return "\(y)年\(m)月\(d)日"
    }

    var body: some View {
        VStack(spacing: 0) {
            // Drag handle
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(hex: "B7A8D6").opacity(0.3))
                .frame(width: 36, height: 4)
                .padding(.top, 12)
                .padding(.bottom, 20)

            // Title
            Text("修改预产期")
                .font(.custom("NotoSerifSC-Regular", size: 20))
                .foregroundStyle(Color(hex: "3A2F50"))
                .padding(.bottom, 8)

            // Current date label
            Text("当前预产期：\(currentDateFormatted)")
                .font(.system(size: 12))
                .foregroundStyle(Color.n300)
                .padding(.bottom, 20)

            // Date picker
            ZStack {
                // Highlight bar
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "C4A0DC").opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "C4A0DC").opacity(0.12), lineWidth: 1)
                    )
                    .frame(height: 36)
                    .padding(.horizontal, 12)

                HStack(spacing: 8) {
                    DragWheelColumn(
                        items: years.map { "\($0)" },
                        selectedIndex: Binding(
                            get: { years.firstIndex(of: selectedYear) ?? 0 },
                            set: { selectedYear = years[$0] }
                        )
                    )

                    Text("年")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.n300)

                    DragWheelColumn(
                        items: months.map { "\($0)" },
                        selectedIndex: Binding(
                            get: { months.firstIndex(of: selectedMonth) ?? 0 },
                            set: { selectedMonth = months[$0] }
                        )
                    )

                    Text("月")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.n300)

                    DragWheelColumn(
                        items: days.map { "\($0)" },
                        selectedIndex: Binding(
                            get: {
                                let idx = days.firstIndex(of: selectedDay) ?? 0
                                return min(idx, days.count - 1)
                            },
                            set: { selectedDay = days[$0] }
                        )
                    )

                    Text("日")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.n300)
                }
                .padding(.horizontal, 12)
            }
            .frame(height: 120)
            .clipped()
            .padding(.bottom, 20)

            // Buttons
            HStack(spacing: 12) {
                // Cancel
                Button {
                    dismiss()
                } label: {
                    Text("取消")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color(hex: "3A2F50"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white.opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(hex: "B7A8D6").opacity(0.2), lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                // Confirm
                Button {
                    confirmDate()
                } label: {
                    Text("确认")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(hex: "C9A0DC"))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: Color(hex: "C4A0DC").opacity(0.2), radius: 16, x: 0, y: 4)
                }
                .opacity(isDateValid ? 1 : 0.5)
                .disabled(!isDateValid)
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 30)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white.opacity(0.85))
                .ignoresSafeArea()
        )
        .onChange(of: selectedMonth) { _, _ in
            clampDay()
        }
        .onChange(of: selectedYear) { _, _ in
            clampDay()
        }
    }

    private func clampDay() {
        let maxDay = days.last ?? 31
        if selectedDay > maxDay {
            selectedDay = maxDay
        }
    }

    private func confirmDate() {
        let clampedDay = min(selectedDay, days.last ?? 31)
        let calendar = Calendar.current
        if let newDate = calendar.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: clampedDay)) {
            profile.dueDate = newDate
            try? modelContext.save()
        }
        dismiss()
    }
}
