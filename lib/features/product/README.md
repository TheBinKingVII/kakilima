# Product Page UI Template

Template UI untuk halaman produk yang menampilkan informasi merchant dan daftar produk.

## Struktur

### 1. Models (Data Template)
- `product_model.dart` - Model untuk data produk dengan dummy data
- `merchant_model.dart` - Model untuk data merchant dengan dummy data

### 2. Widgets
- `merchant_info_card.dart` - Card untuk menampilkan info merchant, rating, dan tombol aksi
- `product_card.dart` - Card untuk menampilkan item produk dalam list

### 3. Page
- `product_page.dart` - Halaman utama yang menggabungkan semua komponen

## Fitur UI

### Header Section
- Background gambar merchant (saat ini gradient placeholder)
- Judul merchant dan subtitle
- AppBar dengan tombol back

### Merchant Info Card
- Avatar/logo merchant
- Nama merchant
- Alamat dengan icon lokasi
- Rating dengan bintang (1-5)
- Jumlah ulasan
- Tombol share dan edit (icon bulat orange)
- Tap pada rating untuk melihat detail

### Product List
- Grid/List produk yang dijual
- Setiap card menampilkan:
  - Gambar produk (saat ini icon placeholder)
  - Nama produk
  - Deskripsi singkat
  - Harga terformat (dengan titik pemisah ribuan)

### Floating Action Button
- Tombol hijau dengan icon play (untuk aksi tertentu)
- Posisi center-bottom

## Navigasi

Untuk membuka halaman ini:
```dart
Get.toNamed(Routes.product);
```

## TODO untuk Backend Integration

1. **Merchant Data**
   - Ganti `MerchantModel.getDummyMerchant()` dengan data dari API
   - Implementasi load gambar dari URL
   - Implementasi fungsi share
   - Implementasi fungsi edit
   - Navigasi ke halaman detail rating

2. **Product Data**
   - Ganti `ProductModel.getDummyProducts()` dengan data dari API
   - Implementasi load gambar produk dari URL
   - Implementasi navigasi ke detail produk
   - Implementasi pagination/infinite scroll jika diperlukan

3. **Images**
   - Ganti placeholder gradient dengan gambar cover merchant
   - Ganti icon placeholder dengan gambar produk asli
   - Implementasi caching gambar

4. **Action Buttons**
   - Implementasi fungsi share (social media sharing)
   - Implementasi fungsi edit merchant info
   - Implementasi aksi FAB (tombol hijau)

## Customization

### Warna
Ubah warna di `theme.dart` atau langsung di widget:
- Orange: `Colors.orange` - untuk tombol aksi
- Green: `Colors.green` - untuk FAB
- Amber: `Colors.amber` - untuk rating bintang

### Ukuran
- Header height: 200px (expandedHeight)
- Card margin/padding: 16px
- Product card height: 100px

### Font
Gunakan font default atau custom font sesuai design system.
