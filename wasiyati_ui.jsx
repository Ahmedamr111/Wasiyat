import { useState } from "react";

const theme = {
  ivory: "#FAF6F1",
  amber: "#E8A87C",
  rose: "#C4736A",
  taupe: "#8B7355",
  charcoal: "#2D2520",
  gold: "#F2C46D",
  bg: "#FDF9F5",
  card: "#FFFFFF",
  muted: "#B8A99A",
  success: "#7DB87D",
};

const styles = `
  @import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=DM+Sans:wght@300;400;500;600&display=swap');

  * { box-sizing: border-box; margin: 0; padding: 0; }

  body { background: #E8E0D8; font-family: 'DM Sans', sans-serif; }

  .phone-frame {
    width: 390px;
    height: 844px;
    background: ${theme.bg};
    border-radius: 50px;
    overflow: hidden;
    box-shadow: 0 40px 120px rgba(45,37,32,0.35), 0 0 0 12px #1a1512, inset 0 0 0 2px #3a2e28;
    position: relative;
    display: flex;
    flex-direction: column;
  }

  .status-bar {
    background: ${theme.bg};
    padding: 14px 24px 8px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 12px;
    font-weight: 600;
    color: ${theme.charcoal};
    flex-shrink: 0;
  }

  .notch {
    width: 120px;
    height: 30px;
    background: #1a1512;
    border-radius: 0 0 20px 20px;
    position: absolute;
    top: 0;
    left: 50%;
    transform: translateX(-50%);
    z-index: 10;
  }

  .screen {
    flex: 1;
    overflow-y: auto;
    scrollbar-width: none;
    -ms-overflow-style: none;
    position: relative;
  }

  .screen::-webkit-scrollbar { display: none; }

  /* Splash */
  .splash {
    height: 100%;
    background: linear-gradient(160deg, #F5E6D3 0%, #EDD5C0 40%, #E0C4A8 100%);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 20px;
    position: relative;
    overflow: hidden;
  }

  .splash::before {
    content: '';
    position: absolute;
    width: 400px;
    height: 400px;
    background: radial-gradient(circle, rgba(242,196,109,0.25) 0%, transparent 70%);
    top: 50%;
    left: 50%;
    transform: translate(-50%, -60%);
    border-radius: 50%;
  }

  .candle-icon {
    font-size: 64px;
    animation: flicker 2s ease-in-out infinite alternate;
    filter: drop-shadow(0 0 20px rgba(242,196,109,0.6));
  }

  @keyframes flicker {
    0% { transform: scale(1) rotate(-1deg); filter: drop-shadow(0 0 15px rgba(242,196,109,0.5)); }
    100% { transform: scale(1.05) rotate(1deg); filter: drop-shadow(0 0 30px rgba(242,196,109,0.8)); }
  }

  .splash-title {
    font-family: 'Cormorant Garamond', serif;
    font-size: 42px;
    font-weight: 600;
    color: ${theme.charcoal};
    letter-spacing: -0.5px;
    text-align: center;
  }

  .splash-arabic {
    font-size: 22px;
    color: ${theme.taupe};
    font-family: 'Cormorant Garamond', serif;
    font-style: italic;
    direction: rtl;
  }

  .splash-tagline {
    font-size: 14px;
    color: ${theme.taupe};
    text-align: center;
    line-height: 1.6;
    max-width: 260px;
  }

  .btn-primary {
    background: linear-gradient(135deg, ${theme.amber} 0%, ${theme.rose} 100%);
    color: white;
    border: none;
    padding: 16px 48px;
    border-radius: 50px;
    font-size: 15px;
    font-weight: 600;
    font-family: 'DM Sans', sans-serif;
    cursor: pointer;
    box-shadow: 0 8px 24px rgba(196,115,106,0.35);
    transition: all 0.2s ease;
    letter-spacing: 0.3px;
  }

  .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 12px 32px rgba(196,115,106,0.45); }
  .btn-primary:active { transform: translateY(0); }

  .btn-ghost {
    background: transparent;
    color: ${theme.taupe};
    border: 1.5px solid rgba(139,115,85,0.3);
    padding: 14px 48px;
    border-radius: 50px;
    font-size: 14px;
    font-weight: 500;
    font-family: 'DM Sans', sans-serif;
    cursor: pointer;
    transition: all 0.2s;
  }

  /* Dashboard */
  .dashboard-header {
    padding: 20px 24px 16px;
    background: linear-gradient(180deg, #F5E6D3 0%, ${theme.bg} 100%);
  }

  .greeting-line {
    font-size: 13px;
    color: ${theme.muted};
    font-weight: 400;
    margin-bottom: 4px;
  }

  .greeting-name {
    font-family: 'Cormorant Garamond', serif;
    font-size: 26px;
    font-weight: 600;
    color: ${theme.charcoal};
  }

  .status-pill {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    background: rgba(125,184,125,0.12);
    border: 1px solid rgba(125,184,125,0.3);
    color: ${theme.success};
    padding: 4px 10px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 600;
    margin-top: 8px;
  }

  .stats-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;
    padding: 16px 24px;
  }

  .stat-card {
    background: white;
    border-radius: 20px;
    padding: 18px;
    box-shadow: 0 2px 16px rgba(139,115,85,0.08);
    border: 1px solid rgba(232,168,124,0.15);
  }

  .stat-card.wide {
    grid-column: 1 / -1;
  }

  .stat-icon {
    font-size: 24px;
    margin-bottom: 8px;
  }

  .stat-number {
    font-family: 'Cormorant Garamond', serif;
    font-size: 32px;
    font-weight: 600;
    color: ${theme.charcoal};
    line-height: 1;
  }

  .stat-label {
    font-size: 11px;
    color: ${theme.muted};
    font-weight: 500;
    margin-top: 4px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }

  .premium-banner {
    margin: 0 24px 16px;
    background: linear-gradient(135deg, #2D2520 0%, #4A3830 100%);
    border-radius: 20px;
    padding: 18px 20px;
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  .premium-text h4 {
    color: ${theme.gold};
    font-family: 'Cormorant Garamond', serif;
    font-size: 17px;
    font-weight: 600;
    margin-bottom: 3px;
  }

  .premium-text p {
    color: rgba(255,255,255,0.6);
    font-size: 11px;
    line-height: 1.4;
  }

  .btn-gold {
    background: linear-gradient(135deg, ${theme.gold} 0%, ${theme.amber} 100%);
    color: ${theme.charcoal};
    border: none;
    padding: 8px 16px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 700;
    cursor: pointer;
    white-space: nowrap;
    flex-shrink: 0;
  }

  .section-title {
    padding: 0 24px;
    font-family: 'Cormorant Garamond', serif;
    font-size: 20px;
    font-weight: 600;
    color: ${theme.charcoal};
    margin-bottom: 12px;
  }

  .message-card {
    margin: 0 24px 12px;
    background: white;
    border-radius: 20px;
    padding: 18px;
    box-shadow: 0 2px 16px rgba(139,115,85,0.07);
    border: 1px solid rgba(232,168,124,0.12);
    display: flex;
    align-items: center;
    gap: 14px;
    cursor: pointer;
    transition: all 0.2s;
  }

  .message-card:hover { transform: translateY(-1px); box-shadow: 0 6px 24px rgba(139,115,85,0.12); }

  .msg-icon-wrap {
    width: 48px;
    height: 48px;
    border-radius: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
    flex-shrink: 0;
  }

  .msg-icon-amber { background: rgba(232,168,124,0.15); }
  .msg-icon-rose { background: rgba(196,115,106,0.12); }
  .msg-icon-gold { background: rgba(242,196,109,0.15); }

  .msg-info { flex: 1; min-width: 0; }

  .msg-title {
    font-size: 14px;
    font-weight: 600;
    color: ${theme.charcoal};
    margin-bottom: 3px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .msg-meta {
    font-size: 11px;
    color: ${theme.muted};
  }

  .msg-badge {
    font-size: 10px;
    font-weight: 600;
    padding: 3px 8px;
    border-radius: 10px;
    flex-shrink: 0;
  }

  .badge-immediate { background: rgba(196,115,106,0.12); color: ${theme.rose}; }
  .badge-recurring { background: rgba(232,168,124,0.15); color: ${theme.amber}; }
  .badge-occasion { background: rgba(242,196,109,0.15); color: #B8860B; }

  /* Bottom Nav */
  .bottom-nav {
    display: flex;
    background: white;
    border-top: 1px solid rgba(139,115,85,0.1);
    padding: 10px 0 28px;
    flex-shrink: 0;
  }

  .nav-item {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 4px;
    cursor: pointer;
    padding: 6px 0;
    transition: all 0.2s;
  }

  .nav-icon { font-size: 22px; line-height: 1; }

  .nav-label {
    font-size: 10px;
    font-weight: 500;
    color: ${theme.muted};
  }

  .nav-item.active .nav-label { color: ${theme.rose}; }
  .nav-item.active .nav-icon { filter: drop-shadow(0 0 4px rgba(196,115,106,0.4)); }

  /* FAB */
  .fab {
    position: absolute;
    bottom: 88px;
    right: 24px;
    width: 56px;
    height: 56px;
    background: linear-gradient(135deg, ${theme.amber} 0%, ${theme.rose} 100%);
    border-radius: 18px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 26px;
    box-shadow: 0 8px 24px rgba(196,115,106,0.4);
    cursor: pointer;
    z-index: 5;
    transition: all 0.2s;
  }

  .fab:hover { transform: scale(1.05); }

  /* Composer screen */
  .composer-screen {
    height: 100%;
    display: flex;
    flex-direction: column;
    background: ${theme.bg};
  }

  .composer-header {
    padding: 16px 20px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    border-bottom: 1px solid rgba(139,115,85,0.1);
    background: white;
    flex-shrink: 0;
  }

  .composer-header h3 {
    font-family: 'Cormorant Garamond', serif;
    font-size: 20px;
    color: ${theme.charcoal};
  }

  .back-btn {
    width: 36px;
    height: 36px;
    border-radius: 10px;
    background: rgba(139,115,85,0.08);
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    font-size: 16px;
  }

  .save-btn {
    background: linear-gradient(135deg, ${theme.amber} 0%, ${theme.rose} 100%);
    color: white;
    border: none;
    padding: 8px 18px;
    border-radius: 20px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    font-family: 'DM Sans', sans-serif;
  }

  .type-selector {
    display: flex;
    gap: 8px;
    padding: 16px 20px;
    overflow-x: auto;
    scrollbar-width: none;
    flex-shrink: 0;
  }

  .type-chip {
    padding: 8px 16px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
    white-space: nowrap;
    cursor: pointer;
    border: 1.5px solid transparent;
    transition: all 0.2s;
    flex-shrink: 0;
  }

  .type-chip.active {
    background: linear-gradient(135deg, ${theme.amber} 0%, ${theme.rose} 100%);
    color: white;
    box-shadow: 0 4px 12px rgba(196,115,106,0.25);
  }

  .type-chip.inactive {
    background: white;
    color: ${theme.taupe};
    border-color: rgba(139,115,85,0.2);
  }

  .parchment-editor {
    flex: 1;
    margin: 0 20px;
    background: linear-gradient(180deg, #FFFAF5 0%, #FFF8F0 100%);
    border-radius: 20px;
    padding: 24px;
    border: 1px solid rgba(232,168,124,0.2);
    box-shadow: inset 0 2px 8px rgba(139,115,85,0.05);
    position: relative;
    overflow: hidden;
    min-height: 200px;
  }

  .parchment-editor::before {
    content: '';
    position: absolute;
    top: 0; left: 0; right: 0; bottom: 0;
    background: repeating-linear-gradient(
      transparent,
      transparent 27px,
      rgba(232,168,124,0.12) 28px
    );
    pointer-events: none;
  }

  .editor-placeholder {
    font-family: 'Cormorant Garamond', serif;
    font-size: 17px;
    color: rgba(139,115,85,0.5);
    font-style: italic;
    line-height: 1.8;
    position: relative;
    z-index: 1;
  }

  .editor-content {
    font-family: 'Cormorant Garamond', serif;
    font-size: 17px;
    color: ${theme.charcoal};
    line-height: 1.8;
    position: relative;
    z-index: 1;
  }

  .media-bar {
    display: flex;
    gap: 10px;
    padding: 14px 20px;
    border-top: 1px solid rgba(139,115,85,0.08);
    background: white;
    flex-shrink: 0;
  }

  .media-btn {
    width: 40px;
    height: 40px;
    border-radius: 12px;
    background: rgba(139,115,85,0.07);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 18px;
    cursor: pointer;
    transition: all 0.15s;
  }

  .media-btn:hover { background: rgba(232,168,124,0.2); }

  .media-btn.locked { opacity: 0.5; position: relative; }

  .recipient-section {
    padding: 16px 20px;
    flex-shrink: 0;
  }

  .recipient-label {
    font-size: 11px;
    font-weight: 600;
    color: ${theme.muted};
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 10px;
  }

  .recipient-chips {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
  }

  .recipient-chip {
    display: flex;
    align-items: center;
    gap: 6px;
    background: white;
    border: 1px solid rgba(232,168,124,0.3);
    border-radius: 20px;
    padding: 6px 12px;
    font-size: 12px;
    color: ${theme.charcoal};
    font-weight: 500;
    cursor: pointer;
  }

  .recipient-avatar {
    width: 20px;
    height: 20px;
    border-radius: 50%;
    background: linear-gradient(135deg, ${theme.amber}, ${theme.rose});
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 10px;
    color: white;
    font-weight: 700;
  }

  .add-recipient-chip {
    display: flex;
    align-items: center;
    gap: 6px;
    background: rgba(139,115,85,0.07);
    border: 1.5px dashed rgba(139,115,85,0.25);
    border-radius: 20px;
    padding: 6px 12px;
    font-size: 12px;
    color: ${theme.taupe};
    cursor: pointer;
  }

  /* Screen selector */
  .screen-selector {
    display: flex;
    gap: 6px;
    padding: 12px 16px;
    background: rgba(45,37,32,0.9);
    border-radius: 20px;
    margin: 0 auto 24px;
    width: fit-content;
  }

  .screen-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: rgba(255,255,255,0.3);
    cursor: pointer;
    transition: all 0.2s;
  }

  .screen-dot.active {
    background: ${theme.gold};
    width: 24px;
    border-radius: 4px;
  }

  /* Wax seal animation */
  .wax-seal {
    position: absolute;
    bottom: 20px;
    right: 20px;
    width: 52px;
    height: 52px;
    background: radial-gradient(circle, #C4736A 0%, #9B4F47 100%);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
    box-shadow: 0 4px 16px rgba(155,79,71,0.4), inset 0 1px 0 rgba(255,255,255,0.2);
  }

  /* Checkin screen */
  .checkin-card {
    margin: 16px;
    background: white;
    border-radius: 24px;
    padding: 28px 24px;
    text-align: center;
    box-shadow: 0 4px 24px rgba(139,115,85,0.1);
    border: 1px solid rgba(232,168,124,0.2);
  }

  .checkin-icon {
    font-size: 56px;
    margin-bottom: 16px;
    filter: drop-shadow(0 4px 12px rgba(232,168,124,0.3));
  }

  .checkin-title {
    font-family: 'Cormorant Garamond', serif;
    font-size: 24px;
    color: ${theme.charcoal};
    font-weight: 600;
    margin-bottom: 10px;
  }

  .checkin-subtitle {
    font-size: 14px;
    color: ${theme.muted};
    line-height: 1.6;
    margin-bottom: 24px;
  }

  .checkin-btn-yes {
    background: linear-gradient(135deg, #7DB87D, #5A9E5A);
    color: white;
    border: none;
    padding: 16px;
    border-radius: 16px;
    width: 100%;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    font-family: 'DM Sans', sans-serif;
    box-shadow: 0 8px 20px rgba(90,158,90,0.3);
    margin-bottom: 10px;
  }

  .timer-ring {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    border: 4px solid rgba(232,168,124,0.2);
    border-top-color: ${theme.amber};
    margin: 0 auto 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-family: 'Cormorant Garamond', serif;
    font-size: 18px;
    font-weight: 600;
    color: ${theme.charcoal};
    animation: spin 8s linear infinite;
    position: relative;
  }

  .timer-inner {
    position: absolute;
    font-size: 13px;
    font-family: 'DM Sans', sans-serif;
    color: ${theme.muted};
    font-weight: 500;
  }

  @keyframes spin { to { transform: rotate(360deg); } }
`;

