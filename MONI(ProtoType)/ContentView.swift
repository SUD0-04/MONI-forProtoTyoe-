//
//  ContentView.swift
//  MONI(ProtoType)
//
//  Created by SUDØ on 5/14/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedDay = 14
    @State private var isSubscribed = false
    @State private var selectedQuickAction: QuickAction?
    @State private var showingReceiptCapture = false

    private let calendar = PrototypeCalendar.current
    private let transactions = PrototypeTransaction.samples
    private let quickActions = QuickAction.samples
    private let featureSections = FeatureSection.samples

    private var selectedTransactions: [PrototypeTransaction] {
        transactions.filter { $0.day == selectedDay }
    }

    private var monthIncome: Int {
        transactions.filter { $0.kind == .income }.reduce(0) { $0 + $1.amount }
    }

    private var monthExpense: Int {
        transactions.filter { $0.kind == .expense }.reduce(0) { $0 + $1.amount }
    }

    private var balance: Int {
        monthIncome - monthExpense
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.moniGroupedBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        HeroBalanceView(
                            balance: balance,
                            income: monthIncome,
                            expense: monthExpense,
                            isSubscribed: $isSubscribed
                        )
                        .padding(.horizontal, 18)
                        .padding(.top, 8)

                        VStack(spacing: 14) {
                            quickActionsView
                            appleIntelligenceView
                            calendarView
                            selectedDayView
                            featureListView
                        }
                        .padding(.horizontal, 18)
                        .padding(.bottom, 24)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .sheet(item: $selectedQuickAction) { action in
                QuickActionSheet(action: action)
                    .presentationDetents([.height(300)])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showingReceiptCapture) {
                ReceiptCaptureSheet(isSubscribed: isSubscribed)
                    .presentationDetents([.height(360)])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    private var quickActionsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                SectionTitle("빠른 실행")
                Spacer()
                Text("프로토타입")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 10) {
                ForEach(quickActions) { action in
                    Button {
                        selectedQuickAction = action
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: action.symbol)
                                .font(.system(size: 19, weight: .semibold))
                                .foregroundStyle(action.color)
                                .frame(width: 34, height: 34)
                                .background(action.color.opacity(0.12), in: Circle())

                            Text(action.title)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.78)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 78)
                        .background(.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var appleIntelligenceView: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                Image(systemName: isSubscribed ? "sparkles" : "lock.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(isSubscribed ? .white : .moniBlue)
                    .frame(width: 42, height: 42)
                    .background(isSubscribed ? Color.moniBlue : Color.moniBlue.opacity(0.1), in: Circle())

                VStack(alignment: .leading, spacing: 3) {
                    Text("Apple Intelligence")
                        .font(.headline.weight(.bold))
                    Text(isSubscribed ? "소비 리포트와 자동 입력이 켜져 있어요" : "구독 회원에게 열리는 확장 기능")
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                Toggle("", isOn: $isSubscribed)
                    .labelsHidden()
                    .tint(.moniBlue)
            }

            HStack(spacing: 8) {
                AIChip(title: "영수증 OCR", isEnabled: isSubscribed)
                AIChip(title: "AI 분류", isEnabled: isSubscribed)
                AIChip(title: "Siri 입력", isEnabled: isSubscribed)
            }

            Button {
                showingReceiptCapture = true
            } label: {
                Label(isSubscribed ? "영수증 스캔 흐름 보기" : "구독 혜택 미리보기", systemImage: isSubscribed ? "doc.viewfinder" : "sparkles")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.moniBlue, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
        .sectionSurface()
    }

    private var calendarView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    SectionTitle("5월 캘린더")
                    Text("날짜별 소비 흐름을 빠르게 확인")
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                HStack(spacing: 12) {
                    Image(systemName: "chevron.left")
                    Text("2026.05")
                    Image(systemName: "chevron.right")
                }
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.moniBlue)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.moniBlue.opacity(0.08), in: Capsule())
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 9) {
                ForEach(calendar.weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }

                ForEach(calendar.days) { item in
                    CalendarDayCell(
                        item: item,
                        isSelected: item.day == selectedDay,
                        amount: transactions.first(where: { $0.day == item.day })?.amount
                    ) {
                        selectedDay = item.day
                    }
                }
            }
        }
        .sectionSurface()
    }

    private var selectedDayView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                SectionTitle("\(selectedDay)일 내역")
                Spacer()
                Text(selectedTransactions.isEmpty ? "0건" : "\(selectedTransactions.count)건")
                    .font(.footnote.weight(.bold))
                    .foregroundStyle(.secondary)
            }

            if selectedTransactions.isEmpty {
                EmptyDayView()
            } else {
                VStack(spacing: 0) {
                    ForEach(selectedTransactions) { transaction in
                        TransactionRow(transaction: transaction)

                        if transaction.id != selectedTransactions.last?.id {
                            Divider().padding(.leading, 52)
                        }
                    }
                }
            }
        }
        .sectionSurface()
    }

    private var featureListView: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                SectionTitle("기능 구성")
                Spacer()
                Text("총 21건")
                    .font(.footnote.weight(.bold))
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 0) {
                ForEach(featureSections) { section in
                    FeatureSectionRow(section: section, isSubscribed: isSubscribed)

                    if section.id != featureSections.last?.id {
                        Divider().padding(.leading, 54)
                    }
                }
            }
        }
        .sectionSurface()
    }
}

