const express = require('express');
const mysql = require('mysql2/promise');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname))); // Melayani file statis (HTML, CSS, JS)

// Konfigurasi Koneksi Database MySQL (Sesuai permintaan Anda)
const dbConfig = {
    host: 'localhost',
    user: 'root',
    password: 'root',
    database: 'rs_dashboard'
};

let pool;
async function initDB() {
    try {
        pool = mysql.createPool(dbConfig);
        console.log('Berhasil terhubung ke database MySQL.');
    } catch (err) {
        console.error('Koneksi database gagal:', err);
    }
}
initDB();

// ==================== ROUTES HALAMAN (VIEWS) ====================
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.get('/admin', (req, res) => {
    res.sendFile(path.join(__dirname, 'admin.html'));
});

app.get('/login', (req, res) => {
    res.sendFile(path.join(__dirname, 'login.html'));
});

// ==================== API DASHBOARD (index.html) ====================
app.get('/api/dashboard', async (req, res) => {
    try {
        const [pendapatan] = await pool.query('SELECT * FROM pendapatan ORDER BY tanggal ASC');
        const [ringkasan] = await pool.query('SELECT * FROM ringkasan_harian');
        const [poli] = await pool.query('SELECT * FROM rawat_jalan_poli');
        const [operasi] = await pool.query('SELECT * FROM kamar_operasi');
        const [bor] = await pool.query('SELECT * FROM rawat_inap_bor');
        const [kebidanan] = await pool.query('SELECT * FROM top_tindakan_kebidanan');
        const [mata] = await pool.query('SELECT * FROM top_ok_mata');

        const latestFinansial = pendapatan.length > 0 ? pendapatan[pendapatan.length - 1] : { target: 0, realisasi: 0 };

        res.json({
            finansial: latestFinansial,
            pendapatan: pendapatan,
            pasien: ringkasan,
            ringkasan: ringkasan,
            poli: poli,
            kamarOperasi: operasi,
            bor: bor,
            kebidanan: kebidanan,
            mata: mata
        });
    } catch (err) {
        console.error("Error /api/dashboard:", err);
        res.status(500).json({ error: 'Gagal mengambil data dashboard' });
    }
});

// ==================== API ADMIN KELOLA DATA (admin.html) ====================
app.get('/api/admin/all-data', async (req, res) => {
    try {
        const [pendapatan] = await pool.query('SELECT * FROM pendapatan');
        const [ringkasan] = await pool.query('SELECT * FROM ringkasan_harian');
        const [poli] = await pool.query('SELECT * FROM rawat_jalan_poli');
        const [operasi] = await pool.query('SELECT * FROM kamar_operasi');
        const [bor] = await pool.query('SELECT * FROM rawat_inap_bor');
        const [kebidanan] = await pool.query('SELECT * FROM top_tindakan_kebidanan');
        const [mata] = await pool.query('SELECT * FROM top_ok_mata');

        res.json({
            pendapatan,
            ringkasan,
            poli,
            operasi,
            bor,
            kebidanan,
            mata
        });
    } catch (err) {
        console.error("Error /api/admin/all-data:", err);
        res.status(500).json({ error: 'Gagal memuat data kelola admin' });
    }
});

// API Hapus Data
app.delete('/api/admin/delete', async (req, res) => {
    const { table, idCol, idVal } = req.body;
    const allowedTables = ['pendapatan', 'ringkasan_harian', 'rawat_jalan_poli', 'kamar_operasi', 'rawat_inap_bor', 'top_tindakan_kebidanan', 'top_ok_mata'];
    
    if (!allowedTables.includes(table)) {
        return res.status(400).json({ success: false, error: 'Tabel tidak valid' });
    }

    try {
        await pool.query(`DELETE FROM ?? WHERE ?? = ?`, [table, idCol, idVal]);
        res.json({ success: true });
    } catch (err) {
        console.error("Error delete:", err);
        res.status(500).json({ success: false, error: 'Gagal menghapus data dari database' });
    }
});