const screens = ["splash", "dashboard", "composer", "checkin"];
const screenLabels = ["Splash", "Dashboard", "Compose", "Check-in"];

function SplashScreen({ onNav }) {
  return (
    <div className="splash">
      <div className="candle-icon">🕯️</div>
      <div>
        <div className="splash-title">Wasiyati</div>
        <div className="splash-arabic">وصيتي</div>
      </div>
      <p className="splash-tagline">
        Leave your words behind.<br />
        <em>Forever.</em>
      </p>
      <div style={{ display: "flex", flexDirection: "column", gap: 10, width: "100%", padding: "0 40px", marginTop: 8 }}>
        <button className="btn-primary" onClick={() => onNav("dashboard")}>Get Started</button>
        <button className="btn-ghost">I already have an account</button>
      </div>
      <p style={{ fontSize: 11, color: theme.muted, marginTop: 8 }}>
        Available in العربية · English · Français
      </p>
    </div>
  );
}

function DashboardScreen({ onNav }) {
  const messages = [
    { icon: "✉️", iconClass: "msg-icon-amber", title: "To my beloved children", meta: "Immediate · 3 recipients", badge: "Immediate", badgeClass: "badge-immediate" },
    { icon: "🌿", iconClass: "msg-icon-gold", title: "Friday blessing — every week", meta: "Weekly · My family group", badge: "Recurring", badgeClass: "badge-recurring" },
    { icon: "🎂", iconClass: "msg-icon-rose", title: "Happy birthday, Sara", meta: "June 14 every year", badge: "Occasion", badgeClass: "badge-occasion" },
  ];

  return (
    <div style={{ height: "100%", overflowY: "auto" }}>
      {/* Header */}
      <div className="dashboard-header">
        <p className="greeting-line">Good morning</p>
        <div className="greeting-name">Ahmed 🌙</div>
        <div className="status-pill">
          <span style={{ width: 6, height: 6, borderRadius: "50%", background: theme.success, display: "inline-block" }} />
          Legacy is safe
        </div>
      </div>

      {/* Stats */}
      <div className="stats-grid">
        <div className="stat-card">
          <div className="stat-icon">📝</div>
          <div className="stat-number">7</div>
          <div className="stat-label">Messages</div>
        </div>
        <div className="stat-card">
          <div className="stat-icon">👥</div>
          <div className="stat-number">5</div>
          <div className="stat-label">Recipients</div>
        </div>
        <div className="stat-card wide" style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
          <div>
            <div className="stat-icon">⏰</div>
            <div style={{ fontSize: 13, fontWeight: 600, color: theme.charcoal }}>Next check-in</div>
            <div style={{ fontSize: 12, color: theme.muted, marginTop: 2 }}>23 days remaining</div>
          </div>
          <div style={{ textAlign: "right" }}>
            <div style={{ fontSize: 28, fontFamily: "'Cormorant Garamond', serif", fontWeight: 600, color: theme.amber }}>Jun 21</div>
            <div style={{ fontSize: 11, color: theme.muted }}>2025</div>
          </div>
        </div>
      </div>

      {/* Premium banner */}
      <div className="premium-banner">
        <div className="premium-text">
          <h4>✨ Unlock Premium</h4>
          <p>Unlimited messages · Video · The Vault</p>
        </div>
        <button className="btn-gold">Upgrade</button>
      </div>

      {/* Messages */}
      <div className="section-title">Your Messages</div>
      {messages.map((m, i) => (
        <div key={i} className="message-card" onClick={() => onNav("composer")}>
          <div className={`msg-icon-wrap ${m.iconClass}`}>{m.icon}</div>
          <div className="msg-info">
            <div className="msg-title">{m.title}</div>
            <div className="msg-meta">{m.meta}</div>
          </div>
          <span className={`msg-badge ${m.badgeClass}`}>{m.badge}</span>
        </div>
      ))}

      <div style={{ padding: "8px 24px 20px" }}>
        <button className="btn-primary" style={{ width: "100%", padding: "14px" }} onClick={() => onNav("composer")}>
          + New Message
        </button>
      </div>
    </div>
  );
}