private struct HeroBalanceView: View {
    let balance: Int
    let income: Int
    let expense: Int
    @Binding var isSubscribed: Bool

    var body: some View {
        TimelineView(.periodic(from: Date(), by: 60)) { context in
            let mood = SkyMood(date: context.date)

            VStack(alignment: .leading, spacing: 24) {
                HStack(alignment: .center) {
                    HStack(spacing: 10) {
                        AppMark()

                        VStack(alignment: .leading, spacing: 2) {
                            Text("MONI")
                                .font(.headline.weight(.black))
                                .foregroundStyle(mood.textColor)
                            Text(mood.subtitle)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(mood.textColor.opacity(0.68))
                        }
                    }

                    Spacer()

                    Button {
                        isSubscribed.toggle()
                    } label: {
                        Image(systemName: isSubscribed ? "sparkles" : "person.crop.circle")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(mood.textColor)
                            .frame(width: 40, height: 40)
                            .background(.white.opacity(mood.buttonOpacity), in: Circle())
                    }
                    .accessibilityLabel(isSubscribed ? "구독 활성" : "계정")
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("이번 달 남은 돈")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(mood.textColor.opacity(0.7))
                    Text(balance.wonText)
                        .font(.system(size: 38, weight: .black, design: .rounded))
                        .foregroundStyle(mood.textColor)
                        .minimumScaleFactor(0.68)
                        .lineLimit(1)
                    Text("지난달보다 128,000원 더 여유 있어요")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(mood.textColor.opacity(0.72))
                }

                HStack(spacing: 10) {
                    HeroMetric(title: "수입", value: income.wonText, symbol: "arrow.down.left", tint: .moniGreen, mood: mood)
                    HeroMetric(title: "지출", value: expense.wonText, symbol: "arrow.up.right", tint: .moniRed, mood: mood)
                }
            }
            .padding(22)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(minHeight: 280)
            .background {
                SkyBackground(mood: mood)
            }
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(alignment: .topTrailing) {
                Image(systemName: mood.symbol)
                    .font(.system(size: 78, weight: .semibold))
                    .foregroundStyle(.white.opacity(mood.symbolOpacity))
                    .padding(.top, 70)
                    .padding(.trailing, 26)
                    .accessibilityHidden(true)
            }
        }
    }
}

private struct SkyBackground: View {
    let mood: SkyMood