// API Entry & Update Data (Form Submit)
app.post('/api/entry', async (req, res) => {
    const { editIds, tanggal, finansial, ringkasanPasien, poli, operasi, bor, kebidanan, mata } = req.body;
    
    // Fallback otomatis ke tanggal hari ini jika form tanggal kosong
    const formTanggal = tanggal || new Date().toISOString().split('T')[0];
    
    try {
        // 1. Tanggal & Finansial (Pendapatan)
        if (editIds && editIds.pendapatan) {
            await pool.query(
                'UPDATE pendapatan SET tanggal = ?, target = ?, realisasi = ? WHERE id = ?',
                [formTanggal, finansial.target, finansial.realisasi, editIds.pendapatan]
            );
        } else if (finansial.target !== null || finansial.realisasi !== null) {
            await pool.query(
                'INSERT INTO pendapatan (tanggal, target, realisasi) VALUES (?, ?, ?)',
                [formTanggal, finansial.target || 0, finansial.realisasi || 0]
            );
        }

        // Helper untuk menangani insert/update data berulang (batch) termasuk Ringkasan Pasien (IGD, Rawat Inap, dll)
        const handleBatchData = async (items, tableName, nameCol, keyEditId) => {
            if (!items || !Array.isArray(items)) return;
            for (const item of items) {
                const nameVal = item[nameCol];
                const targetVal = item.target || 0;
                const realVal = item.realisasi || 0;

                if (!nameVal) continue; // Lewati jika nama/kategori kosong

                if (editIds && editIds[keyEditId]) {
                    await pool.query(
                        `UPDATE ?? SET ?? = ?, target = ?, realisasi = ?, tanggal = ? WHERE id = ?`,
                        [tableName, nameCol, nameVal, targetVal, realVal, formTanggal, editIds[keyEditId]]
                    );
                } else {
                    // Cek apakah kategori sudah ada berdasarkan nama dan tanggal untuk menghindari duplikat harian
                    const [existing] = await pool.query(
                        `SELECT id FROM ?? WHERE ?? = ? AND tanggal = ?`, 
                        [tableName, nameCol, nameVal, formTanggal]
                    );

                    if (existing.length > 0) {
                        await pool.query(
                            `UPDATE ?? SET target = ?, realisasi = ? WHERE id = ?`,
                            [tableName, targetVal, realVal, existing[0].id]
                        );
                    } else {
                        await pool.query(
                            `INSERT INTO ?? (??, target, realisasi, tanggal) VALUES (?, ?, ?, ?)`,
                            [tableName, nameCol, nameVal, targetVal, realVal, formTanggal]
                        );
                    }
                }
            }
        };

        // Helper khusus BOR Rawat Inap dengan menyertakan tanggal
        const handleBorData = async (items) => {
            if (!items || !Array.isArray(items)) return;
            for (const item of items) {
                const ruang = item.nama_ruangan;
                const terisi = item.bed_terisi || 0;
                const kapasitas = item.kapasitas_bed || 0;

                if (!ruang) continue;

                if (editIds && editIds.bor) {
                    await pool.query(
                        'UPDATE rawat_inap_bor SET nama_ruangan = ?, bed_terisi = ?, kapasitas_bed = ?, tanggal = ? WHERE id = ?',
                        [ruang, terisi, kapasitas, formTanggal, editIds.bor]
                    );
                } else {
                    const [existing] = await pool.query(
                        'SELECT id FROM rawat_inap_bor WHERE nama_ruangan = ? AND tanggal = ?', 
                        [ruang, formTanggal]
                    );

                    if (existing.length > 0) {
                        await pool.query(
                            'UPDATE rawat_inap_bor SET bed_terisi = ?, kapasitas_bed = ? WHERE id = ?',
                            [terisi, kapasitas, existing[0].id]
                        );
                    } else {
                        await pool.query(
                            'INSERT INTO rawat_inap_bor (nama_ruangan, bed_terisi, kapasitas_bed, tanggal) VALUES (?, ?, ?, ?)',
                            [ruang, terisi, kapasitas, formTanggal]
                        );
                    }
                }
            }
        };

        // Eksekusi penyimpanan untuk masing-masing bagian data
        await handleBatchData(ringkasanPasien, 'ringkasan_harian', 'kategori', 'ringkasan');
        await handleBatchData(poli, 'rawat_jalan_poli', 'nama_poli', 'poli');
        await handleBatchData(operasi, 'kamar_operasi', 'spesialisasi', 'operasi');
        await handleBorData(bor);
        await handleBatchData(kebidanan, 'top_tindakan_kebidanan', 'nama_dokter', 'kebidanan');
        await handleBatchData(mata, 'top_ok_mata', 'nama_dokter', 'mata');

        res.json({ success: true });
    } catch (err) {
        console.error("Error /api/entry:", err);
        res.status(500).json({ success: false, error: 'Gagal menyimpan data ke database' });
    }
});

// Menjalankan Server
app.listen(PORT, () => {
    console.log(`Server SIMRS berjalan di http://localhost:${PORT}`);
});