function ComposerScreen({ onNav }) {
  const [activeType, setActiveType] = useState("Immediate");
  const types = ["Immediate", "Recurring", "Occasion", "Milestone"];

  return (
    <div className="composer-screen">
      <div className="composer-header">
        <div className="back-btn" onClick={() => onNav("dashboard")}>←</div>
        <h3>New Message</h3>
        <button className="save-btn">Save 🪶</button>
      </div>

      <div className="type-selector">
        {types.map(t => (
          <div
            key={t}
            className={`type-chip ${activeType === t ? "active" : "inactive"}`}
            onClick={() => setActiveType(t)}
          >{t}</div>
        ))}
      </div>

      <div style={{ flex: 1, overflow: "auto", padding: "0 0 12px" }}>
        <div style={{ padding: "0 20px 16px" }}>
          <input
            style={{
              width: "100%", border: "none", borderBottom: `2px solid rgba(232,168,124,0.3)`,
              background: "transparent", fontFamily: "'Cormorant Garamond', serif",
              fontSize: 20, color: theme.charcoal, padding: "8px 0", outline: "none"
            }}
            placeholder="Message title (private)..."
          />
        </div>

        <div style={{ position: "relative", margin: "0 20px", height: 220 }}>
          <div className="parchment-editor" style={{ height: "100%" }}>
            <div className="editor-content">
              My dearest children,<br /><br />
              By the time you read this, I will have returned to my Lord. Know that every moment I spent with you was the greatest blessing of my life...
            </div>
          </div>
          <div className="wax-seal">🕊️</div>
        </div>

        <div className="recipient-section">
          <div className="recipient-label">Send to</div>
          <div className="recipient-chips">
            <div className="recipient-chip">
              <div className="recipient-avatar">S</div>
              Sara
            </div>
            <div className="recipient-chip">
              <div className="recipient-avatar">K</div>
              Khalid
            </div>
            <div className="add-recipient-chip">+ Add</div>
          </div>
        </div>

        {activeType === "Recurring" && (
          <div style={{ padding: "0 20px 12px" }}>
            <div className="recipient-label">Send every</div>
            <div style={{ display: "flex", gap: 8 }}>
              {["Weekly", "Monthly", "Yearly"].map(f => (
                <div key={f} className={`type-chip ${f === "Weekly" ? "active" : "inactive"}`} style={{ fontSize: 11 }}>{f}</div>
              ))}
            </div>
          </div>
        )}
      </div>

      <div className="media-bar">
        <div className="media-btn">🎙️</div>
        <div className="media-btn">📷</div>
        <div className="media-btn locked" title="Premium">🎥
          <span style={{ position: "absolute", top: -2, right: -2, background: theme.gold, borderRadius: "50%", width: 14, height: 14, fontSize: 8, display: "flex", alignItems: "center", justifyContent: "center" }}>👑</span>
        </div>
        <div className="media-btn">📎</div>
        <div style={{ marginLeft: "auto", display: "flex", alignItems: "center", gap: 4, fontSize: 11, color: theme.muted }}>
          <span style={{ width: 6, height: 6, borderRadius: "50%", background: "#7DB87D", display: "inline-block" }} />
          Auto-saved
        </div>
      </div>
    </div>
  );
}