    var body: some View {
        ZStack {
            LinearGradient(colors: mood.colors, startPoint: .topLeading, endPoint: .bottomTrailing)

            Circle()
                .fill(.white.opacity(mood.cloudOpacity))
                .frame(width: 170, height: 170)
                .blur(radius: 18)
                .offset(x: -92, y: -98)

            Circle()
                .fill(.white.opacity(mood.cloudOpacity * 0.8))
                .frame(width: 230, height: 230)
                .blur(radius: 28)
                .offset(x: 138, y: 130)
        }
    }
}

private struct AppMark: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .fill(.white.opacity(0.94))
            Image(systemName: "calendar.badge.checkmark")
                .font(.system(size: 21, weight: .bold))
                .foregroundStyle(Color.moniBlue)
        }
        .frame(width: 44, height: 44)
        .shadow(color: .black.opacity(0.08), radius: 10, y: 5)
    }
}

private struct HeroMetric: View {
    let title: String
    let value: String
    let symbol: String
    let tint: Color
    let mood: SkyMood

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: symbol)
                .font(.caption.weight(.black))
                .foregroundStyle(tint)
                .frame(width: 26, height: 26)
                .background(.white.opacity(0.92), in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(mood.textColor.opacity(0.62))
                Text(value)
                    .font(.caption.weight(.black))
                    .foregroundStyle(mood.textColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(.white.opacity(mood.metricOpacity), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct SectionTitle: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.title3.weight(.bold))
            .foregroundStyle(.primary)
    }
}

private struct CalendarDayCell: View {
    let item: CalendarDay
    let isSelected: Bool
    let amount: Int?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Text("\(item.day)")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(dayColor)

                Circle()
                    .fill(amount == nil ? Color.clear : (isSelected ? .white : .moniBlue))
                    .frame(width: 5, height: 5)

                Text(shortAmount)
                    .font(.system(size: 8, weight: .semibold, design: .rounded))
                    .foregroundStyle(isSelected ? .white.opacity(0.82) : .secondary)
                    .lineLimit(1)
                    .frame(height: 10)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(isSelected ? Color.moniBlue : Color.moniGroupedBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(!item.isCurrentMonth)
    }

    private var dayColor: Color {
        if isSelected { return .white }
        return item.isCurrentMonth ? .primary : .secondary.opacity(0.38)
    }

    private var shortAmount: String {
        guard let amount else { return "" }
        return "\(amount / 10000)만"
    }
}

private struct AIChip: View {
    let title: String
    let isEnabled: Bool

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: isEnabled ? "checkmark.circle.fill" : "lock.fill")
                .font(.caption.weight(.bold))
            Text(title)
                .font(.caption.weight(.bold))
                .lineLimit(1)
                .minimumScaleFactor(0.78)
        }
        .foregroundStyle(isEnabled ? Color.moniBlue : Color.secondary)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 9)
        .background(isEnabled ? Color.moniBlue.opacity(0.1) : Color.moniGroupedBackground, in: Capsule())
    }
}

private struct TransactionRow: View {
    let transaction: PrototypeTransaction

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: transaction.symbol)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(transaction.kind == .income ? Color.moniGreen : Color.moniRed)
                .frame(width: 40, height: 40)
                .background((transaction.kind == .income ? Color.moniGreen : Color.moniRed).opacity(0.1), in: Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(transaction.title)
                    .font(.subheadline.weight(.semibold))
                Text(transaction.category)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(transaction.signedAmountText)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(transaction.kind == .income ? Color.moniGreen : Color.moniRed)
                .lineLimit(1)
                .minimumScaleFactor(0.76)
        }
        .padding(.vertical, 11)
    }
}

