# RichTextViewBinaries

Prebuilt iOS XCFramework dependencies used by RichTextView.

| Component | Source | Release tag |
| --- | --- | --- |
| Markdown | `Components/Markdown` | `swift-markdown-*` |
| Tree-sitter | `Components/TreeSitter` | `tree-sitter-*` |
| Math | `Components/Math` | `iosMath-*` |

Upstream sources are pinned as Git submodules. Component patches stay beside
their build scripts and are applied to disposable source copies during each
build.

```sh
git clone --recurse-submodules https://github.com/FeliksLv01/RichTextViewBinaries.git
cd RichTextViewBinaries
./Scripts/run-component.sh markdown ci
./Scripts/run-component.sh tree-sitter ci
./Scripts/run-component.sh math ci
```

CI uses component path filters. Changes under `Scripts` or `.github` run all
components; changes confined to one component build only that component.
Releases are dispatched per component and use independent tags and assets.
