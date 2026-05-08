# Trumia Navigation Demo

Interactive Flutter Web prototype of Trumia's 4-directional swipe navigation.
Showcases the home screen and four neighbouring screens (Cards, Transactions,
Accounts modal, Payments) reachable via edge-aware swipe gestures.

This is a navigation/visual prototype only — no real data, no forms, no
networking. Mock content lives in `lib/data/mock_data.dart`.

## Stack

- Flutter 3.27+ (stable), Dart 3.5+
- Web target with the CanvasKit renderer (for shadow / blur fidelity)
- Inter via `google_fonts` (SF Pro stand-in for the web)
- No state-management package — `AnimationController`s plus `StatefulWidget`s

## Layout of the gesture model

```
            [Cards]
              ↓ (swipe DOWN to reveal — comes in from the top)

[Accounts] → [HOME] ← [Payments]
(swipe RIGHT)         (swipe LEFT)

              ↑ (swipe UP — comes in from the bottom)
            [Transactions]
```

Returning to home:

| Screen       | Close gesture                                      |
|--------------|----------------------------------------------------|
| Cards        | Swipe up anywhere, or tap the `^ Back` pill        |
| Transactions | Swipe down anywhere, or tap the `v Back` pill      |
| Accounts     | Swipe left, tap dim-overlay, or tap `X` button     |
| Payments     | Edge-swipe right from the left edge, or tap `<`    |

The shell (`lib/navigation/shell.dart`) owns four `AnimationController`s, one
per direction. `onPanUpdate` drives `controller.value` linearly with finger
position, and `onPanEnd` settles to 0/1 based on:

- progress crosses 0.5, **or**
- velocity in the opening/closing axis ≥ 500 px/s

Settle is `easeOutCubic` over 320 ms (open) / 220 ms (cancel).

## Run locally

```bash
cd trumia_demo
flutter pub get
flutter run -d chrome --web-renderer canvaskit
```

Hot-reload works for everything except the gesture-shell logic (touching
`shell.dart` may require a hot-restart).

## Build for web

```bash
flutter build web --release --web-renderer canvaskit
# output is in build/web/
```

## Test from a real phone

Quickest path:

```bash
cd build/web
python3 -m http.server 8080
# in another terminal
ngrok http 8080
```

Open the ngrok HTTPS URL in mobile Safari, then "Add to Home Screen" for a
fullscreen, app-like experience.

Alternative: GitHub Pages via a Flutter-web action targeting `build/web`.

## File layout

```
lib/
  main.dart                       # entry
  app.dart                        # MaterialApp + device-frame for desktop
  core/
    theme/
      colors.dart                 # TrumiaColors
      typography.dart             # TrumiaTypography (Inter via google_fonts)
      shadows.dart                # neomorph shadow tokens
      theme.dart                  # ThemeData composition
    widgets/
      soft_card.dart              # base neomorph card
      pill_button.dart            # Back pills + circular icon buttons
      status_bar.dart             # 9:41 mock status bar
      glass_ribbon.dart           # animated glass-ribbon background
  navigation/
    direction.dart                # NavDirection enum
    shell.dart                    # gesture router + Stack of overlays
  screens/
    home_screen.dart
    cards_screen.dart
    transactions_screen.dart
    accounts_modal.dart
    payments_screen.dart
  data/
    mock_data.dart
web/
  index.html                      # iOS-friendly viewport, no overscroll
  manifest.json
```

## Web caveats

`web/index.html` already disables overscroll and tap-callout via CSS:

- `overscroll-behavior: none` — kills Safari's pull-to-refresh that fights
  the swipe-down-to-open-Cards gesture.
- `-webkit-touch-callout: none; user-select: none` — kills long-press
  selection on text/icons.
- `viewport-fit=cover, maximum-scale=1, user-scalable=no` — eliminates the
  300 ms tap-delay and prevents zoom.

## Out of scope (intentionally)

- Real account/payment data, forms, validation
- Profile / notifications screens
- Functional Search or Filter
- Top-up / Move / Send actions (tap is a no-op)
