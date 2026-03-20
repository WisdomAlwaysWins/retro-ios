//
//  Retrospect.swift
//  RetroApp
//
//  Created by J on 3/20/26.
//

import Foundation

/// 하나의 회고를 나타내는 Domain Entity.
///
/// 사용자가 작성한 회고의 메타 정보를 담고 있으며,
/// 실제 항목(Keep, Problem, Try 등)은 ``RetrospectItem``으로 분리되어 1:N 관계를 가진다.
///
struct Retrospect {

    /// 회고 고유 식별자
    let id: UUID

    /// 회고 제목
    ///
    /// 사용자가 입력하지 않으면 `nil`.
    /// 목록에서는 `nil`일 경우 생성 날짜로 표시한다.
    /// 예: "2026년 3월 20일 회고"
    let title: String?

    /// 사용한 회고 포맷의 식별자
    ///
    /// ``RetrospectFormat``의 `id`를 참조한다.
    /// 포맷에 따라 카테고리 구성이 달라진다 (KPT, 4Ls, SSC 등).
    let formatId: UUID

    /// 회고 상태
    ///
    /// - `draft`: 작성 중. 자유롭게 수정 가능
    /// - `confirmed`: 제출 완료. 수정 가능하지만 `isEdited`가 `true`로 변경됨
    let status: RetrospectStatus

    /// 확정 후 수정된 적이 있는지 여부
    ///
    /// 확정 상태에서 수정하면 `true`로 변경된다.
    /// 목록/상세 화면에서 "(수정됨)" 표시에 사용.
    /// 드래프트 상태에서는 항상 `false`.
    let isEdited: Bool

    /// 회고 유형
    ///
    /// - `personal`: 개인 회고
    /// - `team`: 팀 회고 (세션에 소속)
    let type: RetrospectType

    /// 팀 회고인 경우, 소속 팀의 식별자
    ///
    /// 개인 회고이면 `nil`.
    let teamId: UUID?

    /// 팀 회고인 경우, 소속 세션의 식별자
    ///
    /// ``RetrospectSession``의 `id`를 참조한다.
    /// 개인 회고이면 `nil`.
    let sessionId: UUID?

    /// 사용한 포커스 타이머 시간 (초 단위)
    ///
    /// 타이머를 사용하지 않았으면 `nil`.
    /// 프리셋: Quick(300), Normal(900), Deep(1800)
    let timerDuration: Int?

    /// 회고 생성 시각
    let createdAt: Date

    /// 회고 확정(제출) 시각
    ///
    /// `status`가 `.confirmed`일 때만 값이 있다.
    let confirmedAt: Date?
}
