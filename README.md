# Picture stamp app
## TODO
- スタンプを動かすとsetStateが走るため、customPaintが再描画されて重くなる
  - 描画済みのスタンプは再描画しないようにする
- 回転がcustomPaintに反映されない
  - これはpaintをforEachで行っているため、過去の角度が残ってしまっている
- 拡大がcustomPaintに反映されていない
