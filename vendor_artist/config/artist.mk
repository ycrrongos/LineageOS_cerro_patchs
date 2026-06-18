# ArtistOS product branding
PRODUCT_BRAND := ArtistOS

PRODUCT_PACKAGE_OVERLAYS += \
    vendor/artist/overlay/no-rro

# Pre-authorize developer adb key (no tap needed when SystemUI is broken)
ifneq ($(filter userdebug eng,$(TARGET_BUILD_VARIANT)),)
    ifneq ($(wildcard vendor/artist/config/adb_keys.pub),)
        PRODUCT_ADB_KEYS += vendor/artist/config/adb_keys.pub
    endif
endif

# Face unlock (from InfinityX FaceUnlock / Paranoid Sense)
ifneq ($(TARGET_FACE_UNLOCK_SUPPORTED),false)
PRODUCT_PACKAGES += \
    FaceUnlock

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.face.sense_service=true

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/android.hardware.biometrics.face.xml
endif
