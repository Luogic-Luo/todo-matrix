# 待办矩阵 (Todo Matrix)

一款基于艾森豪威尔矩阵的现代化待办事项管理应用，支持 Android 和 Windows 桌面端。

## 功能特性

- **收集箱 (Inbox)** — 快速添加任务，支持划动删除和完成标记。已完成任务自动归档到可折叠的历史面板
- **日历视图 (Calendar)** — 中文日历，按日期查看任务，支持快速跳转到指定日期添加任务
- **艾森豪威尔矩阵 (Matrix)** — 四象限任务管理（紧急且重要 / 不紧急但重要 / 紧急但不重要 / 不紧急且不重要），支持拖拽移动任务到不同象限
- **任务详情** — 编辑任务标题、描述、截止日期、优先级和象限分类

## 技术栈

- **框架**: Flutter 3.27 + Dart 3.6
- **状态管理**: Riverpod 2.x
- **路由**: GoRouter
- **数据库**: SQLite (sqflite / sqflite_common_ffi)
- **代码生成**: Freezed + Riverpod Generator
- **字体**: Noto Sans SC (思源黑体)
- **日历组件**: table_calendar

## 截图

<img src="screenshots/inbox.png" width="200" /> <img src="screenshots/calendar.png" width="200" /> <img src="screenshots/matrix.png" width="200" />

## 构建运行

### 环境要求

- Flutter 3.27.0+
- Dart 3.6.0+
- Android SDK 34+ (Android 构建)
- Visual Studio 2022 (Windows 桌面构建)

### 安装依赖

```bash
flutter pub get
dart run build_runner build
```

### 运行

```bash
# Android
flutter run -d android

# Windows 桌面
flutter run -d windows
```

### 构建 APK

```bash
flutter build apk --release
```

## 项目结构

```
lib/
├── main.dart                        # 入口, 平台适配
├── app.dart                         # MaterialApp 配置
├── core/
│   ├── constants/                   # 常量 (字符串/颜色/尺寸)
│   ├── theme/                       # 主题 (亮色/暗色)
│   └── widgets/                     # 通用组件
├── data/
│   ├── database/                    # SQLite 数据库
│   ├── datasources/                 # 本地数据源
│   ├── models/                      # 数据模型 (Freezed)
│   └── repositories/                # 仓库实现
├── domain/
│   ├── entities/                    # 领域实体
│   ├── enums/                       # 枚举 (状态/优先级/象限)
│   └── repositories/                # 仓库接口
└── presentation/
    ├── providers/                   # Riverpod 状态管理
    ├── screens/                     # 页面
    │   ├── inbox/                   # 收集箱
    │   ├── calendar/                # 日历
    │   ├── matrix/                  # 矩阵
    │   └── task_detail/             # 任务详情
    └── shared_widgets/              # 共享组件
```

## License

MIT
