# Gesture recogntion classifier training for *Order Up!* game

File IPYNB utama (yang paling ter-update): v2\mtsc_v3.ipynb

## Manajemen dependensi

Proyek ini menggunakan uv untuk kebutuhan instalasi dan manajemen dependensi Python.

* Why uv? https://robert-mcdermott.medium.com/saying-goodbye-to-anaconda-91c18ddf89bb
* Download link for uv: https://docs.astral.sh/uv/getting-started/installation/#installation-methods

### Quick start

Setelah meng-clone repo ini (sehingga .venv masih belum ada), lakukan rangkaian perintah berikut.

```powershell
uv python install 3.12.4
uv python pin 3.12.4
uv sync
```

Bila semua berjalan baik, seluruh dependensi Python yang diperlukan untuk menjalankan file .ipynb di repo ini akan telah terinstalasi.

### Panduan menggunakan uv

```powershell
uv init
```

Perintah untuk menginisialisasi proyek. (Tapi, khusus untuk repo yang sudah memiliki file pyproject.toml dan uv.lock, semisal proyek ini, **tidak** perlu dilakukan ```uv init``` lagi.)

```powershell
uv python list
```

Perintah untuk melihat semua versi Python yang sudah diinstalasi di sistem.

```powershell
uv python install [version]
```

Contoh:
```powershell
uv python install 3.12.4
```

Perintah untuk menginstalasi versi Python yang dibutuhkan, jika memang belum ada. Pastikan untuk memakai versi 3.12.4 untuk proyek ini.

```powershell
uv python pin [version]
```

Contoh:
```powershell
uv python pin 3.12.4
```

Perintah untuk menentukan versi Python yang mau digunakan, dijalankan setelah ```uv python install```. Kita menggunakan versi 3.12.4 untuk proyek ini.

```powershell
uv add [package]
```

Perintah untuk menambahkan dependensi. Dalam uv, sebaiknya dependensi baru tidak ditambahkan dengan ```pip install```, melainkan dengan ```uv add [package]```.

```powershell
uv add --dev [package]
```

Perintah untuk menambah dependensi yang bersifat development-only, semisal ipykernel atau pytest.

```powershell
uv lock
```

Perintah untuk dijalankan setelah meng-update file pyproject.toml ataupun uv.lock secara manual.

```powershell
uv sync
```

Perintah untuk menyusun ulang .venv berdasarkan isi file pyproject.toml dan uv.lock.

```powershell
uv pip list
```

Perintah untuk melihat semua package yang sudah diinstalasi di .venv.
