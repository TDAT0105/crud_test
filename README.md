# crud_test

Dự án Flutter mới.

## Bắt đầu

1. Cài đặt Firebase tools toàn cầu:
    ```bash
    npm install -g firebase-tools
    ```

    Nếu gặp lỗi liên quan đến việc chạy các script, sử dụng lệnh sau trong PowerShell:
    ```bash
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    ```

2. Đăng nhập vào Firebase:
    ```bash
    firebase login
    ```

    Nếu bạn không thể sử dụng `firebase` trực tiếp, cập nhật biến PATH trong System Variables hoặc sử dụng lệnh:
    ```bash
    Set-Location -Path Q:\MyDir  # Thay đổi ổ đĩa để thực thi các lệnh firebase
    ```

3. Kích hoạt FlutterFire CLI:
    ```bash
    flutter pub global activate flutterfire_cli
    ```

4. Cấu hình FlutterFire:
    ```bash
    flutterfire configure
    ```

   Nếu bạn không thể sử dụng lệnh này, đảm bảo `C:\Users\tenodia\AppData\Local\Pub\Cache\bin` được thêm vào biến PATH của bạn.
   ```bash
        tenodia === tên ổ đĩa của từng máy(không giống nhau hoặc giống)
   ```

6. Nếu sử dụng Visual Studio Code, khởi động lại sau khi cấu hình FlutterFire.

7. Thêm Firebase Core vào dự án Flutter của bạn:
    ```bash
    flutter pub add firebase_core
    ```
    
8. Thêm Cloud Firestore vào dự án Flutter của bạn:
    ```bash
    flutter pub add cloud_firestore
    ```


9. ERROR:D8: Cannot fit requested classes in a single dex file (# methods: 94385 > 65536)
   ```bash
   flutter run --debug -> y
   ```
