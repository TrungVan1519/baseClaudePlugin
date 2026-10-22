---
name: init
description: Cài hoặc đồng bộ CLAUDE.md và .claude/rules/ của dự án hiện tại theo template của plugin tv, để /tv:dev và /tv:sa dùng được.
disable-model-invocation: true
---

# /tv:init — Cài/đồng bộ template

Template nằm trong `${CLAUDE_PLUGIN_ROOT}/templates/`:

| Template | Đích trong dự án |
| --- | --- |
| `templates/CLAUDE.md` | `CLAUDE.md` |
| `templates/rules/dart-style.md` | `.claude/rules/dart-style.md` |
| `templates/rules/docs-style.md` | `.claude/rules/docs-style.md` |

## Quy trình

1. **Kiểm tra hiện trạng:** Với từng đích, xác định file chưa có, giống template, hay khác template.
2. **File rule chưa có:** Chép nguyên văn từ template.
3. **File rule khác template:** Template của plugin là bản gốc, dùng chung cho mọi dự án. Không ghi đè ngay: Tóm tắt khác biệt (mục nào thêm/bớt/sửa) và hỏi user lấy theo template hay giữ bản dự án. Giữ bản dự án thì hook `SessionStart` của plugin sẽ tiếp tục cảnh báo lệch, nên đề xuất user đưa thay đổi đó vào template của plugin nếu muốn áp dụng chung. Khác biệt chỉ ở `paths` trong frontmatter là chỉnh riêng của dự án, giữ nguyên.
4. **`CLAUDE.md` chưa có:** Chép từ template, rồi hỏi user nội dung cho các mục còn `TODO` (Trạng thái repo, Kiến trúc, Lệnh). Không tự điền từ suy đoán. Có thể đọc repo để gợi ý, nhưng phải trình bày là gợi ý. Mục nào dự án không có (ví dụ dự án không phải code nên không có Kiến trúc, Lệnh) thì ghi nội dung là `Không có.`, không xóa tiêu đề mục.
5. **`CLAUDE.md` đã có:** Không ghi đè. Kiểm tra đủ các mục mà skill của plugin tham chiếu: "Kiến trúc", "Lệnh", "Nguyên tắc làm việc chung" (gồm nguyên tắc hồi tố), "Rule theo loại file". Mục nào thiếu hoặc khác template thì báo user và hỏi trước khi sửa.
6. **`paths` của rule:** Hỏi user `paths` trong `docs-style.md` có khớp thư mục tài liệu của dự án không (mặc định `documents/**/*.md`).
7. **Báo cáo:** File đã tạo/sửa, file giữ nguyên, việc còn chờ user quyết định.
