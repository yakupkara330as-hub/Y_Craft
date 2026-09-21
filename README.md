<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Kuş Bakışı Üs Geliştirme Oyunu</title>
  <style>
    * {
      box-sizing: border-box;
      user-select: none;
      margin: 0;
      padding: 0;
    }

    body {
      background-color: #0f172a;
      color: #f8fafc;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      height: 100vh;
      display: flex;
      flex-direction: column;
      overflow: hidden;
    }

    /* Üst Skor & Bilgi Barı */
    #top-bar {
      background: #1e293b;
      padding: 12px 24px;
      display: flex;
      justify-content: space-around;
      align-items: center;
      border-bottom: 2px solid #334155;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
      z-index: 10;
    }

    .stat-box {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 1.05rem;
      font-weight: 600;
    }

    .stat-val {
      color: #38bdf8;
    }

    /* Oyun Harita Sahnesi */
    #game-container {
      flex: 1;
      position: relative;
      display: flex;
      justify-content: center;
      align-items: center;
      background: #090d16;
      padding: 10px;
    }

    canvas {
      border: 2px solid #334155;
      border-radius: 8px;
      box-shadow: 0 0 25px rgba(0, 0, 0, 0.5);
      cursor: pointer;
      max-width: 100%;
      max-height: 100%;
      object-fit: contain;
    }

    /* Alt Menü Barı */
    #bottom-nav {
      height: 70px;
      background: #1e293b;
      border-top: 2px solid #334155;
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 15px;
      z-index: 10;
      flex-wrap: wrap;
    }

    .nav-btn {
      background: #334155;
      color: #f8fafc;
      border: 1px solid #475569;
      padding: 10px 18px;
      border-radius: 8px;
      font-size: 0.95rem;
      font-weight: bold;
      cursor: pointer;
      transition: all 0.2s ease;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .nav-btn:hover {
      background: #3b82f6;
      border-color: #60a5fa;
      transform: translateY(-2px);
    }

    .nav-btn-danger {
      background: #7f1d1d;
      border-color: #991b1b;
    }

    .nav-btn-danger:hover {
      background: #dc2626;
      border-color: #ef4444;
    }

    /* Modallar */
    .modal-overlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100vw;
      height: 100vh;
      background: rgba(0, 0, 0, 0.7);
      display: none;
      justify-content: center;
      align-items: center;
      z-index: 100;
      backdrop-filter: blur(4px);
    }

    .modal-card {
      background: #1e293b;
      border: 2px solid #475569;
      border-radius: 12px;
      width: 420px;
      max-width: 90vw;
      padding: 24px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
      position: relative;
    }

    .modal-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 1px solid #334155;
      padding-bottom: 12px;
      margin-bottom: 16px;
    }

    .modal-title {
      font-size: 1.3rem;
      font-weight: bold;
      color: #38bdf8;
    }

    .close-btn {
      background: transparent;
      border: none;
      color: #94a3b8;
      font-size: 1.4rem;
      cursor: pointer;
    }

    .action-btn {
      width: 100%;
      background: #22c55e;
      color: #0f172a;
      border: none;
      padding: 12px;
      border-radius: 8px;
      font-size: 1rem;
      font-weight: bold;
      cursor: pointer;
      margin-top: 16px;
    }

    .action-btn:disabled {
      background: #475569;
      color: #94a3b8;
      cursor: not-allowed;
    }

    #toast {
      position: fixed;
      top: 80px;
      right: 20px;
      background: #22c55e;
      color: #0f172a;
      padding: 10px 20px;
      border-radius: 8px;
      font-weight: bold;
      display: none;
      z-index: 200;
    }
  </style>
