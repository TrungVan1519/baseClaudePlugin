---
paths:
  - "**/*.dart"
---

# Style code (bắt buộc)

Tất cả quy tắc dưới đây là bắt buộc, áp dụng cho mọi code viết trong repo, cả code UI lẫn code logic, không chỉ riêng phần được nêu ví dụ.

**Phạm vi:** Mọi file `.dart` của dự án (khớp `paths` ở đầu file), trừ:

- Thư mục `test/`.
- Code sinh từ template `flutter create` của Plugin: `lib/*_platform_interface.dart`, `lib/*_method_channel.dart`.
- File sinh tự động, không sửa tay: `*.g.dart`, `*.gen.dart` (flutter_gen), file `.dart` trong `lib/src/l10n/` do `gen-l10n` sinh, `firebase_options.dart`.

**Thứ tự ưu tiên:** Các quy tắc ở mục 2-5 cao hơn code cũ trong repo. Quy tắc 1.1 (bám theo code cũ) chỉ áp dụng cho những gì mục 2-5 chưa quy định.

**Áp dụng hồi tố:** Code cũ vi phạm quy tắc style thì xử lý theo nguyên tắc hồi tố trong `CLAUDE.md`.

## 1. Nguyên tắc chung

### 1.1. Bám theo code cũ, không tự ý dùng style mới

Trước khi viết bất kỳ widget/class nào, tìm ít nhất 1-2 file tương tự đã có trong cùng scope (hoặc scope liên quan gần nhất) để đối chiếu cách tổ chức, cách đặt tên, cách dùng theme/extension sẵn có. Không phát minh pattern mới nếu repo đã có pattern tương đương. Nếu code tham chiếu vi phạm quy tắc ở mục 2-5 thì không bám theo phần vi phạm, và xử lý theo quy tắc hồi tố.

Ví dụ: Lấy màu/text style theo theme trong `plugins/app_plugin` → dùng extension có sẵn:

```dart
color: context.colorThemeExtension.success
backgroundColor: context.colorTheme.surface
style: context.textTheme.titleMedium
```

## 2. Cú pháp Dart

### 2.1. Dart dot-shorthand

Dùng dot-shorthand (`.member`, `.new(...)`, `.named(...)`) bất cứ khi nào type đích đã rõ từ context và member thuộc chính type đích. Áp dụng cho enum, static getter/method, constructor (kể cả constructor đặt tên, factory) ở mọi vị trí có type đích tường minh:

- Tham số đặt tên và tham số vị trí của mọi constructor/function/method: Widget, plain model/data class, mock/seed data, hàm private (`_buildMonthDay(context, .new(...))`, `saveUser(.fromEntity(user))`).
- `return` khi kiểu trả về tường minh: `copyWith`, `build()` của Notifier, `toEntity()`, factory constructor, Exception mapper, getter, Provider DI trong `di.dart`, Data Source (`return .fromJson(...)`), extension l10n (`return .of(this)`).
- Phần tử của list/set/map khi kiểu phần tử đã rõ từ kiểu khai báo, kiểu trả về hoặc kiểu tham số, kể cả trong collection `for` (`for (final document in snapshot.docs) .fromJson(document.data())`).
- Hai nhánh của biểu thức điều kiện `? :` (`side: hasBorder ? .new(color: color) : .none`).
- Gán vào biến/field có kiểu tường minh (`final BorderRadius radius = .circular(8)`), `switch` case, so sánh `==`/`!=` (`state.brightness == .dark`).
- Dot-shorthand đi kèm selector phía sau vẫn áp dụng (`.lerp(a, b, t)!`).

Lưu ý: `EnumName.value` còn sót trong provider, mock data là lỗi bỏ sót thường gặp.

Giữ đầy đủ tên type khi:

- Type đích không suy luận được: Gán vào `var`/`final`/`const` không khai báo kiểu, list literal không khai báo kiểu phần tử (`static const kSupportedLocales = [Locale('en'), Locale('vi')]`).
- Member thuộc type khác type đích (class con, class tiện ích): `Colors.orange`/`Curves.easeOut`/`Icons.add` (type đích `Color`/`Curve`/`IconData`), `WidgetStateColor.resolveWith`, `BoxDecoration` cho `Decoration`, `RoundedRectangleBorder` cho `ShapeBorder`, `NeverScrollableScrollPhysics` cho `ScrollPhysics`, `XxxRepositoryImpl` cho Repository abstract, widget con cho `Widget`, `Theme.of`/`MediaQuery.of`.

