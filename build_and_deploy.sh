#!/bin/bash

build_android() {
  flutter clean
  flutter build appbundle --release
  flutter build apk --release
}

build_ios() {
  flutter clean
  flutter build ios --release
}

check_production() {
  if grep -q "const production = true;" lib/core/config.dart; then
    echo "Собираем production"
    if [ -z "$1" ] || [ "$1" == "android" ]; then
      build_android
    elif [ "$1" == "ios" ]; then
      build_ios
    else
      echo "Укажите 'android' или 'ios' в качестве аргумента для сборки"
    fi
  else
    echo "Сборка отменена, это dev"
  fi
}

check_production
