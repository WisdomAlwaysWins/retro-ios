//
//  RetrospectFormatMapper.swift
//  RetroApp
//
//  Created by J on 3/30/26.
//

import CoreData
import Foundation

/// ``RetrospectFormat`` Domain Entity와 Core Data ManagedObject 간 변환을 담당하는 Mapper.
///
/// ## categories 변환
/// `[CategoryTemplate]`은 Core Data에 직접 저장할 수 없으므로,
/// JSON 문자열로 인코딩하여 `categoriesJSON` Attribute에 저장한다.
enum RetrospectFormatMapper {

    // MARK: - ManagedObject → Domain Entity

    static func toEntity(_ managed: RetrospectFormatEntity) -> RetrospectFormat {
        let categories = decodeCategories(from: managed.categoriesJSON ?? "[]")

        return RetrospectFormat(
            id: managed.id ?? UUID(),
            name: managed.name ?? "",
            categories: categories,
            isBuiltIn: managed.isBuiltIn,
            description: managed.descriptionText ?? "",
            recommendWhen: managed.recommendWhen ?? ""
        )
    }

    // MARK: - Domain Entity → ManagedObject

    static func toManagedObject(
        _ entity: RetrospectFormat,
        context: NSManagedObjectContext
    ) -> RetrospectFormatEntity {
        let managed = RetrospectFormatEntity(context: context)
        managed.id = entity.id
        managed.name = entity.name
        managed.categoriesJSON = encodeCategories(entity.categories)
        managed.isBuiltIn = entity.isBuiltIn
        managed.descriptionText = entity.description
        managed.recommendWhen = entity.recommendWhen
        return managed
    }

    // MARK: - Domain Entity → 기존 ManagedObject 업데이트

    static func update(_ managed: RetrospectFormatEntity, from entity: RetrospectFormat) {
        managed.name = entity.name
        managed.categoriesJSON = encodeCategories(entity.categories)
        managed.isBuiltIn = entity.isBuiltIn
        managed.descriptionText = entity.description
        managed.recommendWhen = entity.recommendWhen
    }

    // MARK: - JSON 변환 헬퍼

    /// [CategoryTemplate] → JSON 문자열
    private static func encodeCategories(_ categories: [CategoryTemplate]) -> String {
        let dicts = categories.map { category in
            [
                "name": category.name,
                "colorHex": category.colorHex,
                "order": "\(category.order)"
            ]
        }

        guard let data = try? JSONSerialization.data(withJSONObject: dicts),
              let json = String(data: data, encoding: .utf8) else {
            return "[]"
        }

        return json
    }

    /// JSON 문자열 → [CategoryTemplate]
    private static func decodeCategories(from json: String) -> [CategoryTemplate] {
        guard let data = json.data(using: .utf8),
              let dicts = try? JSONSerialization.jsonObject(with: data) as? [[String: String]] else {
            return []
        }

        return dicts.compactMap { dict in
            guard let name = dict["name"],
                  let colorHex = dict["colorHex"],
                  let orderString = dict["order"],
                  let order = Int(orderString) else {
                return nil
            }

            return CategoryTemplate(
                name: name,
                colorHex: colorHex,
                order: order
            )
        }
    }
}
