flutter build apk --release --dart-define=QUEUE_SIZE=100 --dart-define=DEMO_MODE=false --dart-define=DELAY=500
#flutter build apk --release --bundle-sksl-path flutter_01.sksl.json --dart-define=QUEUE_SIZE=100 --dart-define=DEMO_MODE=false --dart-define=DELAY=500
cp ./build/app/outputs/flutter-apk/app-release.apk "G:/My Drive/Artefacts/apg.apk"