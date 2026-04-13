//
//  KnowledgeView.swift
//  Blossom (拾月)
//
//  Tab 4 - 知识：分娩知识卡片
//

import SwiftUI
import SwiftData

struct KnowledgeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \KnowledgeArticle.sortOrder) private var articles: [KnowledgeArticle]
    

    private var categories: [String] {
        ["拉玛泽呼吸法", "凯格尔运动"]
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.xxl) {
                    // 自定义标题区
                    VStack(alignment: .leading, spacing: 4) {
                        Text("知识")
                            .font(.custom("NotoSerifSC-Regular", size: 24))
                            .foregroundStyle(Color(hex: "3A2F50"))

                        Text("分娩准备 · 科学备产")
                            .font(.system(size: 12))
                            .foregroundStyle(Color(hex: "AEA3C4"))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)

                    // 分类卡片 (2列)
                    categoryGrid

                    // 热门文章
                    hotArticlesSection
                }
                .padding(.horizontal, AppSpacing.pageHorizontal)
                .padding(.vertical, AppSpacing.pageVertical)
            }
            .pageBackground()
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                if articles.isEmpty {
                    seedDefaultArticles()
                }
            }
        }
    }
    
    // MARK: - Category Grid
    private var categoryGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: AppSpacing.cardSpacing),
            GridItem(.flexible(), spacing: AppSpacing.cardSpacing)
        ], spacing: AppSpacing.cardSpacing) {
            ForEach(categories, id: \.self) { category in
                NavigationLink(destination: CategoryArticlesView(category: category)) {
                    CategoryCard(
                        category: category,
                        articleCount: articles.filter { $0.category == category }.count
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - Hot Articles Section
    private var hotArticlesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("热门文章")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color(hex: "7A6E94"))
                .tracking(0.5)
            
            VStack(spacing: AppSpacing.md) {
                ForEach(articles.prefix(3)) { article in
                    NavigationLink(destination: ArticleDetailView(article: article)) {
                        ArticleCard(article: article)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // MARK: - Seed Default Articles
    private func seedDefaultArticles() {
        let defaultArticles = ArticleContent.allArticles
        
        for (index, article) in defaultArticles.enumerated() {
            let knowledgeArticle = KnowledgeArticle(
                category: article.category,
                title: article.title,
                content: article.content,
                readTimeMinutes: article.readTime,
                sortOrder: index
            )
            modelContext.insert(knowledgeArticle)
        }
    }
}

// MARK: - Category Card
struct CategoryCard: View {
    let category: String
    let articleCount: Int
    
    private var icon: String {
        switch category {
        case "拉玛泽呼吸法": return "wind"
        case "凯格尔运动": return "figure.strengthtraining.traditional"
        default: return "book"
        }
    }
    
    private var iconGradient: [Color] {
        switch category {
        case "拉玛泽呼吸法": return [Color(hex: "F9B5C4"), Color(hex: "E8A0B8")]
        case "凯格尔运动": return [Color(hex: "C4B5E0"), Color(hex: "B6A0D2")]
        default: return [Color(hex: "B8DCF5"), Color(hex: "ABC2E6")]
        }
    }
    
    private var displayName: String {
        switch category {
        case "拉玛泽呼吸法": return "拉玛泽呼吸"
        case "凯格尔运动": return "凯格尔运动"
        default: return category
        }
    }
    
    private var displaySubtitle: String {
        switch category {
        case "拉玛泽呼吸法": return "6 篇图文"
        case "凯格尔运动": return "科学原理"
        default: return "\(articleCount) 篇文章"
        }
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            // Centered icon
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(
                    LinearGradient(
                        colors: iconGradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            
            VStack(spacing: 2) {
                Text(displayName)
                    .font(AppFonts.cardTitle)
                    .foregroundStyle(Color.n900)
                    .lineLimit(1)
                
                Text(displaySubtitle)
                    .font(AppFonts.caption)
                    .foregroundStyle(Color.n500)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.cardPadding)
        .glassCard()
    }
}

// MARK: - Article Card
struct ArticleCard: View {
    let article: KnowledgeArticle
    
    var body: some View {
        HStack(spacing: AppSpacing.lg) {
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(AppFonts.cardTitle)
                    .foregroundStyle(Color.n900)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text("\(article.readTimeMinutes) 分钟阅读")
                    .font(AppFonts.caption)
                    .foregroundStyle(Color.n500)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.cardPadding)
        .glassCard()
    }
}

// MARK: - Category Articles View
struct CategoryArticlesView: View {
    let category: String
    @Query private var articles: [KnowledgeArticle]
    
    init(category: String) {
        self.category = category
        _articles = Query(filter: #Predicate<KnowledgeArticle> { article in
            article.category == category
        }, sort: \KnowledgeArticle.sortOrder)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                ForEach(articles) { article in
                    NavigationLink(destination: ArticleDetailView(article: article)) {
                        ArticleCard(article: article)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, AppSpacing.pageHorizontal)
            .padding(.vertical, AppSpacing.pageVertical)
        }
        .pageBackground()
        .navigationTitle(category)
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Article Detail View
struct ArticleDetailView: View {
    @Bindable var article: KnowledgeArticle
    @State private var showKegelExercise = false
    @State private var showLamazeExercise = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xxl) {
                // Article content in frosted container
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    MarkdownView(text: article.content)
                }
                .padding(AppSpacing.cardPadding)
                .glassCard()
                
                // Disclaimer
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    Text("本内容仅供参考，不构成医学建议，请遵医嘱。")
                        .font(AppFonts.smallLabel)
                        .foregroundStyle(Color.n500)
                }
                
                Spacer(minLength: 40)
                
                // Actions
                if article.category == "拉玛泽呼吸法" {
                    Button(action: { showLamazeExercise = true }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("开始跟练")
                        }
                        .font(.custom("Nunito-SemiBold", size: 14))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.primary600)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                    }
                } else if article.category == "凯格尔运动" {
                    Button(action: { showKegelExercise = true }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("开始跟练")
                        }
                        .font(.custom("Nunito-SemiBold", size: 14))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.primary600)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                    }
                }
            }
            .padding(.horizontal, AppSpacing.pageHorizontal)
            .padding(.vertical, AppSpacing.pageVertical)
        }
        .pageBackground()
        .navigationTitle(article.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .tint(Color.primaryDark)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { article.isFavorited.toggle() }) {
                    Image(systemName: article.isFavorited ? "heart.fill" : "heart")
                        .foregroundStyle(article.isFavorited ? Color.accentPeach : Color.n500)
                }
            }
        }
        .onAppear {
            article.isRead = true
        }
        .fullScreenCover(isPresented: $showKegelExercise) {
            KegelExerciseView()
        }
        .fullScreenCover(isPresented: $showLamazeExercise) {
            LamazeExerciseView()
        }
    }
}

#Preview {
    KnowledgeView()
        .modelContainer(for: KnowledgeArticle.self, inMemory: true)
}
