//
//  RetrospectError.swift
//  RetroApp
//
//  Created by J on 3/26/26.
//

import Foundation

/// 회고 관련 비즈니스 에러를 나타내는 열거형.
///
/// UseCase에서 비즈니스 규칙 위반 시 throw한다.
enum RetrospectError: LocalizedError, Sendable {

    /// 회고 항목이 0개 일 때 생성/수정/확정 시도
    case emptyItems

    /// 이미 확정된 회고를 다시 확정 시도
    case alreadyConfirmed

    /// 요청한 회고를 찾을 수 없음
    case retrospectNotFound

    /// 요청한 회고 항목을 찾을 수 없음
    case itemNotFound

    /// 요청한 회고 포맷을 찾을 수 없음
    case formatNotFound

    /// 빌트인 포맷을 삭제 시도
    case cannotDeleteBuiltInFormat

    /// 항목의 retrospectId가 불일치할 때
    case mismatchedRetrospectId

    var errorDescription: String? {
        switch self {
        case .emptyItems:
            return "항목이 최소 1개 이상 필요합니다"
        case .alreadyConfirmed:
            return "이미 제출된 회고입니다"
        case .retrospectNotFound:
            return "회고를 찾을 수 없습니다"
        case .itemNotFound:
            return "회고 항목을 찾을 수 없습니다"
        case .formatNotFound:
            return "회고 포맷을 찾을 수 없습니다"
        case .mismatchedRetrospectId:
            return "항목의 회고 ID가 일치하지 않습니다"
        case .cannotDeleteBuiltInFormat:
            return "기본 제공 포맷은 삭제할 수 없습니다"

        }
    }
}
