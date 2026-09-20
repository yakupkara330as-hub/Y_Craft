<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
    <meta name="mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <meta name="theme-color" content="#0d1117">
    <title>Idle Bank Empire - Mobile</title>
    <style>
        :root {
            --bg-color: #0d1117;
            --card-bg: #161b22;
            --border-color: #30363d;
            --accent-green: #238636;
            --accent-orange: #d97706;
            --accent-purple: #8957e5;
            --accent-blue: #2563eb;
            --accent-gold: #f59e0b;
            --text-color: #f0f6fc;
            --text-sub: #8b949e;
        }

        * {
            box-sizing: border-box;
            -webkit-tap-highlight-color: transparent;
            -webkit-user-select: none;
            user-select: none;
            touch-action: manipulation;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-color);
            margin: 0;
            padding: 0;
            padding-top: env(safe-area-inset-top);
            padding-bottom: env(safe-area-inset-bottom);
            padding-left: env(safe-area-inset-left);
            padding-right: env(safe-area-inset-right);
            display: flex;
            flex-direction: column;
            height: 100vh;
            overflow: hidden;
        }

        /* Üst Panel */
        .top-bar {
            background-color: var(--card-bg);
            border-bottom: 1px solid var(--border-color);
            padding: 12px 16px;
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.5);
            z-index: 10;
        }

        .stat-card {
            background: rgba(255,255,255,0.03);
            padding: 8px 12px;
            border-radius: 8px;
            border: 1px solid var(--border-color);
        }

        .stat-label { font-size: 11px; color: var(--text-sub); text-transform: uppercase; font-weight: 600; }
        .stat-value { font-size: 15px; font-weight: 800; color: var(--accent-gold); }

        /* Sekme Menüsü */
        .nav-tabs {
            display: flex;
            background: var(--card-bg);
            border-bottom: 1px solid var(--border-color);
        }

        .tab-btn {
            flex: 1;
            padding: 12px 5px;
            background: none;
            border: none;
            color: var(--text-sub);
            font-size: 13px;
            font-weight: 700;
            border-bottom: 3px solid transparent;
            cursor: pointer;
        }

        .tab-btn.active {
            color: var(--accent-gold);
            border-bottom-color: var(--accent-gold);
            background: rgba(245, 158, 11, 0.05);
        }

        /* Ana İçerik Alanı */
        .content-area {
            flex: 1;
            overflow-y: auto;
            padding: 12px;
            -webkit-overflow-scrolling: touch;
        }

        .tab-content { display: none; }
        .tab-content.active { display: block; }

        /* Kasa Kartları */
        .desk-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 14px;
            margin-bottom: 12px;
            position: relative;
        }

        .desk-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }

        .desk-name { font-size: 15px; font-weight: 700; color: #fff; }
        .desk-level { font-size: 12px; color: var(--text-sub); font-weight: 600; }

        .progress-bar-bg {
            width: 100%;
            height: 8px;
            background: #21262d;
            border-radius: 4px;
            overflow: hidden;
            margin: 8px 0;
        }

        .progress-bar-fill {
            height: 100%;
            width: 0%;
            background: linear-gradient(90deg, #2ea043, #3fb950);
            transition: width 0.1s linear;
        }

        .btn {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-weight: 700;
            font-size: 14px;
            color: #fff;
            cursor: pointer;
            margin-top: 6px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }

        .btn:active { transform: scale(0.98); opacity: 0.9; }
        .btn:disabled { opacity: 0.4; cursor: not-allowed; transform: none; }

        .btn-tap { background: var(--accent-green); }
        .btn-upgrade { background: var(--accent-orange); }
        .btn-manager { background: var(--accent-purple); }
        .btn-buy-gems { background: var(--accent-blue); }

        /* Market Kartları */
        .shop-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 10px;
        }

        .shop-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            padding: 14px;
            border-radius: 12px;
        }

        .shop-title { font-weight: 700; font-size: 15px; margin-bottom: 4px; }
        .shop-desc { font-size: 12px; color: var(--text-sub); margin-bottom: 10px; }

        /* Uçan Çanta */
        #briefcase {
            position: fixed;
            width: 50px;
            height: 50px;
            background: #f59e0b;
            border-radius: 50%;
            display: none;
            justify-content: center;
            align-items: center;
            font-size: 24px;
            box-shadow: 0 0 15px rgba(245,158,11,0.8);
            z-index: 100;
            animation: pulse 1.5s infinite alternate;
        }

        @keyframes pulse {
            from { transform: scale(1); }
            to { transform: scale(1.15); }
        }

        /* Sanal POS Modal */
        .modal {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.85);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 200;
            padding: 20px;
        }

        .modal-body {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 20px;
            width: 100%;
            max-width: 380px;
            text-align: center;
        }

        .card-input {
            width: 100%;
            padding: 12px;
            margin: 6px 0;
            background: #0d1117;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            color: #fff;
            font-size: 14px;
            outline: none;
        }
    </style>
