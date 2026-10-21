# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Trạng thái repo

<!-- TODO: Mô tả ngắn cấu trúc repo (thư mục code, thư mục tài liệu). -->

File này chứa kiến trúc, lệnh và nguyên tắc làm việc chung. Style code và style viết tài liệu nằm trong `.claude/rules/`. Vai trò và quy trình nằm trong plugin `tv`.

## Kiến trúc

<!-- TODO: Tóm tắt kiến trúc, quy tắc phụ thuộc giữa Package/layer, và trỏ tới tài liệu chi tiết (ví dụ `documents/pages/`). -->

## Lệnh

<!-- TODO: Lệnh format, analyze, sinh code (l10n, build_runner...), cách thêm dependency. Ghi rõ phạm vi chạy của từng lệnh. -->

## Nguyên tắc làm việc chung

Áp dụng cho mọi task, có hay không gọi skill. Các nguyên tắc này quan trọng hơn tốc độ hoàn thành task:

1. **Không làm ngoài phạm vi.** Không "tiện tay" làm thêm việc ngoài yêu cầu, không refactor code không liên quan.
2. **Không chủ quan, không suy đoán.** Mọi code, nhận định, đề xuất phải dựa trên bằng chứng cụ thể từ repo (đọc file, grep, đối chiếu nhiều module), không suy luận từ tên biến/tên hàm hay kinh nghiệm ở codebase khác. Ngoại lệ: Tài liệu kiến trúc, xem `.claude/rules/docs-style.md`. Trước khi dùng class, provider, model, extension hay API nào, phải đọc file nguồn để xác nhận nó tồn tại và đúng chữ ký.
3. **Chưa rõ thì hỏi, không tự quyết.** Yêu cầu chưa rõ, hoặc phân vân giữa nhiều hướng mà không đủ căn cứ để chọn, thì hỏi user thay vì tự chọn rồi làm luôn hoặc trình bày như kết luận chắc chắn.
4. **Áp dụng hồi tố.** Khi phát hiện code/tài liệu cũ vi phạm quy tắc style trong `.claude/rules/`, kể cả trong file đang sửa, không tự sửa: Báo user vi phạm (file, quy tắc) và hỏi trước khi sửa, không có ngoại lệ. Có thể gom các vi phạm lại để hỏi một lần. Mục đích: Code cũ luôn đúng chuẩn, để code mới bám theo code cũ không bị sai.
5. **Chỉ viết tài liệu khi user yêu cầu.**

## Rule theo loại file

Tự nạp khi đọc/sửa file khớp `paths`. Trước khi viết code hoặc tài liệu, đọc file rule tương ứng:

- `.claude/rules/dart-style.md`: Style code (bắt buộc), áp dụng cho file `.dart`.
- `.claude/rules/docs-style.md`: Style viết tài liệu, áp dụng cho `documents/`.

Hai file rule là bản chép từ template của plugin `tv`, dùng chung cho mọi dự án: Không sửa trực tiếp trong dự án. Cần đổi rule thì sửa template trong plugin rồi chạy `/tv:init`.

## Skill (plugin `tv`)

- `/tv:dev`: Vai trò Flutter/Dart developer: Design UI, triển khai code và sửa lỗi, thực hiện đề xuất của `/tv:sa`.
- `/tv:sa`: Vai trò Solution Architect: Rà soát, đề xuất giải pháp, viết tài liệu. Không sửa code.
- `/tv:init`: Cài/đồng bộ `CLAUDE.md` và `.claude/rules/` theo template của plugin.

Các skill chỉ được kích hoạt khi user gõ lệnh tường minh, không tự trigger theo ngữ cảnh.