private struct EmptyDayView: View {
    var body: some View {
        VStack(spacing: 9) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(Color.moniBlue)
            Text("아직 입력된 내역이 없어요")
                .font(.subheadline.weight(.bold))
            Text("빠른 실행에서 수입이나 지출을 추가하는 흐름을 확인할 수 있어요.")
                .font(.footnote.weight(.medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color.moniGroupedBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct FeatureSectionRow: View {
    let section: FeatureSection
    let isSubscribed: Bool

    private var isLocked: Bool {
        section.requiresSubscription && !isSubscribed
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isLocked ? "lock.fill" : section.symbol)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(isLocked ? .secondary : section.tint)
                .frame(width: 40, height: 40)
                .background((isLocked ? Color.secondary : section.tint).opacity(0.1), in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(section.title)
                        .font(.subheadline.weight(.bold))
                    Text("\(section.count)건")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                }

                Text(section.description)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 12)
    }
}

private struct QuickActionSheet: View {
    let action: QuickAction

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Image(systemName: action.symbol)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(action.color)
                .frame(width: 58, height: 58)
                .background(action.color.opacity(0.12), in: Circle())

            VStack(alignment: .leading, spacing: 8) {
                Text(action.title)
                    .font(.title2.weight(.bold))
                Text(action.sheetDescription)
                    .font(.body.weight(.medium))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Button {
            } label: {
                Text("프로토타입 입력 완료")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.moniBlue, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }

            Spacer()
        }
        .padding(24)
        .background(Color.moniGroupedBackground)
    }
}

private struct ReceiptCaptureSheet: View {
    let isSubscribed: Bool

    var body: some View {
        VStack(spacing: 18) {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.moniBlue.opacity(0.1))
                .frame(height: 150)
                .overlay {
                    VStack(spacing: 10) {
                        Image(systemName: isSubscribed ? "doc.viewfinder" : "lock.fill")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(Color.moniBlue)
                        Text(isSubscribed ? "영수증 OCR 스캔 영역" : "구독 전용 기능")
                            .font(.headline.weight(.bold))
                    }
                }

            VStack(spacing: 7) {
                Text(isSubscribed ? "Apple Intelligence가 지출 항목을 제안합니다" : "구독하면 AI 자동 입력을 사용할 수 있어요")
                    .font(.headline.weight(.bold))
                    .multilineTextAlignment(.center)
                Text("카메라와 실제 분석 로직은 추후 연결하고, 현재는 화면 흐름과 권한 상태만 보여줍니다.")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .padding(24)
        .background(Color.moniGroupedBackground)
    }
}

private struct SkyMood {
    let hour: Int

    init(date: Date) {
        hour = Calendar.current.component(.hour, from: date)
    }

    var colors: [Color] {
        switch hour {
        case 5..<11:
            return [Color(red: 0.79, green: 0.91, blue: 1.0), Color(red: 0.98, green: 0.88, blue: 0.63)]
        case 11..<17:
            return [Color(red: 0.48, green: 0.76, blue: 1.0), Color(red: 0.82, green: 0.94, blue: 1.0)]
        case 17..<20:
            return [Color(red: 1.0, green: 0.69, blue: 0.48), Color(red: 0.52, green: 0.66, blue: 0.98)]
        default:
            return [Color(red: 0.18, green: 0.27, blue: 0.50), Color(red: 0.38, green: 0.45, blue: 0.75)]
        }
    }

    var subtitle: String {
        switch hour {
        case 5..<11:
            return "좋은 아침이에요"
        case 11..<17:
            return "오늘 소비도 맑게"
        case 17..<20:
            return "저녁 예산 확인"
        default:
            return "하루 정리 시간"
        }
    }

    var symbol: String {
        switch hour {
        case 5..<17:
            return "sun.max.fill"
        case 17..<20:
            return "sunset.fill"
        default:
            return "moon.stars.fill"
        }
    }

    var textColor: Color {
        hour >= 20 || hour < 5 ? .white : Color(red: 0.08, green: 0.13, blue: 0.20)
    }

    var buttonOpacity: Double {
        hour >= 20 || hour < 5 ? 0.18 : 0.55
    }

    var metricOpacity: Double {
        hour >= 20 || hour < 5 ? 0.18 : 0.48
    }

