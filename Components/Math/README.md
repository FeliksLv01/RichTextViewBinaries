# RichTextViewMath

Binary distribution of [iosMath](https://github.com/kostub/iosMath) for RichTextView.
The upstream source is pinned as a Git submodule; consumers link the generated
dynamic XCFramework and do not compile iosMath source.

```sh
git submodule update --init
./Scripts/build-xcframework.sh
```

The XCFramework contains iOS device and simulator slices plus the math fonts
required at runtime.

Consumers can use the `RichTextViewMathBinary` Swift package product or the
`iosMath.xcframework.zip` release asset directly.

From the repository root, run `./Scripts/run-component.sh math ci` to build
and package only this component.
