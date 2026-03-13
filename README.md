# patches_for_build_marble_AOSP_like_ROM

## CREDIT

[Chaitanyakm](https://github.com/Chaitanyakm): Provider of MIUI Camera blob, Maintaincer of CrDroid Offical for marble. He teaches me lot about basic solution searching, you are the best buddy!

[ArianK16a](https://github.com/ArianK16a): Maintaincer of marble device tree, told me the solution when I met difficulty

[Project CrDroid](https://github.com/crdroidandroid): These devs offered the solutions for new coming issues of Marble device, respect their hard work!

Team Paranoid & VoltageOS: Paranoid offer their way of face recognition and VoltageOS pack the source code of **Paranoid Sense** together with its close-source lib, making it more easy to integrate it into our own build



## Special Comments

Having more knowledge doesn't offer you chance to look down on the others but help them have a better life

——2019, opening ceremony of The University of Tokyo



## Features

1. Switch SCUDO to faster Mimalloc

2. Face Unlock (Credit Paranoid team and the [guy who bring it to LOS](https://review.lineageos.org/q/topic:%2223fu%22))
3. Switch from EXT4 to EROFS
4. \[for Chinese Users] Change NTP server
5. \[for Chinese Users] Change captive portal detection URL
6. \[for Chinese Users] Change default search engine of builtin browser
7. AVB & DM-verity Enabled
8. solve some of LineageOS detection (addon.d, gapps.rc)
9. Restore GKI compatibility (Credit Pzqqt)
10. ~~solve fingerprint issue in A15 QPR2~~ [origional commit](https://github.com/ederevx/android_build_soong/commit/64f5ef1087c38dbb173cbfa126abef1c422e6451)
11. ~~MIUI Camera now works, related commits:~~
    [64 MP crash fix](https://github.com/crdroidandroid/android_frameworks_base/commit/f4c3ffd3132789fb40e9982f3ab2351bce1a44a2)
    [CaptureResultExtras method fix](https://github.com/crdroidandroid/android_frameworks_base/commit/90ed8a47f1a65b0e80f8537a11eb3e44801964e4)
    [StreamConfigurationMap fix Part1](https://github.com/crdroidandroid/android_frameworks_base/commit/d79ce371f490fff6f5f754512414ad6ff4833a7e)
    [StreamConfigurationMap fix Part2](https://github.com/crdroidandroid/android_frameworks_base/commit/d8e22dd80f4f0c5f05a07094616a7af8ddecea6d)
    [Fix broken auto brightness](https://github.com/crdroidandroid/android_frameworks_base/commit/60ef8f6b7a578fad450c57a60c131a349b151644)
    [Add prop persist.sys.cam.skip_detach_image support](https://github.com/crdroidandroid/android_frameworks_base/commit/ba7d3b9347e52e0a5679dbf62e210e63dcf6bfa0)
    [Add onBufferDetached() needed by miui cam](https://github.com/crdroidandroid/android_frameworks_native/commit/0426f08afb27de79a12d424d780c9a2c0a346cec)

However LOS official for marble is already roll out so MIUI Cam fix for LOS is merged so manual patch is no longer needed

## How to use

First of all, use device and vendor from LineageOS Official, it is stable and easy to pass the compile process. But also you can try Device profile from [Chaitanyakm](https://github.com/Chaitanyakm), from him you can get bleeding edge changes for marble

1. clone this repo under your LineageOS source root

```
git clone --depth=1 https://github.com/WeiguangTWK/patches_for_build_marble_AOSP .
```

*1. copy folder local_mainfest into .repo then sync

```
repo sync -c
```

**1. also to build with miui camera, you need to extract blob from your phone first

```
cd device/xiaomi/miuicamera-marble
./extract-files.py
```

2. apply them according to your need

```
chmod +x ./patch_diff.sh
patch_diff.sh <diff file>
```

*3. To enable GMS, ont only you need to patch Enable GMS patch but also need to clone Mind The Gapps repo

```
git clone --depth=1 https://gitlab.com/MindTheGapps/vendor_gapps vendor/gapps
```

*4. Face Unlock

To set it up, you not only need to apply face unlock patch but also clone two more repos:

```
cd packages\apps
git clone --depth=1 https://gitlab.com/voltageos/packages_apps_paranoidsense -b 16.2 ParanoidSense
cd ../../vendor
git clone --depth=1 https://github.com/AOSPA/android_vendor_aospa -b beryl aospa
cp -r aospa/interfaces/biometrics lineage/interfaces
rm -rf aospa
```

Enjoy!