    var cloudOpacity: Double {
        hour >= 20 || hour < 5 ? 0.12 : 0.36
    }

    var symbolOpacity: Double {
        hour >= 20 || hour < 5 ? 0.18 : 0.26
    }
}

private struct CalendarDay: Identifiable {
    let id = UUID()
    let day: Int
    let isCurrentMonth: Bool
}

private struct PrototypeCalendar {
    let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    let days: [CalendarDay]

    static let current = PrototypeCalendar(days: [
        CalendarDay(day: 26, isCurrentMonth: false),
        CalendarDay(day: 27, isCurrentMonth: false),
        CalendarDay(day: 28, isCurrentMonth: false),
        CalendarDay(day: 29, isCurrentMonth: false),
        CalendarDay(day: 30, isCurrentMonth: false),
        CalendarDay(day: 1, isCurrentMonth: true),
        CalendarDay(day: 2, isCurrentMonth: true),
        CalendarDay(day: 3, isCurrentMonth: true),
        CalendarDay(day: 4, isCurrentMonth: true),
        CalendarDay(day: 5, isCurrentMonth: true),
        CalendarDay(day: 6, isCurrentMonth: true),
        CalendarDay(day: 7, isCurrentMonth: true),
        CalendarDay(day: 8, isCurrentMonth: true),
        CalendarDay(day: 9, isCurrentMonth: true),
        CalendarDay(day: 10, isCurrentMonth: true),
        CalendarDay(day: 11, isCurrentMonth: true),
        CalendarDay(day: 12, isCurrentMonth: true),
        CalendarDay(day: 13, isCurrentMonth: true),
        CalendarDay(day: 14, isCurrentMonth: true),
        CalendarDay(day: 15, isCurrentMonth: true),
        CalendarDay(day: 16, isCurrentMonth: true),
        CalendarDay(day: 17, isCurrentMonth: true),
        CalendarDay(day: 18, isCurrentMonth: true),
        CalendarDay(day: 19, isCurrentMonth: true),
        CalendarDay(day: 20, isCurrentMonth: true),
        CalendarDay(day: 21, isCurrentMonth: true),
        CalendarDay(day: 22, isCurrentMonth: true),
        CalendarDay(day: 23, isCurrentMonth: true),
        CalendarDay(day: 24, isCurrentMonth: true),
        CalendarDay(day: 25, isCurrentMonth: true),
        CalendarDay(day: 26, isCurrentMonth: true),
        CalendarDay(day: 27, isCurrentMonth: true),
        CalendarDay(day: 28, isCurrentMonth: true),
        CalendarDay(day: 29, isCurrentMonth: true),
        CalendarDay(day: 30, isCurrentMonth: true),
        CalendarDay(day: 31, isCurrentMonth: true)
    ])
}

private struct PrototypeTransaction: Identifiable {
    enum Kind {
        case income
        case expense
    }

    let id = UUID()
    let day: Int
    let title: String
    let category: String
    let amount: Int
    let kind: Kind
    let symbol: String

    var signedAmountText: String {
        "\(kind == .income ? "+" : "-")\(amount.wonText)"
    }

    static let samples = [
        PrototypeTransaction(day: 1, title: "월급", category: "고정수입", amount: 3_200_000, kind: .income, symbol: "banknote.fill"),
        PrototypeTransaction(day: 3, title: "마트 장보기", category: "식비", amount: 86_400, kind: .expense, symbol: "cart.fill"),
        PrototypeTransaction(day: 7, title: "교통카드 충전", category: "교통", amount: 50_000, kind: .expense, symbol: "tram.fill"),
        PrototypeTransaction(day: 10, title: "구독 서비스", category: "정기지출", amount: 19_900, kind: .expense, symbol: "repeat.circle.fill"),
        PrototypeTransaction(day: 14, title: "카페 미팅", category: "식비", amount: 13_500, kind: .expense, symbol: "cup.and.saucer.fill"),
        PrototypeTransaction(day: 14, title: "외주 정산", category: "부수입", amount: 420_000, kind: .income, symbol: "sparkles"),
        PrototypeTransaction(day: 18, title: "운동복", category: "쇼핑", amount: 72_000, kind: .expense, symbol: "tshirt.fill"),
        PrototypeTransaction(day: 21, title: "전기요금", category: "생활", amount: 64_200, kind: .expense, symbol: "bolt.fill"),
        PrototypeTransaction(day: 25, title: "친구 송금", category: "이체", amount: 30_000, kind: .expense, symbol: "arrow.left.arrow.right"),
        PrototypeTransaction(day: 29, title: "저축", category: "예산", amount: 500_000, kind: .expense, symbol: "safe.fill")
    ]
}

private struct QuickAction: Identifiable {
    let id = UUID()
    let title: String
    let symbol: String
    let color: Color
    let sheetDescription: String

