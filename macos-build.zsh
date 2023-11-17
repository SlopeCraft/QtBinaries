#!/usr/bin/env zsh

###### Configure LLVM ######
if [[ $CPUTYPE == arm64 ]]; then
  alias clang=/opt/homebrew/opt/llvm/bin/clang
  alias clang++=/opt/homebrew/opt/llvm/bin/clang++
else
  alias clang=/usr/local/opt/llvm/bin/clang
  alias clang++=/usr/local/opt/llvm/bin/clang++
fi

###### Build ######
cd $HOME

mkdir qt-static
cd qt-static

rm -rf build install qt6.6.0-static-arm64-apple-darwin qt6.6.0-static-x86_64-apple-darwin qt6.6.0-static-arm64-apple-darwin.tar.gz qt6.6.0-static-x86_64-apple-darwin.tar.gz

git clone https://github.com/qt/qtbase.git --recursive
cd qtbase 
git checkout v6.6.0
cd ..

git clone https://github.com/qt/qttools.git --recursive
cd qttools
git checkout v6.6.0
cd ..

mkdir build install
cd build

# Configure, build and install qtbase
../qtbase/configure --prefix=../install -static -release -nomake tests -skip qtdoc
cmake --build . --parallel
cmake --install .
rm -rf ./*

# Configure, build and install qttools
../install/bin/qt-configure-module ../qttools
cmake --build . --parallel
cmake --install .
rm -rf ./*

###### Package ######
cd ..

if [[ $CPUTYPE == arm64 ]]; then
  mv install qt6.6.0-static-arm64-apple-darwin
  tar -czvf qt6.6.0-static-arm64-apple-darwin.tar.gz qt6.6.0-static-arm64-apple-darwin
else
  mv install qt6.6.0-static-x86_64-apple-darwin
  tar -czvf qt6.6.0-static-x86_64-apple-darwin.tar.gz qt6.6.0-static-x86_64-apple-darwin
fi

echo "Done! Find the package in $HOME/qt-static"