```dart
borderRadius: .circular(borderRadius)        // thay vì BorderRadius.circular(...)
border: .all(color: borderColor!)            // thay vì Border.all(...)
padding: const .all(12)                      // thay vì const EdgeInsets.all(12)
alignment: .center                           // thay vì Alignment.center
textAlign: .center                           // thay vì TextAlign.center
floatingLabelBehavior: .always               // thay vì FloatingLabelBehavior.always
contentPadding: const .symmetric(vertical: 12, horizontal: 16)
primary: .new(0xFF85586F)                   // thay vì Color(0xFF85586F)
cardTheme: const .new(elevation: 2)         // thay vì const CardThemeData(elevation: 2)

TransactionEntity(type: .income, status: .completed)

UserEntity toEntity() {
  return .new(id: id, email: email);         // thay vì UserEntity(...)
}

SignInState build() {
  return const .new();                       // thay vì const SignInState()
}

DateUtils.dateOnly(.now())                   // thay vì DateUtils.dateOnly(DateTime.now())

return [
  for (final document in snapshot.docs) .fromJson(document.data()),
];                                           // hàm trả Future<List<FinanceCategoryModel>>

success: .lerp(success, other.success, t)!,  // thay vì Color.lerp(...)!
```

### 2.2. Luôn dùng block body

Mọi thân hàm luôn dùng block body `{ ... }`, không dùng expression body `=> ...`: Method của class (kể cả `build`, `@override`), function top-level/local, callback/closure, getter/setter. Không áp dụng cho `switch` expression (`case X => ...`, `final w when w < 600 => ...`) vì đó không phải thân hàm.

```dart
// Đúng
Widget _buildHeader(BuildContext context) {
  return Text(context.authL10n.signInTitle);
}

bool get isEmpty {
  return items.isEmpty;
}

onPressed: () {
  submit();
},

// Sai
Widget _buildHeader(BuildContext context) => Text(context.authL10n.signInTitle);
bool get isEmpty => items.isEmpty;
onPressed: () => submit(),
```

### 2.3. Luôn dùng `const` khi được

Thêm `const` cho mọi constructor call, collection literal và biến có giá trị hằng tại thời điểm compile:

- Constructor call dạng đầy đủ và dạng dot-shorthand: `const Icon(Icons.notes, size: 12)`, `const .all(12)`, `const .only(bottom: 8)`, `const .new()`.
- Biến cục bộ có giá trị hằng dùng `const` thay `final` (`const peekExtent = _cardSpacing + _cardWidth / 2;` khi cả 2 vế là `static const`).
- Không lặp `const` bên trong context đã `const` (`const [AuthLocalizations.delegate]`, không viết `const [const ...]`).

`analysis_options.yaml` của mọi Package bật thêm `prefer_const_constructors`, `prefer_const_declarations`, `prefer_const_literals_to_create_immutables`, `unnecessary_const`: Lỗi thiếu/thừa `const` hiện qua `flutter analyze`. Package mới tạo phải thêm 4 lint này.

```dart
// Đúng
padding: const .symmetric(horizontal: 16),
child: const CircularProgressIndicator(),

// Sai
padding: .symmetric(horizontal: 16),
child: CircularProgressIndicator(),
```

## 3. Tổ chức code

### 3.1. Thứ tự khai báo trong class

Áp dụng cho mọi class (Widget, State, Entity, Model, Repository...), extension, mixin, enum.

Thứ tự lớn: **constructors > properties > callbacks > getters/setters > methods**. Mỗi nhóm cách nhau 1 dòng trống. Với `StatefulWidget`, áp dụng riêng cho cả `Foo` và `_FooState`.

**Callback** là mọi field có kiểu `Function`, không riêng field có tiền tố `on`: Builder, validator, predicate (`labelBuilder`, `isSelected`, `validator`, `String Function(BuildContext context)? title`) đều thuộc nhóm callback, xếp theo thứ tự tham số và thứ tự field của nhóm callback.

**Nhóm 1: Constructors.** Constructor thường trước, constructor đặt tên (`Foo.named`) sau. Thứ tự tham số:

1. Properties required (`required this.xxx`)
2. Callbacks required (`required this.onXxx`)
3. Properties có default trong constructor (`this.xxx = value`)
4. Callbacks có default trong constructor (`this.onXxx = value`)
5. Properties nullable, không default (`this.xxx`)
6. Callbacks nullable, không default (`this.onXxx`)

**Nhóm 2: Properties** (không gồm callback):

