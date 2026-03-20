//
//  Team.swift
//  RetroApp
//
//  Created by J on 3/20/26.
//

import Foundation

/// 팀을 나타내는 Entity
///
/// 팀은 여러 ``TeamMember``와 여러 ``RetrospectSession``을 가진다.
/// 팀 생성 시 초대 코드가 자동 생성되며, 다른 사용자는 이 코드로 참여할 수 있다.
///
/// ## 인원 제한
/// - 기본: 2명
/// - 프리미엄: 10명
struct Team {

    /// 팀 고유 식별자
    let id: UUID

    /// 팀 이름
    let name: String

    /// 팀 초대 코드
    ///
    /// 팀 생성 시 자동 생성. 다른 사용자가 이 코드를 입력하여 팀에 참여한다.
    let inviteCode: String

    /// 팀 생성자(소유자)의 사용자 식별자
    ///
    /// Sign in with Apple에서 발급받은 사용자 ID.
    let ownerId: String

    /// 팀 생성 시각
    let createdAt: Date
}

/// 팀에 소속된 개별 팀원을 나타내는 Domain Entity.
///
/// 하나의 ``Team``에 여러 `TeamMember`가 속한다 (1:N).
struct TeamMember {

    /// 팀원 고유 식별자
    let id: UUID

    /// 소속 팀의 식별자
    ///
    /// ``Team``의 `id`를 참조한다.
    let teamId: UUID

    /// 사용자 식별자
    ///
    /// Sign in with Apple에서 발급받은 사용자 ID.
    let userId: String

    /// 팀 내 표시 이름
    let displayName: String

    /// 팀 참여 시각
    let joinedAt: Date
}

