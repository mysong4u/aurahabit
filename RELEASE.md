# Aura: Focus & Habit Tracker 앱스토어 출시 가이드 (RELEASE.md)

이 문서는 개발이 완료된 **Aura: Focus & Habit Tracker** 앱을 Apple App Store에 유료 앱으로 성공적으로 출시하기 위한 전체 절차와 Xcode 설정법을 가장 이해하기 쉽게 정리한 가이드입니다.

---

## 1. 출시 전 필수 준비 파일 및 에셋

### 🎨 1. 앱 아이콘 (App Icon)
* **요구 규격:** **1024 x 1024 픽셀 (PNG 형식, 알파 채널/투명도 없음)**
* **설정 방법:** 
  1. Xcode를 엽니다.
  2. 왼쪽 파일 목록에서 `Sources` 폴더 안의 `Assets.xcassets`를 클릭합니다. (없다면 Xcode에서 생성 가능)
  3. `AppIcon` 항목을 선택하고 준비한 1024x1024 이미지를 드래그 앤 드롭으로 넣습니다.

### 📸 2. 앱스토어 스크린샷 (Screenshots)
사용자에게 앱의 아름다운 UI를 보여줄 스크린샷이 필요합니다. (최소 3장 이상 권장)
* **필수 해상도 및 사이즈:**
  * **6.5인치 iPhone용 (최신 기종):** `1242 x 2688 픽셀` 또는 `1290 x 2796 픽셀` (iPhone 14/15/16 Pro Max 등에서 캡처 가능)
  * **5.5인치 iPhone용 (홈버튼 기종):** `1242 x 2208 픽셀` (iPhone 8 Plus 등에서 캡처 가능)

### 📄 3. 법적 필수 문서 (개인정보처리방침 - Privacy Policy)
* 서버가 없는 로컬 앱이더라도 앱스토어 출시를 위해서는 **개인정보처리방침 웹페이지 링크(URL)**가 필수적입니다.
* **해결 팁:** 본 앱은 서버가 없고 어떤 개인정보도 수집하지 않으므로, [Github Pages](https://pages.github.com/)나 무료 블로그(Velog, Tistory 등), 혹은 Notion에 간단히 *"Aura 앱은 어떠한 개인정보도 서버에 수집하거나 공유하지 않으며, 모든 데이터는 기기 내부에만 안전하게 저장됩니다."*라고 적은 뒤 해당 링크를 제출하시면 통과됩니다.

---

## 2. 앱스토어 출시 5단계 절차 (Step-by-Step)

### 1단계: Apple 개발자 계정 등록
1. [Apple Developer Program](https://developer.apple.com/programs/)에 접속합니다.
2. 사용 중인 Apple ID로 로그인한 후 연간 등록비(약 129,000원 / $99)를 결제하여 개발자 계정을 활성화합니다.

### 2단계: App Store Connect에 앱 등록
1. [App Store Connect](https://appstoreconnect.apple.com/) 사이트에 접속합니다.
2. **`나의 앱`** 메뉴에서 왼쪽 위의 **`+` (신규 앱 추가)** 버튼을 누릅니다.
3. 다음 설정을 입력합니다.
   * **플랫폼:** iOS
   * **이름:** `Aura: Focus & Habit Tracker` (중복된 이름은 사용할 수 없으므로 부제목을 조합하는 것이 좋습니다)
   * **기본 언어:** 한국어 (또는 영어)
   * **번들 ID (Bundle ID):** `com.air.AuraHabit` 선택
   * **SKU:** 고유 식별자 (예: `com.air.AuraHabit.sku`)
   * **사용자 액세스:** 제한 없음

### 3단계: Xcode에서 아카이브(Archive) 및 업로드
1. Xcode의 상단 기기 선택 영역에서 실제 기기가 아닌 **`Any iOS Device (arm64)`**를 선택합니다.
2. Xcode 상단 메뉴에서 **`Product > Archive`**를 클릭합니다. (빌드가 시작되며 앱의 배포용 패키지가 제작됩니다)
3. 빌드가 완료되면 **Organizer** 창이 자동으로 열립니다.
4. 우측의 **`Distribute App`** 파란색 버튼을 클릭합니다.
5. 안내에 따라 다음을 선택합니다.
   * **`Custom`** 또는 **`App Store Connect`** 선택
   * **`Upload`** 선택
   * 이후 자동 서명(Automatic Signing)을 완료하면 앱이 Apple App Store Connect 서버로 안전하게 전송됩니다.

### 4단계: App Store Connect에서 메타데이터 & 유료 가격 설정
앱이 성공적으로 업로드되면 몇 분 뒤 App Store Connect 웹사이트에 반영됩니다.
1. **앱 정보 및 가격 설정:**
   * **`가격 및 판매 범위`** 메뉴로 이동합니다.
   * 유료 앱으로 판매할 **가격 등급(Price Tier)**을 선택합니다. (예: Tier 5 - 약 7,500원 등 원하는 유료 가격 지정)
   * 전 세계 모든 국가에서 다운로드받을 수 있도록 판매 국가 전체를 체크합니다. (다국어가 지원되므로 글로벌 마켓 필수 오픈!)
2. **버전 정보 작성:**
   * 준비한 **스크린샷**, **앱 설명**, **키워드(검색 태그)**를 입력합니다.
   * 방금 Xcode에서 업로드한 **빌드(Build)** 파일을 목록에서 찾아 선택해 줍니다.
   * **개인정보처리방침 URL**을 입력합니다.

### 5단계: 심사 제출 (Submit for Review)
1. 모든 정보 입력과 빌드 선택이 끝났다면 오른쪽 위의 **`심사 제출 (Add for Review)`** 버튼을 누릅니다.
2. 1~2일 내로 Apple 심사위원의 검토가 이루어지며, 통과 시 **전 세계 App Store에 유료 앱으로 즉시 출시**됩니다! 🚀