1. Biến `static`
2. Biến `const`
3. Biến `final` (không static/const)
4. Biến `late`
5. Non-null, không default (`required this.xxx` hoặc field non-null không gán default)
6. Non-null, default gán trực tiếp tại field (`Type field = value;`)
7. Non-null, có default trong constructor
8. Nullable, có default trong constructor
9. Nullable, không default

**Nhóm 3: Callbacks:**

1. Non-null, không default
2. Non-null, default gán trực tiếp tại field (`Function(...) onXxx = value;`)
3. Non-null, có default trong constructor
4. Nullable, có default trong constructor
5. Nullable, không default

Callback nhận qua constructor luôn dùng kiểu `Function(...)?`, không dùng `VoidCallback`, `ValueChanged<T>` hay typedef riêng. Callback `required` giữ kiểu `Function(...)`, chỉ bỏ dấu `?` ở cuối kiểu.

```dart
final Function(int value)? onChanged;
final Function(String value)? onFieldSubmitted;
final String? Function(String? value)? validator;
```

**Nhóm 4: Getters/Setters** (setter đặt ngay sau getter cùng tên):

1. Getter/setter public
2. Getter/setter `@override` (`props`...)
3. Getter/setter private (`Future<SharedPreferences> get _prefs`), kể cả `static` private

**Nhóm 5: Methods:**

1. Method public
2. Method `@override` (`build`, `dispose`, `initState`, `createState`...)
3. Method private (`_xxx`), kể cả method `static` private

Riêng Notifier, AsyncNotifier và các class Riverpod tương tự: Mục `@override` xếp trước mục public, áp dụng cho cả nhóm 4 và nhóm 5.

Ví dụ Widget:

```dart
class MyWidget extends StatelessWidget {
  const MyWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.padding = const .all(12),
    this.onSubmitted = _defaultOnSubmitted,
    this.subtitle,
    this.onLongPress,
  });

  static const double defaultSpacing = 12;

  final String title;
  final EdgeInsets padding;
  final String? subtitle;

  final Function() onTap;
  final Function() onSubmitted;
  final Function()? onLongPress;

  void submit() {}

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return Text(title);
  }

  static void _defaultOnSubmitted() {}
}
```

Ví dụ Notifier:

```dart
class TransactionListNotifier extends Notifier<List<TransactionEntity>> {
  @override
  List<TransactionEntity> build() {
    return [];
  }

  void add(TransactionEntity transaction) {
    state = [...state, transaction];
  }

  void _sort() {}
}
```

### 3.2. Class hằng số: Phân loại theo việc có phụ thuộc dotenv hay không

Hằng số của Package đặt trong class `XConstant` tại `lib/src/utils/x_constant.dart`, hằng số đặt tiền tố `k` (ví dụ `AppConstant.kSupportedLocales` trong `app_plugin`, `AuthConstant.kMinPasswordLength` trong `auth_module`).

- **Gộp vào `XConstant`**: URL (base URL, discovery URL, redirect URL, domain, realm...), endpoint/path build từ biến dotenv, và business config khác (page size/limit, storage key, feature flag, client id, scope, default value...).
- **Viết inline tại nơi dùng**: Endpoint/path hardcode không phụ thuộc dotenv (Firestore collection/document path, REST path cố định). Không gộp vào `XConstant`, không tạo class `Service`/helper riêng để chứa.

```dart
// Business config, storage key → XConstant
AuthConstant.kMinPasswordLength
AppConstant.kLocaleCodeKey

// Phụ thuộc dotenv → XConstant
BaseAppConstant.kMapboxAccessToken

// Hardcode → inline trong Data Source
Future<bool> userExists(String userId) async {
  final document = await FirestoreClient.instance.getDocument(
    'users/$userId',
  );

  return document != null;
}
```

## 4. Flutter UI

### 4.1. Khoảng cách giữa children trong Row/Column

Ưu tiên tối đa thuộc tính `spacing` của `Row`/`Column`, không chèn `SizedBox` xen giữa. Chỉ dùng `SizedBox` khi khoảng cách không đều và không gộp được thành một `spacing` chung (khi đó kết hợp `spacing` cho phần đều + `SizedBox` cho chỗ lệch, hoặc tách `Row`/`Column` con).

```dart
// Đúng
Column(
  spacing: 16,
  crossAxisAlignment: .stretch,
  children: [
    _buildHeader(context),
    _buildEmailField(),
    _buildPasswordField(),
  ],
)

// Sai: Khoảng cách đều nhưng chèn SizedBox
Column(
  crossAxisAlignment: .stretch,
  children: [
    _buildHeader(context),
    const SizedBox(height: 16),
    _buildEmailField(),
    const SizedBox(height: 16),
    _buildPasswordField(),
  ],
)
```