</head>
<body>

  <!-- Üst Durum Çubuğu -->
  <div id="top-bar">
    <div class="stat-box">💰 Para: <span id="gold-val" class="stat-val">0</span></div>
    <div class="stat-box">⚡ Üretim/sn: <span id="income-val" class="stat-val">0</span></div>
    <div class="stat-box">💎 Prestij: <span id="prestige-val" class="stat-val">0</span></div>
  </div>

  <!-- Kuş Bakışı Harita Sahnesi -->
  <div id="game-container">
    <canvas id="gameCanvas" width="800" height="600"></canvas>
  </div>

  <!-- Alt Menü -->
  <div id="bottom-nav">
    <button class="nav-btn" onclick="openModal('marketModal')">🛒 Market</button>
    <button class="nav-btn" onclick="openModal('prestigeModal')">🌟 Prestij</button>
    <button class="nav-btn" onclick="saveGame(true)">💾 Kaydet</button>
    <button class="nav-btn nav-btn-danger" onclick="resetGame()">🔄 Sıfırla</button>
  </div>

  <!-- Bina Geliştirme Modalı -->
  <div id="buildingModal" class="modal-overlay">
    <div class="modal-card">
      <div class="modal-header">
        <span id="bld-title" class="modal-title">Bina Adı</span>
        <button class="close-btn" onclick="closeModal('buildingModal')">&times;</button>
      </div>
      <p id="bld-desc" style="color: #94a3b8; margin-bottom: 12px;">Açıklama</p>
      <div style="margin-bottom: 8px;">Mevcut Seviye: <strong id="bld-level">1</strong></div>
      <div style="margin-bottom: 8px;">Mevcut Getiri: <strong id="bld-income" style="color:#22c55e;">+0/sn</strong></div>
      <div style="margin-bottom: 16px;">Geliştirme Maliyeti: <strong id="bld-cost" style="color:#f59e0b;">0 Gold</strong></div>
      <button id="bld-upgrade-btn" class="action-btn" onclick="upgradeSelectedBuilding()">Seviye Yükselt</button>
    </div>
  </div>

  <!-- Market Modalı -->
  <div id="marketModal" class="modal-overlay">
    <div class="modal-card">
      <div class="modal-header">
        <span class="modal-title">🛒 Market</span>
        <button class="close-btn" onclick="closeModal('marketModal')">&times;</button>
      </div>
      <div style="display: flex; flex-direction: column; gap: 12px;">
        <div style="background: #0f172a; padding: 12px; border-radius: 8px; display: flex; justify-content: space-between; align-items: center;">
          <div>
            <div><strong>Drone Takviyesi</strong></div>
            <small style="color: #94a3b8;">+50% Üretim</small>
          </div>
          <button id="buy-drone-btn" class="nav-btn" onclick="buyMarketItem('drone')">1,000 💰</button>
        </div>
        <div style="background: #0f172a; padding: 12px; border-radius: 8px; display: flex; justify-content: space-between; align-items: center;">
          <div>
            <div><strong>Overclock</strong></div>
            <small style="color: #94a3b8;">x2 Üretim</small>
          </div>
          <button id="buy-oc-btn" class="nav-btn" onclick="buyMarketItem('overclock')">10,000 💰</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Prestij Modalı -->
  <div id="prestigeModal" class="modal-overlay">
    <div class="modal-card">
      <div class="modal-header">
        <span class="modal-title">🌟 Prestij</span>
        <button class="close-btn" onclick="closeModal('prestigeModal')">&times;</button>
      </div>
      <p style="color: #94a3b8; margin-bottom: 12px;">Sıfırlayarak Prestij Kristali kazanın. Her kristal üretimi +%100 artırır.</p>
      <div style="margin-bottom: 8px;">Kazanılacak Kristal: <strong id="prestige-gain" style="color: #a855f7;">0</strong></div>
      <div style="margin-bottom: 16px;">Gerekli Minimum Para: <strong style="color: #f59e0b;">100,000 💰</strong></div>
      <button id="prestige-btn" class="action-btn" style="background: #a855f7; color: white;" onclick="doPrestige()">Sıfırla ve Prestij Et</button>
    </div>
  </div>

  <div id="toast">Oyun Kaydedildi!</div>

  <script>
    const defaultState = {
      gold: 50,
      prestige: 0,
      upgrades: { drone: false, overclock: false },
      buildings: {
        mine: { id: 'mine', name: 'Altın Madeni', lvl: 1, baseCost: 50, baseIncome: 2, x: 150, y: 120, w: 140, h: 140, color: '#f59e0b', desc: 'Sürekli ham kaynak kazarak pasif altın üretir.' },
        power: { id: 'power', name: 'Güç Santrali', lvl: 0, baseCost: 200, baseIncome: 10, x: 510, y: 120, w: 140, h: 140, color: '#06b6d4', desc: 'Üs için enerji üreterek geliri artırır.' },
        lab: { id: 'lab', name: 'Araştırma Labı', lvl: 0, baseCost: 1000, baseIncome: 50, x: 150, y: 340, w: 140, h: 140, color: '#10b981', desc: 'Gelişmiş algoritmalar ile büyük kazançlar sağlar.' },
        hq: { id: 'hq', name: 'Ana Kumanda', lvl: 0, baseCost: 5000, baseIncome: 250, x: 510, y: 340, w: 140, h: 140, color: '#ef4444', desc: 'Tüm üssün ana komuta merkezidir.' }
      }
    };

    let state = JSON.parse(JSON.stringify(defaultState));
    let selectedBuildingId = null;

    const canvas = document.getElementById('gameCanvas');
    const ctx = canvas.getContext('2d');
    let hoveredBuilding = null;

    // Ekran Boyutu Hesaplama Düzeltmesi (Ölçekleme Hatalarını Engeller)
    function getMousePos(e) {
      const rect = canvas.getBoundingClientRect();
      const scaleX = canvas.width / rect.width;
      const scaleY = canvas.height / rect.height;
      return {
        x: (e.clientX - rect.left) * scaleX,
        y: (e.clientY - rect.top) * scaleY
      };
    }

    function drawGrid() {
      ctx.fillStyle = '#0f172a';
      ctx.fillRect(0, 0, canvas.width, canvas.height);

      ctx.strokeStyle = '#1e293b';
      ctx.lineWidth = 1;
      for (let x = 0; x < canvas.width; x += 40) {
        ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, canvas.height); ctx.stroke();
      }
      for (let y = 0; y < canvas.height; y += 40) {
        ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(canvas.width, y); ctx.stroke();
      }

      // Yollar
      ctx.strokeStyle = '#334155';
      ctx.lineWidth = 10;
      ctx.beginPath();
      ctx.moveTo(220, 190); ctx.lineTo(580, 190);
      ctx.moveTo(220, 410); ctx.lineTo(580, 410);
      ctx.moveTo(220, 190); ctx.lineTo(220, 410);
      ctx.moveTo(580, 190); ctx.lineTo(580, 410);
      ctx.stroke();
    }

    function drawBuildings() {
      Object.values(state.buildings).forEach(bld => {
        const isHovered = hoveredBuilding === bld.id;

        // Gölge
        ctx.fillStyle = 'rgba(0,0,0,0.5)';
        ctx.fillRect(bld.x + 6, bld.y + 6, bld.w, bld.h);

        // Gövde
        ctx.fillStyle = bld.lvl > 0 ? bld.color : '#334155';
        ctx.fillRect(bld.x, bld.y, bld.w, bld.h);

        // Çerçeve
        ctx.strokeStyle = isHovered ? '#ffffff' : (bld.lvl > 0 ? '#f8fafc' : '#475569');
        ctx.lineWidth = isHovered ? 4 : 2;
        ctx.strokeRect(bld.x, bld.y, bld.w, bld.h);

        // İç Desen
        ctx.fillStyle = 'rgba(255,255,255,0.15)';
        ctx.fillRect(bld.x + 15, bld.y + 15, bld.w - 30, bld.h - 30);

        // Yazılar
        ctx.fillStyle = '#ffffff';
        ctx.font = 'bold 15px Segoe UI';
        ctx.textAlign = 'center';
        ctx.fillText(bld.name, bld.x + bld.w / 2, bld.y + bld.h / 2 - 6);

        ctx.font = '13px Segoe UI';
        ctx.fillStyle = bld.lvl > 0 ? '#cbd5e1' : '#94a3b8';
        ctx.fillText(bld.lvl > 0 ? `Seviye ${bld.lvl}` : 'Kilitli (Tıkla)', bld.x + bld.w / 2, bld.y + bld.h / 2 + 16);
      });
    }

    function render() {
      drawGrid();
      drawBuildings();
      requestAnimationFrame(render);
    }

    function getBuildingIncome(bld) {
      if (!bld || bld.lvl === 0) return 0;
      return bld.baseIncome * bld.lvl;
    }

    function getTotalIncome() {
      let base = 0;
      if (state.buildings) {
        Object.values(state.buildings).forEach(bld => {
          base += getBuildingIncome(bld);
        });
      }

      let mult = 1 + ((state.prestige || 0) * 1.0);
      if (state.upgrades && state.upgrades.drone) mult *= 1.5;
      if (state.upgrades && state.upgrades.overclock) mult *= 2.0;

      return base * mult;
    }

    function getBuildingCost(bld) {
      return Math.floor(bld.baseCost * Math.pow(1.5, bld.lvl));
    }

    setInterval(() => {
      state.gold = (state.gold || 0) + (getTotalIncome() / 10);
      updateUI();
    }, 100);

    setInterval(() => { saveGame(false); }, 15000);

    function updateUI() {
      document.getElementById('gold-val').innerText = Math.floor(state.gold || 0).toLocaleString();
      document.getElementById('income-val').innerText = Math.floor(getTotalIncome()).toLocaleString();
      document.getElementById('prestige-val').innerText = state.prestige || 0;

      if (selectedBuildingId && state.buildings[selectedBuildingId]) {
        const bld = state.buildings[selectedBuildingId];
        const cost = getBuildingCost(bld);
        document.getElementById('bld-level').innerText = bld.lvl;
        document.getElementById('bld-income').innerText = `+${getBuildingIncome(bld)}/sn`;
        document.getElementById('bld-cost').innerText = `${cost.toLocaleString()} 💰`;

        const btn = document.getElementById('bld-upgrade-btn');
        btn.disabled = state.gold < cost;
        btn.innerText = bld.lvl === 0 ? 'Binayı İnşa Et' : 'Seviye Yükselt';
      }

      const prestigeGain = Math.floor((state.gold || 0) / 100000);
      document.getElementById('prestige-gain').innerText = prestigeGain;
      document.getElementById('prestige-btn').disabled = prestigeGain < 1;
    }

    canvas.addEventListener('mousemove', (e) => {
      const pos = getMousePos(e);
      let found = null;
      Object.values(state.buildings).forEach(bld => {
        if (pos.x >= bld.x && pos.x <= bld.x + bld.w && pos.y >= bld.y && pos.y <= bld.y + bld.h) {
          found = bld.id;
        }
      });
      hoveredBuilding = found;
    });

    canvas.addEventListener('click', (e) => {
      const pos = getMousePos(e);
      Object.values(state.buildings).forEach(bld => {
        if (pos.x >= bld.x && pos.x <= bld.x + bld.w && pos.y >= bld.y && pos.y <= bld.y + bld.h) {
          openBuildingModal(bld.id);
        }
      });
    });

    function openBuildingModal(id) {
      selectedBuildingId = id;
      const bld = state.buildings[id];
      document.getElementById('bld-title').innerText = bld.name;
      document.getElementById('bld-desc').innerText = bld.desc;
      openModal('buildingModal');
      updateUI();
    }

    function upgradeSelectedBuilding() {
      if (!selectedBuildingId) return;
      const bld = state.buildings[selectedBuildingId];
      const cost = getBuildingCost(bld);

      if (state.gold >= cost) {
        state.gold -= cost;
        bld.lvl++;
        updateUI();
      }
    }

    function buyMarketItem(item) {
      if (item === 'drone' && !state.upgrades.drone && state.gold >= 1000) {
        state.gold -= 1000;
        state.upgrades.drone = true;
        document.getElementById('buy-drone-btn').innerText = 'Satın Alındı';
        document.getElementById('buy-drone-btn').disabled = true;
      } else if (item === 'overclock' && !state.upgrades.overclock && state.gold >= 10000) {
        state.gold -= 10000;
        state.upgrades.overclock = true;
        document.getElementById('buy-oc-btn').innerText = 'Satın Alındı';
        document.getElementById('buy-oc-btn').disabled = true;
      }
      updateUI();
    }

    function doPrestige() {
      const gain = Math.floor(state.gold / 100000);
      if (gain >= 1) {
        state.prestige = (state.prestige || 0) + gain;
        state.gold = 50;
        Object.keys(state.buildings).forEach(k => {
          state.buildings[k].lvl = k === 'mine' ? 1 : 0;
        });
        state.upgrades.drone = false;
        state.upgrades.overclock = false;
        closeModal('prestigeModal');
        showToast(`Prestij Yapıldı! +${gain} Kristal`);
        updateUI();
      }
    }

    function openModal(modalId) {
      document.getElementById(modalId).style.display = 'flex';
    }

    function closeModal(modalId) {
      document.getElementById(modalId).style.display = 'none';
      if (modalId === 'buildingModal') selectedBuildingId = null;
    }

    function saveGame(showNotification = true) {
      localStorage.setItem('topdown_idle_save', JSON.stringify(state));
      if (showNotification) showToast('Oyun Kaydedildi!');
    }

    function loadGame() {
      const saved = localStorage.getItem('topdown_idle_save');
      if (saved) {
        try {
          const parsed = JSON.parse(saved);
          if (parsed && parsed.buildings && parsed.buildings.mine) {
            state = { ...defaultState, ...parsed };
          }
          if (state.upgrades.drone) {
            document.getElementById('buy-drone-btn').innerText = 'Satın Alındı';
            document.getElementById('buy-drone-btn').disabled = true;
          }
          if (state.upgrades.overclock) {
            document.getElementById('buy-oc-btn').innerText = 'Satın Alındı';
            document.getElementById('buy-oc-btn').disabled = true;
          }
        } catch (e) {
          console.error('Kayıt yüklenemedi', e);
        }
      }
    }

    function resetGame() {
      if (confirm('Tüm ilerleme sıfırlanacak. Emin misin?')) {
        localStorage.removeItem('topdown_idle_save');
        state = JSON.parse(JSON.stringify(defaultState));
        location.reload();
      }
    }

    function showToast(text) {
      const toast = document.getElementById('toast');
      toast.innerText = text;
      toast.style.display = 'block';
      setTimeout(() => { toast.style.display = 'none'; }, 2000);
    }

    loadGame();
    render();
    updateUI();
  </script>
</body>
</html>