function CheckinScreen({ onNav }) {
  return (
    <div style={{ height: "100%", overflowY: "auto", padding: "20px 0" }}>
      <div style={{ padding: "0 24px 20px" }}>
        <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 22, color: theme.charcoal, fontWeight: 600 }}>Monthly Check-in</div>
        <div style={{ fontSize: 13, color: theme.muted, marginTop: 4 }}>May 29, 2025</div>
      </div>

      <div className="checkin-card">
        <div className="checkin-icon">🌙</div>
        <div className="checkin-title">Are you still with us?</div>
        <p className="checkin-subtitle">
          Your loved ones are waiting for your messages.<br />
          Let us know you're alright.
        </p>
        <div className="timer-ring">
          <div className="timer-inner">6 days left</div>
        </div>
        <button className="checkin-btn-yes">✓  Yes, I'm alright</button>
        <div style={{ fontSize: 12, color: theme.muted, marginTop: 8, cursor: "pointer" }}>
          Remind me tomorrow
        </div>
      </div>

      {/* Trusted contact card */}
      <div style={{ margin: "0 16px", background: "white", borderRadius: 20, padding: 20, border: `1px solid rgba(232,168,124,0.15)`, boxShadow: "0 2px 12px rgba(139,115,85,0.07)" }}>
        <div style={{ display: "flex", alignItems: "center", gap: 12, marginBottom: 14 }}>
          <div style={{ width: 44, height: 44, borderRadius: 14, background: "linear-gradient(135deg, #E8A87C, #C4736A)", display: "flex", alignItems: "center", justifyContent: "center", color: "white", fontWeight: 700, fontSize: 16 }}>M</div>
          <div>
            <div style={{ fontSize: 14, fontWeight: 600, color: theme.charcoal }}>Mohamed (Trusted Contact)</div>
            <div style={{ fontSize: 11, color: theme.muted }}>Brother · Will be notified if no response</div>
          </div>
        </div>
        <div style={{ fontSize: 12, color: theme.muted, lineHeight: 1.5, background: theme.bg, borderRadius: 12, padding: "10px 14px" }}>
          If you don't respond within 7 days, Mohamed will receive a notification to confirm your status.
        </div>
      </div>

      <div style={{ margin: "16px 16px 0", display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10 }}>
        <div style={{ background: "white", borderRadius: 18, padding: 16, textAlign: "center", border: "1px solid rgba(232,168,124,0.15)" }}>
          <div style={{ fontSize: 22, marginBottom: 6 }}>📬</div>
          <div style={{ fontSize: 22, fontFamily: "'Cormorant Garamond', serif", fontWeight: 600, color: theme.charcoal }}>7</div>
          <div style={{ fontSize: 11, color: theme.muted }}>Messages ready</div>
        </div>
        <div style={{ background: "white", borderRadius: 18, padding: 16, textAlign: "center", border: "1px solid rgba(232,168,124,0.15)" }}>
          <div style={{ fontSize: 22, marginBottom: 6 }}>🛡️</div>
          <div style={{ fontSize: 22, fontFamily: "'Cormorant Garamond', serif", fontWeight: 600, color: theme.charcoal }}>AES</div>
          <div style={{ fontSize: 11, color: theme.muted }}>256-bit encrypted</div>
        </div>
      </div>
    </div>
  );
}

