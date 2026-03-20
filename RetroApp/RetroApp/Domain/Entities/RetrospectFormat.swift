//
//  RetrospectFormat.swift
//  RetroApp
//
//  Created by J on 3/20/26.
//

import Foundation

/// 회고 방법론(포맷)을 정의하는 Domain Entity.
///
/// KPT, 4Ls, Start-Stop-Continue 등 각 회고 방법론의
/// 이름, 카테고리 구성, 설명을 담고 있다.
///
/// ## 빌트인 vs 커스텀
/// - `isBuiltIn == true`: 앱에서 기본 제공하는 포맷. 삭제/수정 불가
/// - `isBuiltIn == false`: 사용자가 직접 생성한 커스텀 포맷
///
/// ## 추천 시스템
/// ``recommendWhen``을 기반으로 상황별 포맷 추천 배너를 표시한다.
struct RetrospectFormat: Sendable, Equatable, Identifiable {
    /// 포맷 고유 식별자
    let id: UUID

    /// 포맷 이름
    ///
    /// 예: "KPT", "4Ls", "Start-Stop-Continue"
    let name: String

    /// 포맷에 포함된 카테고리 목록
    ///
    /// 순서대로 화면에 표시된다.
    /// 예: KPT → [Keep, Problem, Try]
    let categories: [CategoryTemplate]

    /// 기본 제공 포맷 여부
    ///
    /// `true`이면 삭제/수정 불가.
    let isBuiltIn: Bool

    /// 포맷 설명
    ///
    /// 포맷 선택 화면에서 사용자에게 보여줄 한 줄 설명.
    /// 예: "일상적인 스프린트 회고에 적합"
    let description: String

    /// 추천 조건 설명
    ///
    /// 어떤 상황에서 이 포맷을 추천하는지.
    /// 예: "힘든 스프린트 후 감정 정리가 필요할 때"
    let recommendWhen: String
}

/// 포맷 내 개별 카테고리를 정의하는 값 객체.
///
/// ``RetrospectFormat``의 ``RetrospectFormat/categories``에 포함되며,
/// 카테고리의 이름, 색상, 표시 순서를 정의한다.
struct CategoryTemplate: Sendable, Equatable {
    /// 카테고리 이름
    ///
    /// ``RetrospectItem``의 ``RetrospectItem/categoryName``에 저장되는 값.
    /// 예: "Keep", "Problem", "Liked"
    let name: String

    /// 카테고리 색상 (HEX)
    ///
    /// UI에서 카테고리를 시각적으로 구분하는 데 사용한다.
    /// 예: "#10B981" (Keep 초록), "#F97316" (Problem 주황)
    let colorHex: String

    /// 표시 순서
    ///
    /// 0부터 시작. 화면에서 카테고리가 나열되는 순서.
    let order: Int
}
