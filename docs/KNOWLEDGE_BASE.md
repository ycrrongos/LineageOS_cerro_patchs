# ArtistOS cerro 知识库

> 设备：努比亚 Z60 Ultra (`cerro`) · LineageOS 23.2 · 品牌 ArtistOS  
> 补丁仓库：[ycrrongos/LineageOS_cerro_patchs](https://github.com/ycrrongos/LineageOS_cerro_patchs)  
> 最后更新：2026-06-05

---

## 1. 项目概览

| 项 | 值 |
|---|---|
| 源码树 | `/home/rong/LineageOS_cerro` |
| 产品名 | `lineage_cerro` / ArtistOS |
| 编译 | `source build/envsetup.sh && breakfast cerro && brunch cerro` |
| 产物 | `out/target/product/cerro/lineage-23.2-*-UNOFFICIAL-cerro.zip` |
| 已验证 ROM (2026-06-05) | SHA256 `9a1a54fcee3d33ce0769c8f5a9863d76bc470759e2d21ddfed4eaa736d40a7cc` |

---

## 2. 功能清单（当前保留）

### 2.1 ArtistOS 品牌

- `vendor/artist/config/artist.mk`：`PRODUCT_BRAND := ArtistOS`
- `vendor/artist/overlay/no-rro/`：Settings / LineageParts 字符串 overlay
- `device/nubia/cerro/lineage_cerro.mk`：`inherit-product vendor/artist/config/artist.mk`

### 2.2 人脸解锁

- 应用：`packages/apps/FaceUnlock`（Paranoid Sense / InfinityX 移植）
- SystemUI：`FaceUnlockImageView`、`DefaultIndicationAreaTopSection`、`KeyguardIndicationAreaTop`
- **关键**：`KeyguardIndicationController.java` 必须用 **Lineage 基线 + 最小人脸补丁**，不可整文件覆盖 InfinityX 版（会引用 `ScrimUtils`、OEM 快充等不存在符号）
- `DefaultKeyguardBlueprint.kt`：Lineage 布局 + 仅增加 `DefaultIndicationAreaTopSection`（不要用 InfinityX 专有 Section）

### 2.3 数据卡切换 Tile

- `DataSwitchTile.java` + QS drawable（在 `addon_files` 中）

### 2.4 LineageSettings 启动容错（防 RescueParty）

- `lineage-sdk/.../LineageSettings.java`：Provider 为 null 时不 NPE；安全 `registerContentObserver`
- SystemUI / Launcher3 多处改用安全 observer（Clock、EdgeBackGestureHandler、SettingsCache 等）

### 2.5 adb 公钥预授权

- `vendor/artist/config/adb_keys.pub` + `PRODUCT_ADB_KEYS`
- 产物路径：`/product/etc/security/adb_keys`（userdebug/eng）

### 2.6 其它平台补丁（见 split_patches/）

- TEE 软模拟 / keystore2
- mimalloc、EROFS、GKI、Dolby、Updater、区域 NTP 等
- 详见 `split_patches/` 各文件

---

## 3. 已确认根因：「加强隐藏」导致崩溃

**结论（用户已确认）**：SystemUI RescueParty 循环由 **加强隐藏** 引起，**不是**人脸解锁。

### 3.1 问题改动（已撤销，勿再启用）

| 改动 | 路径/说明 |
|------|-----------|
| 全局隐藏 Lineage 应用 | `LineageVisibilityHelper.java`，PM/ATMS `ComputerEngine`、`ActivityStarter` |
| Launcher 默认隐藏 | `LineageHiddenAppsSeeder.java`、`HiddenAppsFilter.java` |
| Settings 排除列表 UI | `LineageVisibilityExcludedApps*` 等 |
| bionic 隐藏 prop | `artist_prop_hide.cpp/.h`，hook `system_property_api.cpp` |

### 3.2 典型崩溃日志

```
SecurityException: Failed to find provider lineagesettings for user 0
NPE: IContentProvider is null (LineageSettings.System.getIntForUser)
RescueParty: com.android.systemui
```

影响 **SystemUI** 与 **Launcher3**（SettingsCache ContentObserver）。

### 3.3 若将来再做「隐藏」

- 禁止全局 PM hook + bionic prop hook 组合
- 仅考虑应用层、用户可选、且不影响 `lineagesettings` 启动时序的方案
- 任何改动需单独 `brunch` + adb `logcat -b crash` 验证

---

## 4. 编译踩坑记录

| 错误 | 原因 | 修复 |
|------|------|------|
| `lmofreeform-display-adapter-java` undefined | `services/core/Android.bp` 无效依赖 | 删除该行 |
| InfinityX `DefaultKeyguardBlueprint` 缺 Section | 整文件来自 InfinityX | 恢复 Lineage + 仅 TopSection |
| `KeyguardIndicationController` 24 个 javac 错误 | InfinityX OEM 代码 | `git checkout` Lineage 后打最小人脸补丁 |
| `global_actions_avatar_size` 缺失 | Lineage power menu 提交丢失 dimen | `dimens.xml` 补 `24dp`（commit `038e5e066aed`） |
| `PlayStoreInstallSpoofSwitchPreference` 无字符串 | 未完成 patch | 删除孤儿文件 |
| push `did not receive expected object` | patches 仓库 shallow clone | `git fetch --unshallow` 后 push |

---

## 5. 补丁应用流程

```bash
git clone https://github.com/ycrrongos/LineageOS_cerro_patchs vendor/artist/patches
cd vendor/artist/patches
chmod +x patch_diff.sh apply_addon_files.sh

# 修改已有文件
./patch_diff.sh backup_all_changes_20260605.patch

# 新增文件（FaceUnlock、人脸 UI、vendor/artist 等）
./apply_addon_files.sh /path/to/LineageOS_cerro
```

**注意**：`split_patches/04_lineage_visibility_*` 含已撤销的隐藏逻辑，**以 `backup_all_changes_20260605.patch` 为准**。

---

## 6. 刷机与验证

```bash
sha256sum out/target/product/cerro/lineage-23.2-*-UNOFFICIAL-cerro.zip
# 必须与 .sha256sum 中最新条目一致

adb shell wc -c /product/etc/security/adb_keys   # userdebug 预授权
adb logcat -d -b crash                            # 刷后检查崩溃
```

一般**不必清数据**刷机（代码层修复，非脏数据问题）。

---

## 7. Git / 代理

- 补丁仓库远程：`https://github.com/ycrrongos/LineageOS_cerro_patchs.git`
- 默认分支：`main`
- 推送需代理（FlClash 混合端口）：

```bash
export http_proxy=http://127.0.0.1:7890 https_proxy=http://127.0.0.1:7890
cd vendor/artist/patches && git push
```

- shallow 仓库 push 失败时：

```bash
git fetch --unshallow https://github.com/WeiguangTWK/patches_for_build_marble_AOSP.git lineage-23.2
git push -u origin main
```

---

## 8. 关键路径速查

```
vendor/artist/config/artist.mk              # 产品配置
vendor/artist/patches/                        # 补丁 Git 仓库
lineage-sdk/.../LineageSettings.java        # SDK 容错
frameworks/base/packages/SystemUI/          # 人脸 + SystemUI
packages/apps/FaceUnlock/                   # 人脸应用
device/nubia/cerro/lineage_cerro.mk         # inherit artist.mk
```

---

## 9. 致谢与参考

- 补丁结构源自 [WeiguangTWK/patches_for_build_marble_AOSP](https://github.com/WeiguangTWK/patches_for_build_marble_AOSP)
- 人脸：Paranoid Sense / InfinityX
- TEE：TEESimulator 等社区方案
- HMA-OSS：Lineage 应用检测思路（**当前未采用全局隐藏方案**）
