//
//  KnowledgeView.swift
//  Blossom (如期)
//
//  Tab 4 - 知识：分娩知识卡片
//

import SwiftUI
import SwiftData

struct KnowledgeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \KnowledgeArticle.sortOrder) private var articles: [KnowledgeArticle]
    
    @State private var searchText = ""
    
    private var categories: [String] {
        ["拉玛泽呼吸法", "凯格尔运动"]
    }
    
    private var filteredArticles: [KnowledgeArticle] {
        if searchText.isEmpty {
            return articles
        }
        return articles.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.xxl) {
                    // 分类卡片 (2列)
                    categoryGrid
                    
                    // 热门文章
                    hotArticlesSection
                }
                .padding(.horizontal, AppSpacing.pageHorizontal)
                .padding(.vertical, AppSpacing.pageVertical)
            }
            .pageBackground()
            .navigationTitle("知识")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "搜索文章")
            .onAppear {
                if articles.isEmpty {
                    seedDefaultArticles()
                }
            }
        }
    }
    
    // MARK: - Category Grid
    private var categoryGrid: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("分类")
                .font(AppFonts.cardTitle)
                .foregroundStyle(Color.n900)
            
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
    }
    
    // MARK: - Hot Articles Section
    private var hotArticlesSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("热门文章")
                .font(AppFonts.cardTitle)
                .foregroundStyle(Color.n900)
            
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
        default: return "book.fill"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(Color.primaryDark)
                .frame(width: 44, height: 44)
                .background(Color.accentLight)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(category)
                    .font(AppFonts.cardTitle)
                    .foregroundStyle(Color.n900)
                    .lineLimit(1)
                
                Text("\(articleCount) 篇文章")
                    .font(AppFonts.caption)
                    .foregroundStyle(Color.n500)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
                
                Text("\(article.readTimeMinutes) 分钟阅读")
                    .font(AppFonts.caption)
                    .foregroundStyle(Color.n500)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.n300)
        }
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
                // Article content (render markdown)
                if let attributedContent = try? AttributedString(markdown: article.content, options: .init(interpretedSyntax: .full)) {
                    Text(attributedContent)
                        .font(AppFonts.bodyText)
                        .foregroundStyle(Color.n700)
                        .lineSpacing(6)
                } else {
                    Text(article.content)
                        .font(AppFonts.bodyText)
                        .foregroundStyle(Color.n700)
                        .lineSpacing(6)
                }
                
                // Disclaimer
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    Text("⚠️ 免责声明：本文内容仅供参考，不构成医学建议。如有疑问，请咨询专业医生。")
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
                        .font(AppFonts.cardTitle)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.primary600)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.full))
                    }
                } else if article.category == "凯格尔运动" {
                    Button(action: { showKegelExercise = true }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("开始跟练")
                        }
                        .font(AppFonts.cardTitle)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.primary600)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.full))
                    }
                }
            }
            .padding(.horizontal, AppSpacing.pageHorizontal)
            .padding(.vertical, AppSpacing.pageVertical)
        }
        .pageBackground()
        .navigationTitle(article.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { article.isFavorited.toggle() }) {
                    Image(systemName: article.isFavorited ? "heart.fill" : "heart")
                        .foregroundStyle(article.isFavorited ? Color.error : Color.n700)
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
