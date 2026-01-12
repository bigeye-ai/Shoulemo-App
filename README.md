# 瘦了么 (Shoulemo) - 健康管理 iOS App

這是一個受「死了么」啟發的極簡主義健康管理 App，使用 Swift 6.0 和 SwiftUI 開發。

## 核心功能
- **每日簽到**: 強制性的體重記錄，培養健康習慣。
- **監督機制**: 綁定監督人郵箱，未簽到將觸發「告狀」提醒。
- **極簡設計**: 高對比度黑綠配色，專注於核心目標。
- **本地通知**: 每日定時提醒與緊急未簽到警告。

## 技術細節
- **SwiftData**: 用於本地持久化存儲體重記錄與用戶設置。
- **UserNotifications**: 實現本地推送邏輯。
- **SwiftUI**: 現代化聲明式 UI 佈局。

## 如何在 Xcode 中運行
1. 下載本專案代碼。
2. 打開 Xcode，選擇 `File > New > Project`。
3. 選擇 `iOS > App`，專案名稱填寫 `Shoulemo`。
4. 將本目錄下的 `Models`, `Views`, `Services` 文件夾以及 `ShoulemoApp.swift` 拖入 Xcode 專案中。
5. 確保 `Minimum Deployments` 設置為 iOS 17.0 或更高版本（以支持 SwiftData）。
6. 點擊 `Run` 即可在模擬器或真機運行。

## App Store 上架指南
### 1. 準備工作
- **開發者帳號**: 需要支付 99 美元/年的 Apple Developer Program 會員。
- **App 圖標**: 1024x1024 px 的高品質圖標。
- **截圖**: 至少準備 iPhone 6.7" 和 6.5" 的截圖。

### 2. App Store Connect 配置
- **名稱**: 瘦了么 - 極簡健康簽到
- **副標題**: 每天簽到，拒絕肥胖
- **類別**: 健康與健身 (Health & Fitness)
- **定價**: 建議 8 元人民幣（買斷制），與「死了么」保持一致。

### 3. 隱私政策
- 由於 App 收集體重數據，必須提供隱私政策網址。
- 聲明數據僅存儲於用戶本地設備（SwiftData 默認行為）。

### 4. 審核注意事項
- 確保「監督人郵箱」功能有明確的用戶說明。
- 避免在推送通知中使用過於激進或侮辱性的詞彙，以免違反 Apple 的審核準則（Human Interface Guidelines）。
