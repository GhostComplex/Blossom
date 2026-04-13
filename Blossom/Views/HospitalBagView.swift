//
//  HospitalBagView.swift
//  Blossom (拾月)
//
//  Tab 3 - 待产包：Checklist 管理
//

import SwiftUI
import SwiftData

struct HospitalBagView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \HospitalBagItem.sortOrder) private var items: [HospitalBagItem]
    
    @State private var showAddItem = false
    
    private var categories: [String] {
        HospitalBagCategory.allCases.map { $0.rawValue }
    }
    
    private var totalCount: Int { items.count }
    private var completedCount: Int { items.filter { $0.isCompleted }.count }
    private var progress: Double {
        totalCount > 0 ? Double(completedCount) / Double(totalCount) : 0
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Custom title + subtitle + add button
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("待产包")
                                .font(.custom("NotoSerifSC-Regular", size: 24))
                                .foregroundStyle(Color(hex: "3A2F50"))

                            Text("已准备 \(completedCount) / \(totalCount) 项 (\(Int(progress * 100))%)")
                                .font(.custom("Nunito-Regular", size: 12))
                                .foregroundStyle(Color(hex: "AEA3C4"))
                        }

                        Spacer()

                        Button(action: { showAddItem = true }) {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color(hex: "C9A0DC"))
                                .frame(width: 32, height: 32)
                                .background(.ultraThinMaterial)
                                .background(Color.white.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.6), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.bottom, 6)

                    // 进度条
                    progressBar
                        .padding(.bottom, 14)

                    // 分类列表
                    ForEach(categories, id: \.self) { category in
                        categorySection(category)
                            .padding(.bottom, 8)
                    }
                }
                .padding(.horizontal, AppSpacing.pageHorizontal)
                .padding(.vertical, 8)
            }
            .pageBackground()
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showAddItem) {
                AddHospitalBagItemView()
            }
            .onAppear {
                if items.isEmpty {
                    seedDefaultItems()
                }
            }
        }
    }
    
    // MARK: - Progress Bar
    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(red: 196/255, green: 181/255, blue: 224/255).opacity(0.12))
                    .frame(height: 7)
                
                RoundedRectangle(cornerRadius: 3)
                    .fill(progress >= 1.0 ? AnyShapeStyle(Color.success) : AnyShapeStyle(LinearGradient.progressBar))
                    .frame(width: geometry.size.width * progress, height: 7)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: 7)
    }
    
    // MARK: - Category Section
    private func categorySection(_ category: String) -> some View {
        let categoryItems = items.filter { $0.category == category }
        let categoryCompleted = categoryItems.filter { $0.isCompleted }.count
        
        return VStack(alignment: .leading, spacing: 0) {
            // Category header
            HStack {
                Text(category)
                    .font(.custom("Nunito-SemiBold", size: 13))
                    .foregroundStyle(Color.n900)

                Spacer()

                Text("(\(categoryCompleted)/\(categoryItems.count))")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.n500)
            }

            if !categoryItems.isEmpty {
                // Items
                VStack(spacing: 8) {
                    ForEach(categoryItems) { item in
                        HospitalBagItemRow(item: item)
                    }
                }
                .padding(.top, 10)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .glassCard()
    }
    
    private func categoryIcon(_ category: String) -> String {
        HospitalBagCategory(rawValue: category)?.icon ?? "📦"
    }
    
    // MARK: - Seed Default Items
    private func seedDefaultItems() {
        let defaultItems: [(String, String, Int, String)] = [
            // 证件类
            ("证件类", "身份证", 2, "夫妻双方"),
            ("证件类", "准生证", 1, ""),
            ("证件类", "医保卡", 1, ""),
            ("证件类", "病历本", 1, ""),
            ("证件类", "产检报告", 1, "B超单、化验单"),
            
            // 妈妈用品
            ("妈妈用品", "月子服", 2, ""),
            ("妈妈用品", "哺乳文胸", 2, ""),
            ("妈妈用品", "一次性内裤", 10, ""),
            ("妈妈用品", "产褥垫", 2, "包"),
            ("妈妈用品", "产妇卫生巾", 2, "包"),
            ("妈妈用品", "吸奶器", 1, ""),
            ("妈妈用品", "防溢乳垫", 1, "盒"),
            ("妈妈用品", "乳头霜", 1, ""),
            ("妈妈用品", "束腹带", 1, ""),
            ("妈妈用品", "月子帽", 1, ""),
            ("妈妈用品", "月子鞋", 1, ""),
            ("妈妈用品", "吸管杯", 1, ""),
            ("妈妈用品", "保温杯", 1, ""),
            ("妈妈用品", "巧克力/红牛", 1, "补充能量"),
            ("妈妈用品", "护肤品", 1, "基础保湿"),
            ("妈妈用品", "产后修复用品", 1, ""),
            ("妈妈用品", "卫生纸", 2, "提"),
            ("妈妈用品", "湿巾", 2, "包"),
            ("妈妈用品", "餐具", 1, "碗筷勺"),
            ("妈妈用品", "梳子、发圈", 1, ""),
            
            // 宝宝用品
            ("宝宝用品", "纸尿裤 NB 号", 1, "包"),
            ("宝宝用品", "湿巾", 2, "包"),
            ("宝宝用品", "奶瓶", 2, "玻璃/PPSU"),
            ("宝宝用品", "奶粉（备用）", 1, "罐"),
            ("宝宝用品", "奶瓶刷", 1, ""),
            ("宝宝用品", "奶瓶清洁剂", 1, ""),
            ("宝宝用品", "婴儿衣服 NB 码", 3, "套"),
            ("宝宝用品", "包被", 2, ""),
            ("宝宝用品", "抱被", 1, ""),
            ("宝宝用品", "婴儿帽子", 2, ""),
            ("宝宝用品", "小毛巾", 5, ""),
            ("宝宝用品", "浴巾", 2, ""),
            ("宝宝用品", "隔尿垫", 2, ""),
            ("宝宝用品", "婴儿护臀膏", 1, ""),
            ("宝宝用品", "婴儿沐浴露", 1, ""),
            ("宝宝用品", "婴儿洗衣液", 1, ""),
            ("宝宝用品", "婴儿指甲剪", 1, ""),
            ("宝宝用品", "体温计", 1, ""),
            
            // 住院用品
            ("住院用品", "毛巾", 3, ""),
            ("住院用品", "拖鞋", 2, "双"),
            ("住院用品", "脸盆", 2, ""),
            ("住院用品", "牙刷牙膏", 1, "套"),
            ("住院用品", "洗发水沐浴露", 1, ""),
            ("住院用品", "纸巾", 3, "盒"),
            ("住院用品", "垃圾袋", 1, "卷"),
            
            // 其他
            ("其他用品", "手机充电器", 2, ""),
            ("其他用品", "充电宝", 1, ""),
            ("其他用品", "相机", 1, "记录宝宝出生"),
            ("其他用品", "笔记本、笔", 1, ""),
            ("其他用品", "零钱", 1, ""),
            ("其他用品", "红包", 1, "给医护人员"),
            ("其他用品", "靠垫", 1, "分娩时用"),
            ("其他用品", "大袋子", 1, "装东西回家"),
        ]
        
        for (index, item) in defaultItems.enumerated() {
            let bagItem = HospitalBagItem(
                category: item.0,
                name: item.1,
                quantity: item.2,
                note: item.3,
                sortOrder: index
            )
            modelContext.insert(bagItem)
        }
    }
}

