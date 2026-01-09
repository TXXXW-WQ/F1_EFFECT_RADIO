# f1_effect_radio 🏎️🎙️

F1やSUPER GTの「チームラジオ」の世界観を再現した、モータースポーツ体験型・無線シミュレーター。
単なる通話アプリではなく、あの独特な「ピピッ」というビープ音や視覚的な波形エフェクトで、ドライバー気分を味わえます。

---

## 🏁 Overview
「Box, Box!」「Understood.」  
中継でお馴染みのあの音、あの緊張感。モータースポーツファンが興奮する「無線体験」をFlutterで形にしました。

- **リアルタイム通信**: Agora RTCを採用した超低遅延の音声通話。
- **無線演出 (Effect)**: 通信開始/終了時に鳴り響くビープ音（SE）を搭載。
- **ビジュアル演出**: `audio_waveforms` による動的なオーディオ・インジケーター。

---

## 🛠️ Tech Stack
最新のAIツールを活用したモダンな開発構成です。

- **Framework**: Flutter (Dart)
- **Infrastructure**: Agora RTC (Real-Time Communication)
- **Design Pattern**: Material 3 (Standard UI)
- **AI-Assisted Development**: 
  - GitHub Copilot (Code Completion)
  - Gemini (Architecture & Ideas)

---

## 🚀 Getting Started

本プロジェクトは個人開発の学習・体験用プロトタイプです。ローカル環境で動作させるには、以下のステップが必要です。

### 1. 前提条件
- Flutter SDK
- Android Studio (or VS Code)
- Agora.io アカウント（App IDの取得）

### 2. インストール & セットアップ
リポジトリをクローンします：
```bash
git clone [https://github.com/your-username/f1_effect_radio.git](https://github.com/your-username/f1_effect_radio.git)
cd f1_effect_radio
```

### 3. 環境変数の設定
プロジェクトのルートディレクトリに .env ファイルを作成し、取得したAgoraのApp IDを記述します。 （※セキュリティのため、このファイルはGit管理から除外されています）
```
AGORA_APP_ID=YOUR_AGORA_APP_ID_HERE
```

### 4. 実行
```bash
flutter pub get
flutter run
```

## Project Structure
- lib/: Flutterソースコード

- assets/: 無線用ビープ音 (.m4a) 等の音声リソース

- .env: 環境変数（各自で作成が必要）

## Disclaimer
本アプリはモータースポーツファンとしての趣味・学習を目的とした個人プロジェクトであり、商用利用やリリース・デプロイの予定はありません。
