# sigma_test

## Architecture & State Management
Aplikasi ini menggunakan state management Provider yang memisahkan UI & Logic.

## Concurrency Handling
Transfer Controller / View Model menggunakan synchronus _isLocked untuk menolak request / permintaan duplicate sebelum transaksi di forward ke Backend

## Shuffle PIN View
Setiap PIN Sheet memiliki urutan PIN yang random / berbeda setaiap kali di buka untuk keamanan, dan juga metode shufflenya menggunakan random bawaan Dart dengan function Random.secure()