// MARK: - Hospital Bag Item Row
struct HospitalBagItemRow: View {
    @Bindable var item: HospitalBagItem
    
    var body: some View {
        HStack(spacing: 10) {
            // Checkbox — custom drawn circle per design spec
            if item.isCompleted {
                // Checked: filled purple circle with white checkmark
                ZStack {
                    Circle()
                        .fill(Color(hex: "C9A0DC"))
                        .frame(width: 18, height: 18)
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                }
            } else {
                // Unchecked: 1.5px purple border circle — rgba(183,168,214,0.3)
                Circle()
                    .stroke(Color(red: 183/255, green: 168/255, blue: 214/255).opacity(0.3), lineWidth: 1.5)
                    .frame(width: 18, height: 18)
            }

            // Item info
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(item.name)
                        .font(.system(size: 13))
                        .foregroundStyle(item.isCompleted ? Color.n500 : Color.n900)
                        .strikethrough(item.isCompleted)
                    
                    if item.quantity > 1 {
                        Text("×\(item.quantity)")
                            .font(AppFonts.smallLabel)
                            .foregroundStyle(Color.n500)
                    }
                }
                
                if !item.note.isEmpty {
                    Text(item.note)
                        .font(AppFonts.smallLabel)
                        .foregroundStyle(Color.n500)
                }
            }
            
            Spacer()
        }
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                item.isCompleted.toggle()
            }
            if item.isCompleted {
                NotificationManager.shared.onTaskCompleted(source: .hospitalBag)
            }
        }
    }
}

// MARK: - Add Item View (Placeholder)
struct AddHospitalBagItemView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Text("添加物品")
                .navigationTitle("添加物品")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("取消") { dismiss() }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("添加") { dismiss() }
                    }
                }
        }
    }
}

#Preview {
    HospitalBagView()
        .modelContainer(for: HospitalBagItem.self, inMemory: true)
}
