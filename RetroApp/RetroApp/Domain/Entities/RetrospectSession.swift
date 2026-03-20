//
//  RetrospectSession.swift
//  RetroApp
//
//  Created by J on 3/20/26.
//

import Foundation

/// 팀 회고 세션을 나타내는 Domain Entity.
///
/// 하나의 세션은 팀원들이 동시에 회고를 작성하는 하나의 "모임"이다.
/// 세션이 시작되면 ``SessionStatus/inProgress``가 되고,
/// 모든 팀원이 제출하면 ``SessionStatus/completed``로 전환된다.
///
/// ## 피어 피드백
/// ``isAnonymousFeedback``가 `true`이면 해당 세션의 CSS 피어 피드백이 익명으로 처리된다.
struct RetrospectSession: Sendable, Equatable, Identifiable {

    /// 세션 고유 식별자
    let id: UUID

    /// 소속 팀의 식별자
    ///
    /// ``Team``의 `id`를 참조한다.
    let teamId: UUID

    /// 세션 제목
    ///
    /// 예: "Sprint 3 회고", "3월 셋째 주 회고"
    let title: String

    /// 세션에서 사용하는 회고 포맷의 식별자
    ///
    /// ``RetrospectFormat``의 `id`를 참조한다.
    /// 퍼실리테이터가 세션 시작 시 선택한다.
    let formatId: UUID

    /// 세션 상태
    ///
    /// - ``SessionStatus/inProgress``: 팀원들이 작성 중
    /// - ``SessionStatus/completed``: 전원 제출 완료
    let status: SessionStatus

    /// 피어 피드백 익명 여부
    ///
    /// `true`이면 CSS 피어 피드백에서 작성자가 표시되지 않는다.
    /// 퍼실리테이터가 세션 시작 시 설정한다.
    let isAnonymousFeedback: Bool

    /// 세션 시작 시각
    let startedAt: Date

    /// 세션 완료 시각
    ///
    /// 모든 팀원이 제출하여 세션이 ``SessionStatus/completed``가 된 시점.
    /// 진행 중이면 `nil`.
    let completedAt: Date?
}

/// 팀 회고 세션에서 개별 팀원의 제출 상태를 나타내는 Domain Entity.
///
/// 하나의 ``RetrospectSession``에 팀원 수만큼의 `UserSubmission`이 존재한다 (1:N).
/// 실시간으로 "OO님이 작성 중" 상태를 표시하는 데 사용된다.
struct UserSubmission: Sendable, Equatable, Identifiable {

    /// 제출 상태 고유 식별자
    let id: UUID

    /// 소속 세션의 식별자
    ///
    /// ``RetrospectSession``의 `id`를 참조한다.
    let sessionId: UUID

    /// 팀원의 사용자 식별자
    let userId: String

    /// 제출 상태
    ///
    /// - ``SubmissionStatus/writing``: 작성 중. typing indicator 표시 가능
    /// - ``SubmissionStatus/submitted``: 제출 완료. 수정 불가
    let status: SubmissionStatus

    /// 제출 시각
    ///
    /// `status`가 ``SubmissionStatus/submitted``일 때만 값이 있다.
    let submittedAt: Date?
}
