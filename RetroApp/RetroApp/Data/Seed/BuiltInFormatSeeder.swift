//
//  BuiltInFormatSeeder.swift
//  RetroApp
//
//  Created by J on 3/31/26.
//

import Foundation

/// 앱 첫 실행 시 빌트인 포맷을 Core Data에 저장하는 클래스.
///
/// KPT, 4Ls, Start-Stop-Continue 3개 포맷을 저장한다.
/// UserDefaults로 이미 저장했는지 체크하여 중복 저장을 방지한다.
final class BuiltInFormatSeeder {

    // MARK: - Properties

    private let formatRepository: RetrospectFormatRepositoryProtocol
    private let hasSeededKey = "hasSeededBuiltInFormats"

    // MARK: - Init

    init(formatRepository: RetrospectFormatRepositoryProtocol) {
        self.formatRepository = formatRepository
    }

    // MARK: - Seed

    /// 빌트인 포맷이 저장되지 않았으면 저장한다.
    func seedIfNeeded() async {
        guard !UserDefaults.standard.bool(forKey: hasSeededKey) else { return }

        let formats = [buildKPT(), build4Ls(), buildCSS()]

        do {
            for format in formats {
                _ = try await formatRepository.save(format)
            }
            UserDefaults.standard.set(true, forKey: hasSeededKey)
        } catch {
            // 저장 실패 시 다음 실행에서 재시도
        }
    }

    // MARK: - Format Builders

    private func buildKPT() -> RetrospectFormat {
        RetrospectFormat(
            id: UUID(),
            name: "KPT",
            categories: [
                CategoryTemplate(name: "Keep", colorHex: "#10B981", order: 0),
                CategoryTemplate(name: "Problem", colorHex: "#F97316", order: 1),
                CategoryTemplate(name: "Try", colorHex: "#6366F1", order: 2)
            ],
            isBuiltIn: true,
            description: "가장 기본적인 회고 포맷",
            recommendWhen: "일상적인 스프린트 회고에 적합"
        )
    }

    private func build4Ls() -> RetrospectFormat {
        RetrospectFormat(
            id: UUID(),
            name: "4Ls",
            categories: [
                CategoryTemplate(name: "Liked", colorHex: "#10B981", order: 0),
                CategoryTemplate(name: "Learned", colorHex: "#3B82F6", order: 1),
                CategoryTemplate(name: "Lacked", colorHex: "#F97316", order: 2),
                CategoryTemplate(name: "Longed For", colorHex: "#8B5CF6", order: 3)
            ],
            isBuiltIn: true,
            description: "감정과 학습을 함께 돌아보는 포맷",
            recommendWhen: "프로젝트 완료 후 팀 회고에 적합"
        )
    }

    private func buildCSS() -> RetrospectFormat {
        RetrospectFormat(
            id: UUID(),
            name: "Start-Stop-Continue",
            categories: [
                CategoryTemplate(name: "Continue", colorHex: "#10B981", order: 0),
                CategoryTemplate(name: "Stop", colorHex: "#EF4444", order: 1),
                CategoryTemplate(name: "Start", colorHex: "#3B82F6", order: 2)
            ],
            isBuiltIn: true,
            description: "행동 변화에 집중하는 포맷",
            recommendWhen: "구체적인 액션 아이템이 필요할 때"
        )
    }
}
