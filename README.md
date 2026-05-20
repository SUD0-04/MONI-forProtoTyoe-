# MONI

<p align="center">
  <img src="https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=swift&logoColor=white" />
  <img src="https://img.shields.io/badge/SwiftUI-007AFF?style=flat-square&logo=apple&logoColor=white" />
  <img src="https://img.shields.io/badge/iOS-26.0+-000000?style=flat-square&logo=apple&logoColor=white" />
  <img src="https://img.shields.io/badge/Status-UI%20Prototype-8E8E93?style=flat-square" />
</p>

소프트웨어 공학 강의를 위한 SwiftUI 기반 가계부 프로토타입입니다.

MONI는 달력 중심의 홈 화면, 월 잔액 요약, 빠른 입력 흐름, 그리고 구독 회원을 위한  
Apple Intelligence 확장 기능의 UI 방향성을 검증하기 위해 제작되었습니다.

## Overview

MONI는 실제 기능 구현보다 사용자 경험과 시각적 흐름을 먼저 확인하기 위한 완전한 UI 프로토타입입니다.

현재 버전은 다음 요소를 중심으로 구성되어 있습니다.

- 시간대에 따라 달라지는 감성적인 상단 히어로 배경
- 월 잔액, 수입, 지출 요약
- 날짜 선택이 가능한 캘린더 대시보드
- 수입, 지출, 검색, 내보내기 빠른 실행 UI
- 구독 회원용 Apple Intelligence 기능 미리보기
- 영수증 OCR, AI 분류, Siri 입력 상태 UI
- 기능 섹션별 구성 목록

## Design Direction

MONI의 UI는 Apple Human Interface Guidelines를 기반으로 구성했습니다.

시각적 방향성은 다음 원칙을 따릅니다.

- 명확한 정보 계층
- 충분한 여백과 안정적인 정렬
- 시스템 친화적인 아이콘과 컨트롤
- 밝고 부드러운 금융 앱 분위기
- Toss와 BankSalad에서 볼 수 있는 잔액 중심의 간결한 홈 구조
- 시간대에 따라 자연스럽게 변화하는 감성적인 배경 표현

## Design References

- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- [SF Symbols](https://developer.apple.com/sf-symbols/)
- [Apple Intelligence](https://www.apple.com/apple-intelligence/)

## Prototype Scope

이 프로젝트는 실제 출시용 앱이 아닌 UI 프로토타입입니다.

현재 포함되지 않은 항목은 다음과 같습니다.

- 실제 데이터 저장
- 계정 인증
- iCloud 동기화
- StoreKit 구독 결제
- 실제 Apple Intelligence 연동
- OCR 분석
- Siri / App Intents 실제 동작
- Apple Watch / Widget Extension
- 서버 연동

## Tech Stack

- Swift
- SwiftUI
- Xcode
- iOS

## Main Screens

현재 프로토타입은 단일 SwiftUI 화면을 중심으로 구성되어 있습니다.

- Home
- Calendar Dashboard
- Daily Transaction Preview
- Quick Action Sheets
- Apple Intelligence Preview
- Feature Overview

## Project Structure

```text
MONI(ProtoType)/
├── MONI_ProtoType_App.swift
├── ContentView.swift
└── Assets.xcassets
