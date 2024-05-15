# crud_test

A new Flutter project.

## Getting Started

1. npm install -g firebase-tools
(nếu không xài được tải node.js)
2. firebase login
(nếu hiện firebase : File C:\Users\Admin\AppData\Roaming\npm\firebase.ps1 cannot be loaded because running scripts is disabled on this system. For more information, see about_Execution_Policies at 
https:/go.microsoft.com/fwlink/?LinkID=135170.
At line:1 char:1
+ firebase login
+ ~~~~~~~~
    + CategoryInfo          : SecurityError: (:) [], PSSecurityException
    + FullyQualifiedErrorId : UnauthorizedAccess)
=> vào PowerShell dùng lệnh này Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
=> dùng ôổ đĩa khác thì sài lệnh này Set-Location -Path (Q:\MyDir) -> đổi thành ổ đĩa máy đang xài
3.flutter pub global activate flutterfire_cli
4.dùng lệnh flutterfire configure
(nếu không sử dụng được thi2 vào window, env, path(trong System Variables), copy C:\Users\tenodia\AppData\Local\Pub\Cache\bin
)
5.out vscode dùng lại lêệnh trên

6. flutter pub add firebase_core
7. flutter pub add cloud_firestore
