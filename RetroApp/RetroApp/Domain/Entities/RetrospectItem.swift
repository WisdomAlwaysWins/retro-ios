//
//  RetrospectItem.swift
//  RetroApp
//
//  Created by J on 3/20/26.
//

import Foundation

/// 회고 내 개별 항목을 나타내는 Domain Entity.
///
/// 하나의 ``Retrospect``에 여러 개의 `RetrospectItem`이 속한다 (1:N).
/// 카테고리명은 포맷에 따라 달라지며 (Keep, Problem, Liked 등),
/// String으로 저장하여 어떤 포맷이든 코드 변경 없이 대응한다.
///
/// ## Try 이월
/// 이전 회고의 미해결 Try 항목을 다음 회고로 연결할 수 있다.
/// - ``linkedTryId``에 원본 Try 항목의 ID를 저장
/// - ``isResolved``로 해결 여부를 추적
struct RetrospectItem: Sendable, Equatable, Identifiable {

    /// 항목 고유 식별자
    let id: UUID

    /// 소속 회고의 식별자
    ///
    /// ``Retrospect``의 `id`를 참조한다.
    let retrospectId: UUID

    /// 카테고리명
    ///
    /// 포맷에 정의된 카테고리 이름을 그대로 저장한다.
    /// 예: "Keep", "Problem", "Try", "Liked", "Learned", "Start" 등
    let categoryName: String

    /// 항목 내용
    ///
    /// 사용자가 작성한 텍스트. 빈 문자열은 저장하지 않는다.
    let content: String

    /// 이월된 원본 Try 항목의 식별자
    ///
    /// 이전 회고에서 이월된 항목인 경우, 원본 `RetrospectItem`의 `id`를 참조한다.
    /// 이월이 아닌 항목이면 `nil`.
    let linkedTryId: UUID?

    /// Try 항목의 해결 여부
    ///
    /// 이월된 Try가 다음 회고에서 "해결됨"으로 처리되면 `true`.
    /// Try 카테고리가 아닌 항목은 항상 `false`.
    let isResolved: Bool

    /// 카테고리 내 정렬 순서
    ///
    /// 0부터 시작. 드래그로 순서 변경 시 업데이트된다.
    let order: Int
}