</head>
<body oncontextmenu="return false;">

    <!-- İstatistik Üst Barı -->
    <div class="top-bar">
        <div class="stat-card">
            <div class="stat-label">Nakit Para</div>
            <div class="stat-value">$<span id="txtMoney">0</span></div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Saniyelik Gelir</div>
            <div class="stat-value">$<span id="txtEps">0</span>/s</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Elmas</div>
            <div class="stat-value">💎 <span id="txtGems">0</span></div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Lisans Puanı</div>
            <div class="stat-value">📜 <span id="txtPrestige">0</span></div>
        </div>
    </div>

    <!-- Navigasyon Sekmeleri -->
    <div class="nav-tabs">
        <button class="tab-btn active" onclick="switchTab('desks', event)">Kasalar</button>
        <button class="tab-btn" onclick="switchTab('market', event)">Market</button>
        <button class="tab-btn" onclick="switchTab('prestige', event)">Prestij</button>
    </div>

    <!-- İçerik Alanı -->
    <div class="content-area">
        <!-- Kasalar Sekmesi -->
        <div id="tab-desks" class="tab-content active">
            <div id="desksContainer"></div>
        </div>

        <!-- Market Sekmesi -->
        <div id="tab-market" class="tab-content">
            <div class="shop-grid">
                <!-- TL Elmas Paketleri -->
                <div class="shop-card">
                    <div class="shop-title">💎 Elmas Mağazası (Sanal POS)</div>
                    <div class="shop-desc">Gerçek kart ödeme simülasyonu ile elmas satın al.</div>
                    
                    <button class="btn btn-buy-gems" onclick="openPaymentModal(50, 500)">
                        <span>500 Elmas</span> <span>50 TL</span>
                    </button>
                    <button class="btn btn-buy-gems" onclick="openPaymentModal(100, 1200)">
                        <span>1.200 Elmas</span> <span>100 TL</span>
                    </button>
                    <button class="btn btn-buy-gems" onclick="openPaymentModal(250, 3500)">
                        <span>3.500 Elmas</span> <span>250 TL</span>
                    </button>
                    <button class="btn btn-buy-gems" onclick="openPaymentModal(500, 8000)">
                        <span>8.000 Elmas</span> <span>500 TL</span>
                    </button>
                </div>

                <!-- Süreli Çarpanlar -->
                <div class="shop-card">
                    <div class="shop-title">⚡ Süreli Gelir Çarpanları</div>
                    <div class="shop-desc">Aktif Boost: <span id="txtActiveBoost" style="color:var(--accent-gold); font-weight:bold;">Yok</span></div>
                    
                    <button class="btn btn-upgrade" id="btnBoost2x" onclick="buyBoost(2, 300, 50)">
                        <span>2x Gelir (5 Dk)</span> <span>50 💎</span>
                    </button>
                    <button class="btn btn-upgrade" id="btnBoost3x" onclick="buyBoost(3, 180, 100)">
                        <span>3x Gelir (3 Dk)</span> <span>100 💎</span>
                    </button>
                    <button class="btn btn-upgrade" id="btnBoost5x" onclick="buyBoost(5, 60, 250)">
                        <span>5x Gelir (1 Dk)</span> <span>250 💎</span>
                    </button>
                </div>
            </div>
        </div>

        <!-- Prestij Sekmesi -->
        <div id="tab-prestige" class="tab-content">
            <div class="shop-card" style="text-align: center;">
                <div class="shop-title">📜 Banka Lisans Satışı (Prestij)</div>
                <div class="shop-desc">
                    Tüm paranı ve kasa seviyelerini sıfırlayarak Lisans Puanı kazanırsın.
                    Her puan kalıcı olarak tüm gelirini <b>%10 artırır</b>.
                </div>
                <p style="font-size: 18px; font-weight: bold; color: var(--accent-gold);">
                    Kazanılacak Lisans: <span id="txtPendingLicenses">0</span>
                </p>
                <button class="btn btn-upgrade" onclick="doPrestige()" style="justify-content: center;">
                    Sıfırla ve Lisansları Al
                </button>
            </div>
        </div>
    </div>

    <!-- Rastgele Çıkan Çanta -->
    <div id="briefcase" onclick="claimBriefcase()">💼</div>

    <!-- Sanal POS Ödeme Modalı -->
    <div id="payModal" class="modal">
        <div class="modal-body">
            <h3 style="margin-top:0;">💳 Sanal POS Ödeme</h3>
            <p style="font-size: 13px; color: var(--text-sub);">
                Paket: <b id="payPackageName">-</b><br>
                Tutar: <b id="payAmountTxt" style="color:var(--accent-gold);">-</b>
            </p>
            <input type="text" class="card-input" placeholder="Kart Numarası (16 Hane)" maxlength="19">
            <div style="display: flex; gap: 8px;">
                <input type="text" class="card-input" placeholder="AA/YY" maxlength="5">
                <input type="password" class="card-input" placeholder="CVC" maxlength="3">
            </div>
            <button class="btn btn-tap" onclick="processPayment()" style="justify-content: center; margin-top: 12px;">
                Ödemeyi Onayla ve Yükle
            </button>
            <button class="btn" onclick="closePaymentModal()" style="background:#333; justify-content: center; margin-top: 6px;">
                İptal
            </button>
        </div>
    </div>

    <script>
        // Android Dokunsal Titreşim Motoru
        function vibrate(ms = 15) {
            if (navigator.vibrate) {
                try { navigator.vibrate(ms); } catch(e) {}
            }
        }

        // Oyun Durumu (Game State)
        let gameState = {
            money: 0,
            gems: 0,
            prestigePoints: 0,
            activeMultiplier: 1,
            boostTimeLeft: 0,
            lastSaveTime: Date.now(),
            desks: [
                { id: 0, name: "Standart Gişe", level: 1, baseIncome: 10, baseCost: 50, managerCost: 500, isAutomated: false },
                { id: 1, name: "Kredi Departmanı", level: 0, baseIncome: 150, baseCost: 2500, managerCost: 15000, isAutomated: false },
                { id: 2, name: "Borsa & Yatırım", level: 0, baseIncome: 1200, baseCost: 25000, managerCost: 150000, isAutomated: false },
                { id: 3, name: "Kripto Kasası", level: 0, baseIncome: 10000, baseCost: 300000, managerCost: 2000000, isAutomated: false },
                { id: 4, name: "Merkez Kasası", level: 0, baseIncome: 80000, baseCost: 5000000, managerCost: 25000000, isAutomated: false }
            ]
        };

        let selectedGemPackage = null;

        // Kayıt ve Yükleme İşlemleri (Çevrimdışı Kazanç Hesaplamalı)
        function saveGame() {
            gameState.lastSaveTime = Date.now();
            localStorage.setItem('idle_bank_mobile_save', JSON.stringify(gameState));
        }

        function loadGame() {
            const saved = localStorage.getItem('idle_bank_mobile_save');
            if (saved) {
                try {
                    const parsed = JSON.parse(saved);
                    gameState = { ...gameState, ...parsed };

                    // Çevrimdışı geçen süreyi hesapla
                    const now = Date.now();
                    const diffSec = Math.floor((now - (gameState.lastSaveTime || now)) / 1000);
                    if (diffSec > 10) {
                        const eps = getEps();
                        const offlineEarnings = Math.floor(eps * Math.min(diffSec, 86400)); // En fazla 24 saatlik birikim
                        if (offlineEarnings > 0) {
                            gameState.money += offlineEarnings;
                            setTimeout(() => {
                                alert(`Çevrimdışı Kazanç!\n\nUzaktayken müdürlerin senin için $${offlineEarnings.toLocaleString()} kazandı!`);
                            }, 500);
                        }
                    }
                } catch(e) {}
            }
        }

        // Sekme Değiştirici
        function switchTab(tabId, event) {
            vibrate(10);
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            
            if (event && event.target) {
                event.target.classList.add('active');
            }
            document.getElementById(`tab-${tabId}`).classList.add('active');
        }

        // Matematiksel Formüller
        function getDeskCost(desk) {
            return Math.floor(desk.baseCost * Math.pow(1.18, Math.max(0, desk.level)));
        }

        function getDeskIncome(desk) {
            if (desk.level === 0) return 0;
            const prestigeBonus = 1 + (gameState.prestigePoints * 0.10);
            return Math.floor(desk.baseIncome * desk.level * prestigeBonus * gameState.activeMultiplier);
        }

        function getEps() {
            let eps = 0;
            gameState.desks.forEach(d => {
                if (d.isAutomated && d.level > 0) {
                    eps += getDeskIncome(d);
                }
            });
            return eps;
        }

        // Kasaları Ekrana Çizdirme
        function renderDesks() {
            const container = document.getElementById('desksContainer');
            container.innerHTML = '';

            gameState.desks.forEach((desk) => {
                const cost = getDeskCost(desk);
                const income = getDeskIncome(desk);
                const isMax = desk.level >= 1000;

                const card = document.createElement('div');
                card.className = 'desk-card';
                card.innerHTML = `
                    <div class="desk-header">
                        <span class="desk-name">${desk.name}</span>
                        <span class="desk-level">Seviye ${desk.level}/1000</span>
                    </div>
                    <div style="font-size:13px; color:var(--accent-gold); font-weight:bold;">
                        Gelir: $${income.toLocaleString()}/işlem
                    </div>
                    <div class="progress-bar-bg">
                        <div class="progress-bar-fill" id="prog-${desk.id}"></div>
                    </div>
                    ${!desk.isAutomated ? `
                        <button class="btn btn-tap" onclick="tapDesk(${desk.id})">                             <span>İşlem Yap</span> <span>+$${income.toLocaleString()}</span>
                        </button>
                    ` : ''}
                    <button class="btn btn-upgrade" onclick="upgradeDesk(${desk.id})" ${gameState.money < cost || isMax ? 'disabled' : ''}>
                        <span>${isMax ? 'MAX' : 'Yükselt (+1)'}</span>
                        <span>${isMax ? '-' : '$' + cost.toLocaleString()}</span>
                    </button>
                    ${!desk.isAutomated ? `
                        <button class="btn btn-manager" onclick="buyManager(${desk.id})" ${gameState.money < desk.managerCost \vert{}\vert{} desk.level === 0 ? 'disabled' : ''}>                             <span>Müdür Atayarak Otomatikleştir</span>                             <span>$${desk.managerCost.toLocaleString()}</span>
                        </button>
                    ` : ''}
                `;
                container.appendChild(card);
            });
        }

        // Oyuncu Eylemleri
        function tapDesk(id) {
            vibrate(10);
            const desk = gameState.desks[id];
            if (desk.level > 0) {
                gameState.money += getDeskIncome(desk);
                updateUI();
            }
        }

        function upgradeDesk(id) {
            vibrate(20);
            const desk = gameState.desks[id];
            const cost = getDeskCost(desk);
            if (gameState.money >= cost && desk.level < 1000) {
                gameState.money -= cost;
                desk.level++;
                updateUI();
                saveGame();
            }
        }

        function buyManager(id) {
            vibrate(30);
            const desk = gameState.desks[id];
            if (gameState.money >= desk.managerCost && !desk.isAutomated) {
                gameState.money -= desk.managerCost;
                desk.isAutomated = true;
                updateUI();
                saveGame();
            }
        }

        // Boostlar
        function buyBoost(mult, durationSec, costGems) {
            vibrate(20);
            if (gameState.gems >= costGems) {
                gameState.gems -= costGems;
                gameState.activeMultiplier = mult;
                gameState.boostTimeLeft = durationSec;
                updateUI();
                saveGame();
            }
        }

        // Sanal POS Modalı
        function openPaymentModal(priceTL, gemAmount) {
            vibrate(15);
            selectedGemPackage = { priceTL, gemAmount };
            document.getElementById('payPackageName').innerText = `${gemAmount.toLocaleString()} Elmas Paket`;
            document.getElementById('payAmountTxt').innerText = `${priceTL} TL`;
            document.getElementById('payModal').style.display = 'flex';
        }

        function closePaymentModal() {
            vibrate(10);
            document.getElementById('payModal').style.display = 'none';
        }

        function processPayment() {
            vibrate([30, 50, 30]);
            if (selectedGemPackage) {
                gameState.gems += selectedGemPackage.gemAmount;
                alert(`Ödeme Başarılı! ${selectedGemPackage.gemAmount} Elmas hesabınıza yüklendi.`);
                closePaymentModal();
                updateUI();
                saveGame();
            }
        }

        // Prestij Sıfırlama
        function doPrestige() {
            const pending = Math.floor(Math.sqrt(gameState.money / 1000000));
            if (pending > 0) {
                vibrate(50);
                gameState.prestigePoints += pending;
                gameState.money = 0;
                gameState.desks.forEach(d => {
                    d.level = d.id === 0 ? 1 : 0;
                    d.isAutomated = false;
                });
                updateUI();
                saveGame();
                alert(`Prestij Başarılı! ${pending} Lisans Puanı kazanıldı.`);
            } else {
                alert("Prestij yapmak için daha fazla para kazanmalısın!");
            }
        }

        // Uçan Çanta Etkinliği
        function spawnBriefcase() {
            const b = document.getElementById('briefcase');
            b.style.top = Math.random() * (window.innerHeight - 150) + 100 + 'px';
            b.style.left = Math.random() * (window.innerWidth - 80) + 20 + 'px';
            b.style.display = 'flex';
        }

        function claimBriefcase() {
            vibrate(40);
            const reward = Math.max(500, getEps() * 60);
            gameState.money += reward;
            document.getElementById('briefcase').style.display = 'none';
            alert(`Sürpriz Çanta! $${reward.toLocaleString()} kazandın!`);
            updateUI();
        }

        // Arayüz Yenileme
        function updateUI() {
            document.getElementById('txtMoney').innerText = Math.floor(gameState.money).toLocaleString();
            document.getElementById('txtEps').innerText = Math.floor(getEps()).toLocaleString();
            document.getElementById('txtGems').innerText = gameState.gems.toLocaleString();
            document.getElementById('txtPrestige').innerText = gameState.prestigePoints.toLocaleString();

            const pending = Math.floor(Math.sqrt(gameState.money / 1000000));
            document.getElementById('txtPendingLicenses').innerText = pending.toLocaleString();

            if (gameState.boostTimeLeft > 0) {
                document.getElementById('txtActiveBoost').innerText = `${gameState.activeMultiplier}x (${gameState.boostTimeLeft}s)`;
            } else {
                document.getElementById('txtActiveBoost').innerText = "Yok";
                gameState.activeMultiplier = 1;
            }

            renderDesks();
        }

        // Ana Oyun Döngüsü
        setInterval(() => {
            // Otomasyon Gelirleri
            gameState.money += getEps();

            // Boost Sayacı
            if (gameState.boostTimeLeft > 0) {
                gameState.boostTimeLeft--;
            }

            updateUI();
        }, 1000);

        // Otomatik Kayıt ve Çanta Doğma Zamanlayıcıları
        setInterval(saveGame, 10000);
        setInterval(() => {
            if (Math.random() < 0.3) spawnBriefcase();
        }, 45000);

        // Oyunu Başlat
        loadGame();
        updateUI();
    </script>
</body>
</html>