export default function WasiyatiApp() {
  const [currentScreen, setCurrentScreen] = useState("splash");

  const screenComponents = {
    splash: <SplashScreen onNav={setCurrentScreen} />,
    dashboard: <DashboardScreen onNav={setCurrentScreen} />,
    composer: <ComposerScreen onNav={setCurrentScreen} />,
    checkin: <CheckinScreen onNav={setCurrentScreen} />,
  };

  return (
    <div style={{ minHeight: "100vh", background: "linear-gradient(135deg, #D4C5B5 0%, #C8B8A8 50%, #BCA898 100%)", display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", padding: 24, fontFamily: "'DM Sans', sans-serif" }}>
      <style>{styles}</style>

      {/* Screen selector */}
      <div style={{ display: "flex", gap: 6, marginBottom: 20, background: "rgba(45,37,32,0.85)", borderRadius: 20, padding: "10px 14px", backdropFilter: "blur(8px)" }}>
        {screens.map((s, i) => (
          <div
            key={s}
            onClick={() => setCurrentScreen(s)}
            style={{
              padding: "6px 14px", borderRadius: 12, cursor: "pointer", fontSize: 12, fontWeight: 600,
              background: currentScreen === s ? "linear-gradient(135deg, #E8A87C, #C4736A)" : "transparent",
              color: currentScreen === s ? "white" : "rgba(255,255,255,0.5)",
              transition: "all 0.2s"
            }}
          >
            {screenLabels[i]}
          </div>
        ))}
      </div>

      {/* Phone */}
      <div className="phone-frame">
        <div className="notch" />
        <div className="status-bar" style={{ paddingTop: 16 }}>
          <span>9:41</span>
          <span style={{ width: 80 }} />
          <span>●●●  WiFi  🔋</span>
        </div>

        <div className="screen">
          {screenComponents[currentScreen]}
        </div>

        {/* Bottom nav — only on non-splash non-composer */}
        {currentScreen === "dashboard" || currentScreen === "checkin" ? (
          <div className="bottom-nav">
            {[
              { icon: "🏠", label: "Home", id: "dashboard" },
              { icon: "📝", label: "Messages", id: "dashboard" },
              { icon: "👥", label: "People", id: "dashboard" },
              { icon: "🏛️", label: "Vault", id: "dashboard" },
              { icon: "👤", label: "Profile", id: "dashboard" },
            ].map((item, i) => (
              <div key={i} className={`nav-item ${i === 0 ? "active" : ""}`} onClick={() => setCurrentScreen(item.id)}>
                <span className="nav-icon">{item.icon}</span>
                <span className="nav-label">{item.label}</span>
              </div>
            ))}
          </div>
        ) : null}

        {currentScreen === "dashboard" && (
          <div className="fab" onClick={() => setCurrentScreen("composer")}>+</div>
        )}
      </div>

      <p style={{ marginTop: 20, fontSize: 12, color: "rgba(45,37,32,0.5)", textAlign: "center" }}>
        Wasiyati · وصيتي · Interactive UI Prototype
      </p>
    </div>
  );
}
