# baseClaudePlugin

Marketplace Claude Code cá nhân, gồm plugin `tv`.

## Plugin `tv`

| Thành phần | Mô tả |
| --- | --- |
| `/tv:dev` | Flutter/Dart developer: Design UI, triển khai code, sửa lỗi, thực hiện đề xuất của `/tv:sa` |
| `/tv:sa` | Solution Architect: Rà soát, đề xuất giải pháp, viết tài liệu. Không sửa code |
| `/tv:init` | Cài/đồng bộ `CLAUDE.md` và `.claude/rules/` của dự án theo template |
| Agent `tv:reviewer` | Rà soát code chỉ đọc, `/tv:sa` dùng khi rà soát |
| Hook `SessionStart` | So sánh `.claude/rules/` của dự án với template, cảnh báo khi thiếu hoặc lệch |

Plugin không nạp được rule luôn bật vào dự án, nên template nằm trong `plugins/tv/templates/` và được `/tv:init` chép vào từng dự án:

- `CLAUDE.md`: Kiến trúc, lệnh, nguyên tắc làm việc chung (dự án tự điền Kiến trúc và Lệnh).
- `.claude/rules/dart-style.md`: Style code, chỉ nạp khi đọc/sửa file `.dart`.
- `.claude/rules/docs-style.md`: Style viết tài liệu, chỉ nạp khi đọc/sửa file trong `documents/`.

Template rule là bản gốc dùng chung cho mọi dự án. Muốn đổi rule thì sửa template trong plugin, không sửa bản chép trong dự án. Hook so sánh nội dung rule bỏ qua frontmatter, nên dự án được chỉnh `paths` riêng. Dự án chưa có file rule nào thì hook không báo.

## Cài đặt

Khai báo trong `.claude/settings.json` của dự án (commit file này):

```json
{
  "extraKnownMarketplaces": {
    "trungvan": {
      "source": {
        "source": "github",
        "repo": "TrungVan1519/baseClaudePlugin"
      }
    }
  },
  "enabledPlugins": {
    "tv@trungvan": true
  }
}
```

Mỗi người clone dự án cài plugin một lần:

```sh
claude plugin install tv@trungvan --scope project
```

Sau đó chạy `/tv:init` trong dự án để tạo `CLAUDE.md` và `.claude/rules/`.

## Phát triển

```sh
# Kiểm tra manifest của marketplace và plugin
claude plugin validate .
```

```sh
# Chạy thử plugin từ thư mục local trong một phiên
claude --plugin-dir ./plugins/tv
```

Mỗi lần thay đổi plugin, tăng `version` trong `plugins/tv/.claude-plugin/plugin.json`. Thay đổi template thì chạy lại `/tv:init` ở các dự án để đồng bộ.
