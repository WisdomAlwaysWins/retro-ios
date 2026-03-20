//
//  Enums.swift
//  RetroApp
//
//  Created by J on 3/20/26.
//

import Foundation

/// 회고의 상태를 나타내는 열거형.
///
/// 회고는 `draft`로 생성되어, 제출 시 `confirmed`로 전환된다.
/// 한번 `confirmed`되면 `draft`로 되돌릴 수 없다.
enum RetrospectStatus: String, Sendable, Codable, CaseIterable {
    /// 작성 중 상태. 자유롭게 수정 가능.
    case draft

    /// 제출 완료 상태. 수정 가능하지만 `isEdited` 플래그가 설정됨.
    case confirmed
}

/// 회고의 유형을 나타내는 열거형.
enum RetrospectType: String, Sendable, Codable, CaseIterable {
    /// 개인 회고. 로그인 없이 로컬에서 사용 가능.
    case personal

    /// 팀 회고. 로그인 필수, ``RetrospectSession``에 소속.
    case team
}

/// 팀 회고 세션의 상태를 나타내는 열거형.
///
/// 세션은 `inProgress`로 시작되어, 모든 팀원이 제출하면 `completed`로 전환된다.
enum SessionStatus: String, Sendable, Codable, CaseIterable {
    /// 진행 중. 팀원들이 작성 및 제출 가능.
    case inProgress

    /// 완료. 전원 제출 완료. 더 이상 수정/제출 불가.
    case completed
}

/// 팀 회고에서 개별 팀원의 제출 상태를 나타내는 열거형.
enum SubmissionStatus: String, Sendable, Codable, CaseIterable {
    /// 작성 중. typing indicator가 표시될 수 있다.
    case writing

    /// 제출 완료. 수정 불가.
    case submitted
}

/// CSS 피어 피드백의 카테고리를 나타내는 열거형.
///
/// Continue/Stop/Start 방법론에 기반한다.
enum PeerFeedbackCategory: String, Sendable, Codable, CaseIterable {
    /// 계속 해줬으면 하는 행동
    case continueDoing

    /// 그만 해줬으면 하는 행동
    case stopDoing

    /// 새로 시작해줬으면 하는 행동
    case startDoing
}
