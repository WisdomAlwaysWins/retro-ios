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
    case notFound

    /// 빌트인 포맷을 삭제 시도
    case cannotDeleteBuiltInFormat

    var errorDescription: String? {
        switch self {
        case .emptyItems:
            return "항목이 최소 1개 이상 필요합니다"
        case .alreadyConfirmed:
            return "이미 제출된 회고입니다"
        case .notFound:
            return "회고를 찾을 수 없습니다"
        case .cannotDeleteBuiltInFormat:
            return "기본 제공 포맷은 삭제할 수 없습니다"
        }
    }
}
