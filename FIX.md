# ColorCC — notification Liquid Glass flicker fix

Unofficial patched build of [Guest's ColorCC](https://github.com/addictedcaf/ColorCC) (v1.0.1 / app version 0.99.68) for Samsung One UI 9.

## The bug

With the **Liquid** glass style and **Notifications: Match panel** enabled, any notification that updates every second — the media player's progress/timer, a chronometer, a screen recorder timer — makes the whole notification card flash dark for **exactly one frame** on every update tick.

The notification glass is translucent. While Samsung refreshes the notification, the dark surface behind the glass is momentarily exposed, so the translucent lens shows a darker card for one frame. Static notifications don't update, so they don't flash.

## The fix

The patched `Glass` drawable now paints a **stable rounded base** under the translucent glass lens for notification cards only. The base uses the dark/light theme color and is drawn with the same corner radius, so the liquid reflection, border, and motion are unchanged. The one-frame dark flash is gone.

Also changed, as requested by the maintainer of this fork:

- The editor footer now reads **"Made by DuduSync"** instead of "Made by Guest".

No other behavior, layout, or setting was changed. The original APKs are untouched.

## Install

1. Uninstall the original `dev.colorcc` (this build uses a different signing key, so Android won't install it as an update over the original).
2. Install `ColorCC-fix.apk`.
3. Open **LSPosed > Modules**, enable **ColorCC**, and check **System UI** in its scope.
4. Restart System UI or reboot.
5. Set the glass style to **Liquid** and **Notifications: Match panel** in the editor.

Your ColorCC settings are stored in System UI's device-protected storage, so they survive reinstalling the module itself. If you had a custom layout, export/screenshot it before uninstalling, just in case.

## Verification

The fix was verified by recording the notification shade at ~120 fps and measuring the card's mean luma per frame. Before the fix, a single-frame drop of ~10–15 luma points appears every ~1.0 s. After the fix, the same recording has **0 single-frame drops** (`frames=1032`, median luma 66.30).

Evidence frames, the raw measurement result, and the exact recording/measurement script are in `evidence/` and `tools/`. The smali patches are in `patches/`.

## Credits

- Original ColorCC by **Guest** ([@addictedcaf](https://github.com/addictedcaf), Telegram [@Guestoss](https://t.me/Guestoss)). This is an unofficial patch, not affiliated with or endorsed by the original author.
- Patch, testing, and the `Made by DuduSync` footer by **DuduSync**.

The upstream repository ships the APK only; this fork also ships a patched APK. No original source code was available.

## SHA-256

```
5b34988a2c6f8945fc2dc0ca6096b879313f2a49f76fdd8543490f3642962a01  ColorCC-fix.apk
```
