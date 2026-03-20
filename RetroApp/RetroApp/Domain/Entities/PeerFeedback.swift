//
//  PeerFeedback.swift
//  RetroApp
//
//  Created by J on 3/20/26.
//

import Foundation

/// CSS(Continue/Stop/Start) 피어 피드백을 나타내는 Domain Entity.
///
/// 팀 회고 세션 후 팀원 간에 주고받는 행동 피드백이다.
/// 한 팀원이 다른 팀원에게 "계속 해줘 / 그만 해줘 / 새로 해줘"를 전달한다.
///
/// ## 익명 설정
/// 세션의 ``RetrospectSession/isAnonymousFeedback``가 `true`이면,
/// ``fromUserId``가 수신자에게 공개되지 않는다.
/// Presentation 레이어에서 익명 여부에 따라 표시를 분기한다.
///
/// ## 예시
/// ```
/// 진영 → 민지:
///   Continue: "코드 리뷰 꼼꼼하게 해주는 거"
///   Stop: "회의 중에 말 끊기"
///   Start: "PR 설명 좀 더 자세히 써주기"
/// ```
struct PeerFeedback: Sendable, Equatable, Identifiable {

    /// 피드백 고유 식별자
    let id: UUID

    /// 피드백이 작성된 세션의 식별자
    ///
    /// ``RetrospectSession``의 `id`를 참조한다.
    let sessionId: UUID

    /// 피드백 작성자의 사용자 식별자
    ///
    /// 익명 모드에서는 수신자에게 공개되지 않는다.
    let fromUserId: String

    /// 피드백 수신자의 사용자 식별자
    let toUserId: String

    /// 피드백 카테고리
    ///
    /// CSS(Continue/Stop/Start) 중 하나.
    let category: PeerFeedbackCategory

    /// 피드백 내용
    let content: String

    /// 익명 여부
    ///
    /// 세션의 ``RetrospectSession/isAnonymousFeedback`` 설정을 따른다.
    let isAnonymous: Bool

    /// 피드백 작성 시각
    let createdAt: Date
}
