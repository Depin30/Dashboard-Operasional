-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Waktu pembuatan: 19 Agu 2026 pada 01.14
-- Versi server: 5.7.24
-- Versi PHP: 8.3.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rs_dashboard`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `kamar_operasi`
--

CREATE TABLE `kamar_operasi` (
  `id` int(11) NOT NULL,
  `tanggal` date NOT NULL,
  `spesialisasi` varchar(50) NOT NULL,
  `realisasi` int(11) NOT NULL,
  `target` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `kamar_operasi`
--

INSERT INTO `kamar_operasi` (`id`, `tanggal`, `spesialisasi`, `realisasi`, `target`) VALUES
(1, '2026-08-18', 'Paru', 101, 200),
(4, '2026-08-10', 'kaki', 134, 213),
(6, '2026-07-12', 'tangan', 212, 300);

-- --------------------------------------------------------

--
-- Struktur dari tabel `pendapatan`
--

CREATE TABLE `pendapatan` (
  `id` int(11) NOT NULL,
  `tanggal` date NOT NULL,
  `target` bigint(20) NOT NULL,
  `realisasi` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `pendapatan`
--

INSERT INTO `pendapatan` (`id`, `tanggal`, `target`, `realisasi`) VALUES
(58, '2026-08-14', 2000000000, 1900000000);

-- --------------------------------------------------------

--
-- Struktur dari tabel `rawat_inap_bor`
--

CREATE TABLE `rawat_inap_bor` (
  `id` int(11) NOT NULL,
  `tanggal` date NOT NULL,
  `nama_ruangan` varchar(255) NOT NULL,
  `bed_terisi` int(11) NOT NULL,
  `kapasitas_bed` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `rawat_inap_bor`
--

INSERT INTO `rawat_inap_bor` (`id`, `tanggal`, `nama_ruangan`, `bed_terisi`, `kapasitas_bed`) VALUES
(7, '2026-02-26', 'Lotus', 180, 190),
(8, '2026-02-26', 'Orchid', 142, 241),
(9, '2026-08-13', 'Peony', 123, 212);

-- --------------------------------------------------------

--
-- Struktur dari tabel `rawat_jalan_poli`
--

CREATE TABLE `rawat_jalan_poli` (
  `id` int(11) NOT NULL,
  `tanggal` date NOT NULL,
  `nama_poli` varchar(255) NOT NULL,
  `realisasi` int(11) NOT NULL,
  `target` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `rawat_jalan_poli`
--

INSERT INTO `rawat_jalan_poli` (`id`, `tanggal`, `nama_poli`, `realisasi`, `target`) VALUES
(5, '2026-08-18', 'Mata', 500, 603),
(6, '2026-08-14', 'Penyakit Dalam', 123, 200);

-- --------------------------------------------------------

--
-- Struktur dari tabel `ringkasan_harian`
--

CREATE TABLE `ringkasan_harian` (
  `id` int(11) NOT NULL,
  `tanggal` date NOT NULL,
  `kategori` enum('Rawat Jalan','IGD','Rawat Inap') NOT NULL,
  `realisasi` int(11) NOT NULL,
  `target` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `ringkasan_harian`
--

INSERT INTO `ringkasan_harian` (`id`, `tanggal`, `kategori`, `realisasi`, `target`) VALUES
(19, '2026-08-18', 'IGD', 250, 323),
(20, '2026-08-18', 'Rawat Jalan', 498, 523),
(21, '2026-08-18', 'Rawat Inap', 313, 352);

-- --------------------------------------------------------

--
-- Struktur dari tabel `tindakan_dokter`
--

CREATE TABLE `tindakan_dokter` (
  `id` int(11) NOT NULL,
  `tanggal` date NOT NULL,
  `departemen` enum('Mata','Kebidanan','Kandungan','') NOT NULL,
  `nama_dokter` varchar(100) NOT NULL,
  `jumlah_tindakan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktur dari tabel `top_ok_mata`
--

CREATE TABLE `top_ok_mata` (
  `id` int(11) NOT NULL,
  `tanggal` date NOT NULL,
  `nama_dokter` varchar(100) NOT NULL,
  `realisasi` int(11) NOT NULL,
  `target` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `top_ok_mata`
--

INSERT INTO `top_ok_mata` (`id`, `tanggal`, `nama_dokter`, `realisasi`, `target`) VALUES
(1, '2026-02-26', 'Hesti', 100, 200),
(2, '2026-08-13', 'Momi', 173, 263),
(3, '2026-08-14', 'Rara', 134, 150);

-- --------------------------------------------------------

--
-- Struktur dari tabel `top_tindakan_kebidanan`
--

CREATE TABLE `top_tindakan_kebidanan` (
  `id` int(11) NOT NULL,
  `tanggal` date NOT NULL,
  `nama_dokter` varchar(100) NOT NULL,
  `realisasi` int(11) NOT NULL,
  `target` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `top_tindakan_kebidanan`
--

INSERT INTO `top_tindakan_kebidanan` (`id`, `tanggal`, `nama_dokter`, `realisasi`, `target`) VALUES
(1, '2026-08-18', 'Tuti', 312, 324),
(3, '2026-02-28', 'Popi', 258, 356);

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `username`, `password`) VALUES
(1, 'rsck', '$2b$10$kmtW1ElBhqQtZOrKn30LjupfQLmoSwRYdVEd7NcvaeRSAw1PAqH8C');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `kamar_operasi`
--
ALTER TABLE `kamar_operasi`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `pendapatan`
--
ALTER TABLE `pendapatan`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `rawat_inap_bor`
--
ALTER TABLE `rawat_inap_bor`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `rawat_jalan_poli`
--
ALTER TABLE `rawat_jalan_poli`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `ringkasan_harian`
--
ALTER TABLE `ringkasan_harian`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `tindakan_dokter`
--
ALTER TABLE `tindakan_dokter`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `top_ok_mata`
--
ALTER TABLE `top_ok_mata`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `top_tindakan_kebidanan`
--
ALTER TABLE `top_tindakan_kebidanan`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `kamar_operasi`
--
ALTER TABLE `kamar_operasi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `pendapatan`
--
ALTER TABLE `pendapatan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT untuk tabel `rawat_inap_bor`
--
ALTER TABLE `rawat_inap_bor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `rawat_jalan_poli`
--
ALTER TABLE `rawat_jalan_poli`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `ringkasan_harian`
--
ALTER TABLE `ringkasan_harian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT untuk tabel `tindakan_dokter`
--
ALTER TABLE `tindakan_dokter`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `top_ok_mata`
--
ALTER TABLE `top_ok_mata`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `top_tindakan_kebidanan`
--
ALTER TABLE `top_tindakan_kebidanan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
