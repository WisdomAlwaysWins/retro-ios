//
//  CoreDataStack.swift
//  RetroApp
//
//  Created by J on 3/26/26.
//

import CoreData
import Foundation

/// Core Data 스택을 관리하는 클래스.
///
/// 앱 전체에서 하나의 인스턴스만 사용한다.
/// `viewContext`는 메인 스레드에서, `backgroundContext`는 백그라운드에서 사용한다.
///
/// ## Data 레이어 소속
/// Domain 레이어는 이 클래스를 알지 못한다.
/// Repository 구현체에서만 사용한다.
final class CoreDataStack {

    // MARK: - Properties

    /// Core Data 컨테이너
    ///
    /// "RetroApp"은 .xcdatamodeld 파일 이름과 동일해야 한다.
    private let container: NSPersistentContainer

    /// 메인 스레드용 Context
    ///
    /// UI에서 데이터를 읽을 때 사용한다.
    /// 항상 메인 스레드에서만 접근해야 한다.
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    // MARK: - Init

    /// CoreDataStack을 초기화한다.
    ///
    /// - Parameter modelName: .xcdatamodeld 파일 이름. 기본값 "RetroApp"
    init(modelName: String = "RetroApp") throws {
        container = NSPersistentContainer(name: modelName)

        var loadError: Error?

        // SQLite 파일을 열어서 준비하는 과정
        container.loadPersistentStores { _, error in
            loadError = error
        }

        if let loadError {
            throw loadError
        }

        // 백그라운드에서 저장하면 viewContext에 자동 반영
        container.viewContext.automaticallyMergesChangesFromParent = true

        // 같은 객체를 중복 생성하지 않고 기존 객체를 재사용
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }

    // MARK: - Methods

    /// 백그라운드 작업용 Context를 생성한다.
    ///
    /// 무거운 저장/조회 작업을 메인 스레드를 막지 않고 처리할 때 사용한다.
    /// 사용 후 `save()`를 호출해야 반영된다.
    func newBackgroundContext() -> NSManagedObjectContext {
        container.newBackgroundContext()
    }

    /// Context의 변경사항을 저장한다.
    ///
    /// 변경사항이 없으면 아무것도 하지 않는다.
    /// - Parameter context: 저장할 Context
    func saveContext(_ context: NSManagedObjectContext) throws {
        try context.performAndWait {
            guard context.hasChanges else { return }
            try context.save()
        }
    }
}