    static let samples = [
        QuickAction(title: "수입", symbol: "plus", color: .moniGreen, sheetDescription: "고정수입 등록 폼을 여는 흐름입니다. 금액, 반복 주기, 입금 계좌를 입력하는 화면으로 확장할 수 있어요."),
        QuickAction(title: "지출", symbol: "minus", color: .moniRed, sheetDescription: "지출 입력 흐름입니다. 카테고리, 결제수단, 메모, 예산 반영 상태를 담는 화면으로 이어집니다."),
        QuickAction(title: "검색", symbol: "magnifyingglass", color: .moniBlue, sheetDescription: "내역 검색과 필터 화면입니다. 날짜, 카테고리, 금액 범위를 조합하는 UX를 붙일 수 있어요."),
        QuickAction(title: "내보내기", symbol: "square.and.arrow.up", color: .moniViolet, sheetDescription: "CSV 또는 Numbers 파일로 내보내는 흐름입니다. 현재는 프로토타입 동작만 표시합니다.")
    ]
}

private struct FeatureSection: Identifiable {
    let id = UUID()
    let title: String
    let count: Int
    let description: String
    let symbol: String
    let tint: Color
    let requiresSubscription: Bool

    static let samples = [
        FeatureSection(title: "인증/계정", count: 3, description: "회원가입, Face ID 로그인, 계정 설정/탈퇴", symbol: "lock.shield.fill", tint: .moniOrange, requiresSubscription: false),
        FeatureSection(title: "기본 기능", count: 9, description: "고정수입, 내역 입력, 캘린더, 예산 경고, 검색, iCloud, 내보내기", symbol: "chart.bar.fill", tint: .moniBlue, requiresSubscription: false),
        FeatureSection(title: "추가 기능", count: 5, description: "영수증 OCR, AI 소비패턴 리포트, 정기지출 감지, Watch, 위젯", symbol: "sparkles", tint: .moniGreen, requiresSubscription: true),
        FeatureSection(title: "AI/Siri 연동", count: 4, description: "Siri 음성 입력, SMS/이메일 자동 입력, Spotlight, 개인정보 보호", symbol: "wand.and.stars", tint: .moniViolet, requiresSubscription: true)
    ]
}

private extension View {
    func sectionSurface() -> some View {
        self
            .padding(18)
            .background(.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .black.opacity(0.035), radius: 14, y: 7)
    }
}

private extension Int {
    var wonText: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return "\(formatter.string(from: NSNumber(value: self)) ?? "\(self)")원"
    }
}

private extension Color {
    static let moniGroupedBackground = Color(red: 0.96, green: 0.97, blue: 0.985)
    static let moniBlue = Color(red: 0.14, green: 0.43, blue: 1.0)
    static let moniGreen = Color(red: 0.04, green: 0.70, blue: 0.38)
    static let moniRed = Color(red: 0.96, green: 0.25, blue: 0.26)
    static let moniOrange = Color(red: 1.0, green: 0.55, blue: 0.16)
    static let moniViolet = Color(red: 0.43, green: 0.35, blue: 0.95)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
