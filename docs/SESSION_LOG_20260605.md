# 会话记录：ArtistOS cerro 调试与补丁归档

> 日期：2026-06-03 ~ 2026-06-05  
> 工作区：`/home/rong/LineageOS_cerro`  
> 关联 transcript：`2e30ed33-ae11-45b5-9f08-cf1d92fe2542`

---

## 会话目标演进

1. 为 cerro 编译 **ArtistOS**（LineageOS 23.2）：品牌、人脸、数据卡 Tile、TEE 等
2. 加入 **加强隐藏**（隐藏 LOS 应用 + 隐藏 `ro.lineage.*` / pixelprops）
3. 设备 **SystemUI RescueParty 崩溃循环**
4. 用户确认：**加强隐藏是根因**，要求撤销隐藏、恢复人脸、恢复 04:01 前状态
5. 修复编译、成功 `brunch cerro`，补丁推送到 GitHub

---

## 时间线

| 阶段 | 事件 |
|------|------|
| 早期 | 隐藏 Lineage 应用（PM/ATMS）、Launcher seeder、Settings UI、bionic prop hook |
| 刷机后 | SystemUI / Launcher3 崩溃：`lineagesettings` provider 找不到 |
| 诊断 | 添加 LineageSettings SDK 容错 + SystemUI/Launcher 安全 observer |
| 用户判断 | 认为加强隐藏导致问题，与人脸无关 |
| 回滚 | 删除 `LineageVisibilityHelper`、`artist_prop_hide`、Settings/Launcher 隐藏 UI |
| 恢复 | 从 InfinityX 恢复人脸；`KeyguardIndicationController` 改回 Lineage + 最小补丁 |
| 编译 1 | 失败：`lmofreeform-display-adapter-java` 不存在 → 删 Android.bp 引用 |
| 编译 2 | 失败：InfinityX Blueprint / Settings 孤儿文件 → 修复 |
| 编译 3 | 失败：InfinityX `KeyguardIndicationController` OEM 符号 → checkout + 补丁 |
| 编译 4 | **成功**；zip SHA256 `9a1a54f...` |
| 归档 | `repo diff` → `backup_all_changes_20260605.patch` + `addon_files/` |
| GitHub | 推送到 [LineageOS_cerro_patchs](https://github.com/ycrrongos/LineageOS_cerro_patchs) |
| push 问题 | shallow clone → `git fetch --unshallow`；分支 `main`；代理 `127.0.0.1:7890` |

---

## 用户原话要点

- 「如果这么说的话，就是我早上让你隐藏应用搞得鬼，请你恢复隐藏 los 应用和隐藏 prop。然后恢复你今天 04:01 之前的所有操作。人脸也恢复回来」
- 「我确认了，就是加强隐藏时出问题了。」
- 「把我对系统做的所有修改传到 GitHub LineageOS_cerro_patchs」
- 「请你连接 flclash 后再 push」

---

## 助手执行摘要

### 已撤销

- `LineageVisibilityHelper.java` 及 PM/ATMS 改动
- `artist_prop_hide` bionic hook
- Settings `LineageVisibilityExcludedApps*` / Launcher `LineageHiddenAppsSeeder`
- 未完成 `PlayStoreInstallSpoofSwitchPreference.kt`

### 已恢复 / 保留

- 人脸解锁全套（FaceUnlock + SystemUI sense HAL + Top indication area）
- LineageSettings 容错 + adb 公钥
- ArtistOS 品牌 overlay、数据卡 Tile、其它 split_patches 功能
- `global_actions_avatar_size` dimen 补回

### 编译产物

```
out/target/product/cerro/lineage-23.2-20260605-UNOFFICIAL-cerro.zip
SHA256: 9a1a54fcee3d33ce0769c8f5a9863d76bc470759e2d21ddfed4eaa736d40a7cc
```

### GitHub 仓库结构

```
LineageOS_cerro_patchs/
├── backup_all_changes_20260605.patch
├── addon_files/          # FaceUnlock、新增源码
├── vendor_artist/        # config + overlay
├── split_patches/
├── apply_addon_files.sh
├── patch_diff.sh
└── docs/                 # 本目录
```

---

## 待办 / 风险（会话结束时）

- [ ] 真机刷 `9a1a54f...` zip 验证人脸 + 无 RescueParty
- [ ] 勿重新应用 `04_lineage_visibility_*` 中隐藏相关 hunk
- [ ] 若再改 SystemUI，避免整文件覆盖 InfinityX 版 `KeyguardIndicationController`

---

## 相关链接

- 补丁仓库：https://github.com/ycrrongos/LineageOS_cerro_patchs
- 上游补丁结构：https://github.com/WeiguangTWK/patches_for_build_marble_AOSP
