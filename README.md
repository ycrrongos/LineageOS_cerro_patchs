# LineageOS cerro (ArtistOS) patches

针对努比亚 Z60 Ultra (`cerro`) 的 LineageOS 23.2 / ArtistOS 定制补丁集合。

目标仓库：[ycrrongos/LineageOS_cerro_patchs](https://github.com/ycrrongos/LineageOS_cerro_patchs)

## 功能概览

- **ArtistOS 品牌**：`vendor/artist` overlay + 产品配置
- **人脸解锁**：FaceUnlock 应用 + SystemUI / frameworks 集成
- **数据卡切换 Tile**（QS）
- **TEE 软模拟 / keystore2** 相关改动
- **LineageSettings 启动容错**（避免 SystemUI RescueParty）
- **adb 公钥预授权**（userdebug/eng）
- **区域/体验类**：NTP、Updater、Dolby、EROFS、GKI、mimalloc 等（见 `split_patches/`）
- **平台稳定性修复**（clipboard、BLASTBufferQueue 等）

> **注意**：全局隐藏 Lineage 应用 / bionic 隐藏 `ro.lineage.*` 的「加强隐藏」方案已确认会导致 SystemUI 崩溃，**不在当前补丁中**。请勿应用 `split_patches/04_*` 里与 `LineageVisibilityHelper` / `artist_prop_hide` 相关的旧内容；以 `backup_all_changes_20260605.patch` 为准。

## 使用方法

在 LineageOS 源码根目录：

```bash
git clone https://github.com/ycrrongos/LineageOS_cerro_patchs vendor/artist/patches
# 或 clone 到任意目录后复制

cd vendor/artist/patches   # 或你的 clone 路径
chmod +x patch_diff.sh apply_addon_files.sh

# 1. 应用 repo diff（修改已有文件）
./patch_diff.sh backup_all_changes_20260605.patch

# 2. 复制新增文件（FaceUnlock、人脸 UI、vendor/artist 等）
./apply_addon_files.sh /path/to/LineageOS_cerro

# 3. 可选：按主题应用 split_patches（需自行核对是否与 backup 重复）
# ./patch_diff.sh split_patches/01_tee_soft_emulate.patch
```

`device/nubia/cerro/lineage_cerro.mk` 需包含：

```makefile
$(call inherit-product, vendor/artist/config/artist.mk)
```

（已包含在 `addon_files/device/nubia/cerro/lineage_cerro.mk`）

## 目录说明

| 路径 | 说明 |
|------|------|
| `backup_all_changes_20260605.patch` | 当前完整 `repo diff`（2026-06-05 编译成功版本） |
| `addon_files/` | `repo diff` 不包含的新增文件 |
| `vendor_artist/` | `vendor/artist/config` 与 overlay |
| `split_patches/` | 按主题拆分的历史补丁（部分可能过时） |
| `local_manifests/` | 额外 repo manifest（mimalloc 等） |
| `patch_diff.sh` | 应用 `repo diff` 格式补丁 |
| `docs/KNOWLEDGE_BASE.md` | **知识库**：功能、根因、踩坑、刷机验证 |
| `docs/SESSION_LOG_20260605.md` | **会话记录**：时间线与决策摘要 |

## 编译

```bash
source build/envsetup.sh
breakfast cerro
brunch cerro
```

## 致谢

基于 [WeiguangTWK/patches_for_build_marble_AOSP](https://github.com/WeiguangTWK/patches_for_build_marble_AOSP) 结构整理；人脸解锁参考 Paranoid Sense / InfinityX；TEE 相关参考 TEESimulator 等社区方案。
