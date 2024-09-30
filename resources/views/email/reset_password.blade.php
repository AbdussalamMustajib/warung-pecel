<!DOCTYPE html>
<html>
<head>
    <title>Reset Password Anda</title>
</head>
<body>
    <h1>Halo, {{ $user->profil->name }}</h1>
    <p>Terima kasih telah bergabung dengan Aplikasi Kami!</p>
    <p>Berikut adalah beberapa informasi penting untuk Anda:</p>

    <ul>
        <li>Nama: {{ $user->profil->name }}</li>
        <li>Email: {{ $user->email }}</li>
        <!-- Tambahkan informasi tambahan yang ingin Anda sertakan dalam email -->
    </ul>

    <p>Jangan ragu untuk menghubungi kami jika Anda memiliki pertanyaan atau butuh bantuan.</p>

    <p>Token Anda: {{ $token }}</p>

    <p>Terima kasih,</p>
    <p>Tim Aplikasi Kami</p>
</body>
</html>
