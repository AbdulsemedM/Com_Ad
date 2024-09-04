echo "------ Build runner starting -----"
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
echo "------ Build runner end ----------"
