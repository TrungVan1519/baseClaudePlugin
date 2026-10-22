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

## Chuẩn bị

Các bước dưới đây dành cho máy chưa cài gì. Bước nào máy đã có thì bỏ qua.

### Bước 1: Cài Homebrew

macOS dùng Homebrew để cài Git. Windows bỏ qua bước này.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Thêm Homebrew vào PATH trong `~/.zshrc` (máy Apple Silicon, máy Intel bỏ qua):

```sh
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc

# Kiểm tra
brew --version
```

### Bước 2: Cài Git

Claude Code tải marketplace từ GitHub bằng Git.

```sh
brew install git

# Kiểm tra
git --version
```

Windows: tải bản cài từ <https://git-scm.com/download/win>.

### Bước 3: Cài Claude Code

```sh
# macOS, Linux, WSL
curl -fsSL https://claude.ai/install.sh | bash
```

```powershell
# Windows PowerShell
irm https://claude.ai/install.ps1 | iex
```

Mở terminal mới rồi kiểm tra:

```sh
claude --version
claude doctor
```

### Bước 4: Đăng nhập

```sh
claude
```

Lần chạy đầu, Claude Code mở trình duyệt để đăng nhập tài khoản Claude (Pro/Max/Team/Enterprise) hoặc Anthropic Console. Đăng nhập xong gõ `/exit` để thoát.

## Cài đặt

Cần làm xong mục [Chuẩn bị](#chuẩn-bị) trước.

### Bước 1: Thêm marketplace

```sh
claude plugin marketplace add TrungVan1519/baseClaudePlugin
```

Lệnh này đăng ký marketplace tên `trungvan` trên máy. Kiểm tra bằng `claude plugin marketplace list`.

### Bước 2: Khai báo plugin trong dự án

Bước này chỉ làm một lần cho mỗi dự án, người đầu tiên làm rồi commit. Thành viên khác clone về đã có sẵn thì bỏ qua.

Thêm vào `.claude/settings.json` của dự án:

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

### Bước 3: Cài plugin

Chạy trong thư mục gốc của dự án:

```sh
claude plugin install tv@trungvan --scope project
```

Kiểm tra bằng `claude plugin list`, thấy `tv@trungvan` ở trạng thái enabled là được.

### Bước 4: Khởi tạo dự án

```sh
claude
```

Lần đầu mở dự án, Claude Code hỏi có tin tưởng thư mục không, chọn đồng ý. Sau đó gõ `/tv:init` để tạo `CLAUDE.md` và `.claude/rules/`, rồi commit các file này.

Thành viên clone dự án đã có `CLAUDE.md` và `.claude/rules/` thì không cần chạy lại `/tv:init`, trừ khi hook `SessionStart` báo rule lệch template.

## Cập nhật

Làm khi plugin có phiên bản mới. Các lệnh chạy trong thư mục gốc của dự án.

### Bước 1: Cập nhật marketplace

```sh
claude plugin marketplace update trungvan
```

Lệnh này tải bản mới nhất của marketplace về máy.

### Bước 2: Cập nhật plugin

```sh
claude plugin update tv@trungvan --scope project
```

Kiểm tra bằng `claude plugin list`, thấy `tv@trungvan` mang `version` mới là được.

### Bước 3: Nạp lại plugin

Phiên Claude Code đang mở cần gõ `/exit` để thoát rồi chạy lại `claude` để nạp bản mới.

### Bước 4: Đồng bộ template

Nếu bản mới có thay đổi template, hook `SessionStart` sẽ báo rule lệch template. Khi đó gõ `/tv:init` để đồng bộ `CLAUDE.md` và `.claude/rules/`, rồi commit các file này. Hook không báo thì bỏ qua bước này.

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