### 4.2. Dùng tham số `padding` có sẵn của widget

Widget đã có tham số `padding` (`SingleChildScrollView`, `ListView`, `GridView` và các constructor `.builder`/`.separated`) thì truyền `padding` trực tiếp, không bọc thêm `Padding` bên ngoài hoặc bên trong. Ngoài việc thừa widget, `Padding` bọc ngoài còn thu hẹp vùng cuộn và làm nội dung bị cắt ở mép thay vì cuộn qua phần padding.

```dart
// Đúng
SingleChildScrollView(
  padding: const .all(16),
  child: _buildForm(),
)

ListView.builder(
  padding: const .symmetric(horizontal: 16),
  itemCount: items.length,
  itemBuilder: _buildItem,
)

// Sai: Bọc Padding thừa
Padding(
  padding: const .all(16),
  child: SingleChildScrollView(child: _buildForm()),
)

SingleChildScrollView(
  child: Padding(
    padding: const .all(16),
    child: _buildForm(),
  ),
)
```

## 5. Riverpod

### 5.1. Đặt tên Provider/Notifier/AsyncNotifier

File đặt tên theo biến provider (snake_case), không theo tên class. `Provider<T>` dùng cho DI khai trong `di.dart` của Package, không tách file riêng.

| Kiểu                | Tên class      | Tên biến provider | Tên file              |
| ------------------- | -------------- | ----------------- | --------------------- |
| `Provider<T>`       | —              | `xProvider`       | `di.dart`             |
| `Notifier<T>`       | `XNotifier`    | `xProvider`       | `x_provider.dart`     |
| `AsyncNotifier<T>`  | `XAsNotifier`  | `xAsProvider`     | `x_as_provider.dart`  |
| `StreamNotifier<T>` | `XStrNotifier` | `xStrProvider`    | `x_str_provider.dart` |

Ví dụ (baseFlutter): `SignInNotifier`/`signInProvider` (`sign_in_provider.dart`), `SignInAsNotifier`/`signInAsProvider` (`sign_in_as_provider.dart`), `UserActiveStrNotifier`/`userActiveStrProvider` (`user_active_str_provider.dart`).

Provider/Notifier/AsyncNotifier/StreamNotifier đặt tên sai chuẩn (kể cả tên cũ kiểu hậu tố `Controller`/`ControllerProvider`) cần đổi tên đúng chuẩn: Tên class, tên biến provider, tên file và toàn bộ nơi gọi trong repo. Việc đổi tên theo quy tắc hồi tố (hỏi user trước).

### 5.2. Gán giá trị `ref.watch` vào biến trước khi dùng

Không gọi `ref.watch(...)` inline trong biểu thức (tham số widget/constructor, `return`, chuỗi gọi method). Gán vào biến `final` đặt tên theo giá trị được watch, rồi mới dùng. Áp dụng cho Page/Widget, `build()` của Notifier/AsyncNotifier/StreamNotifier và Provider DI trong `di.dart`. Không áp dụng cho `ref.read` và `ref.listen`, được gọi inline.

```dart
// Đúng
final authRepository = ref.watch(authRepositoryProvider);

return .new(authRepository: authRepository);

final signOutAsState = ref.watch(signOutAsProvider);

return AppPage(isLoading: signOutAsState.isLoading, child: ...);

// Sai
return .new(authRepository: ref.watch(authRepositoryProvider));

return AppPage(isLoading: ref.watch(signOutAsProvider).isLoading, child: ...);
```

### 5.3. Model, Entity và state Riverpod dùng `Equatable`

Mọi Model (Data Layer), Entity (Domain Layer) và class state tự định nghĩa của Notifier/AsyncNotifier/StreamNotifier đều `extends Equatable` (lib `equatable`), không tự viết `operator ==`/`hashCode`. Override `props` liệt kê đủ mọi field, xếp theo quy tắc 3.1 (nhóm getter/setter, mục `@override`, đứng trước các method như `copyWith`, `toEntity`) và quy tắc 2.2 (block body). Package chưa có `equatable` thì thêm theo mục "Lệnh" trong `CLAUDE.md`.

```dart
class SignInState extends Equatable {
  const SignInState({this.isObscurePassword = true});

  final bool isObscurePassword;

  @override
  List<Object?> get props {
    return [isObscurePassword];
  }

  SignInState copyWith({bool? isObscurePassword}) {
    return .new(
      isObscurePassword: isObscurePassword ?? this.isObscurePassword,
    );
  }
}
```
