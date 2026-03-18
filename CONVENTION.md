# 🌿 Branch Strategy

## 브랜치 구조

```
main          ← 릴리즈 전용
  └── develop ← 개발 기본 브랜치 (default)
       ├── feature/xxx  ← 새 기능
       ├── refactor/xxx ← 개선
       ├── fix/xxx      ← 버그 수정
       └── chore/xxx    ← 설정, 문서, 린트 등
```

## 브랜치 네이밍

```
feature/kpt-crud
refactor/network
fix/upload-crash
chore/swiftlint-setting
```

## 작업 흐름

1. `develop`에서 브랜치 생성
2. 작업 후 커밋
3. `develop`으로 PR 생성
4. 셀프 리뷰 후 머지
5. 릴리즈 시 `develop` → `main` PR

---

# 💬 Commit Convention

## 형식

```
🎨 타입: 제목

본문 (선택)
```

## 타입

| 타입 | 설명 |
| --- | --- |
| `✨ Feat:` | 새로운 기능 |
| `🐛 Fix:` | 버그 수정 |
| `♻️ Refactor:` | 리팩토링 (기능 변경 없음) |
| `🎨 Design:` | UI/레이아웃 작업 |
| `🧪 Test:` | 테스트 코드 |
| `🍀 Chore:` | 빌드, 설정, 문서 등 |
| `📄 Docs:` | 문서 작업 |
| `🔥 Remove:` | 파일/코드 삭제 |

## 예시

```
✨ Feat: KPT 회고 작성 화면 구현
♻️ Refactor: ViewModel 바인딩을 delegate에서 Combine으로 전환
🎨 Design: 회고 카드 셀 레이아웃 구현
🐛 Fix: 회고 저장 시 Core Data 크래시 수정
🍀 Chore: SwiftLint 설정 추가
🧪 Test: CreateRetroUseCase 유닛 테스트 추가
📄 Docs: README 프로젝트 소개 작성
```

---

# 📏 Code Convention

## 네이밍

| 대상 | 규칙 | 예시 |
| --- | --- | --- |
| 클래스/구조체 | UpperCamelCase | `RetroViewController` |
| 프로토콜 | UpperCamelCase + ~able/~ing/~Protocol | `RetroRepositoryProtocol` |
| 함수/변수 | lowerCamelCase | `fetchRetroList()` |
| 상수 | lowerCamelCase | `let maxRetroCount = 50` |
| enum case | lowerCamelCase | `case inProgress` |
| 약어 | 두 글자까지 대문자, 세 글자부터 카멜 | `id`, `url`, `kptItem` |

## 파일 네이밍

```
[기능명][레이어].swift

RetroListViewController.swift
RetroListViewModel.swift
RetroEntity.swift
RetroRepositoryProtocol.swift
CoreDataRetroRepository.swift
CreateRetroUseCase.swift
```

## 코드 스타일

### MARK 주석으로 섹션 구분

```swift
final class RetroListViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: RetroListViewModel

    // MARK: - UI Components

    private lazy var tableView: UITableView = { ... }()

    // MARK: - Lifecycle

    override func viewDidLoad() { ... }

    // MARK: - Methods

    private func bind() { ... }

    // MARK: - Actions

    @objc private func didTapAddButton() { ... }
}
```

### 접근 제어자 명시

```swift
// ✅ Good
private let retroRepository: RetroRepositoryProtocol
private func configureUI() { ... }

// ❌ Bad (접근제어자 생략)
let retroRepository: RetroRepositoryProtocol
func configureUI() { ... }
```

### final 키워드

```swift
// 상속이 필요 없는 클래스는 항상 final
final class RetroListViewController: UIViewController { }
final class RetroListViewModel { }
```

### self 사용

```swift
// 클로저 내부에서만 self 사용, 그 외에는 생략
tableView.rx.itemSelected
    .subscribe(onNext: { [weak self] indexPath in
        self?.navigateToDetail(at: indexPath)
    })
```

### 후행 클로저

```swift
// 파라미터 1개 → 후행 클로저
viewModel.$retroList
    .sink { [weak self] list in
        self?.applySnapshot(list)
    }
    .store(in: &cancellables)

// 파라미터 2개 이상 → 마지막만 후행 클로저
UIView.animate(withDuration: 0.3) {
    self.view.alpha = 1.0
}
```
