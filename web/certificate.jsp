<%@page contentType="text/html" pageEncoding="UTF-8" isELIgnored="true"%>
<%@page import="com.eauction.form.AuctionForm"%>
<%@page import="com.eauction.form.BidForm"%>
<%@page import="com.eauction.form.UserForm"%>
<%
    AuctionForm auction = (AuctionForm) request.getAttribute("auction");
    BidForm winningBid = (BidForm) request.getAttribute("winningBid");
    UserForm buyer = (UserForm) request.getAttribute("buyer");
    UserForm seller = (UserForm) request.getAttribute("seller");
    Boolean isWinner = (Boolean) request.getAttribute("isWinner");
    Boolean isSeller = (Boolean) request.getAttribute("isSeller");
    String certNumber = (String) request.getAttribute("certNumber");
    String completionDate = (String) request.getAttribute("completionDate");
    Integer totalBids = (Integer) request.getAttribute("totalBids");

    if (auction == null || winningBid == null || buyer == null || seller == null) {
        String auctionIdParam = request.getParameter("auctionId");
        if (auctionIdParam != null && !auctionIdParam.trim().isEmpty()) {
            response.sendRedirect("certificate?auctionId=" + auctionIdParam);
            return;
        }
        response.sendRedirect("dashboard.jsp");
        return;
    }

    if (isWinner == null) isWinner = false;
    if (isSeller == null) isSeller = false;
    if (totalBids == null) totalBids = 1;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Certificate of Ownership - <%= auction.getName() %> (#<%= certNumber %>)</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@500;700;800;900&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --navy-dark: #061325;
            --navy-base: #0b1f3a;
            --gold-light: #fde68a;
            --gold-base: #d97706;
            --gold-dark: #92400e;
            --emerald-base: #059669;
            --emerald-bg: #ecfdf5;
            --ink-main: #0f172a;
            --ink-muted: #475569;
            --border-parchment: #e2d9c8;
        }

        body {
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #09121f;
            background-image: 
                radial-gradient(circle at 50% 0%, rgba(30, 58, 138, 0.35) 0%, transparent 70%),
                radial-gradient(circle at 50% 100%, rgba(15, 23, 42, 0.8) 0%, transparent 70%);
            color: var(--ink-main);
            min-height: 100vh;
            padding: 30px 16px 60px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        /* ================= FLOATING ACTION BAR ================= */
        .action-toolbar {
            width: 100%;
            max-width: 960px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 22px;
            background: rgba(15, 23, 42, 0.75);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            padding: 12px 20px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
        }

        .action-toolbar-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .back-link {
            color: #cbd5e1;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 6px;
            background: rgba(255, 255, 255, 0.06);
            transition: all 0.2s ease;
        }

        .back-link:hover {
            background: rgba(255, 255, 255, 0.15);
            color: #ffffff;
        }

        .action-toolbar-right {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .btn-print {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: #0f172a;
            border: none;
            padding: 8px 18px;
            font-size: 13px;
            font-weight: 800;
            border-radius: 8px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            box-shadow: 0 4px 14px rgba(217, 119, 6, 0.35);
            transition: transform 0.15s ease, box-shadow 0.15s ease;
        }

        .btn-print:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 18px rgba(217, 119, 6, 0.45);
        }

        /* ================= STATUS BANNER ================= */
        .notice-banner {
            width: 100%;
            max-width: 960px;
            border-radius: 10px;
            padding: 12px 18px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 13px;
            font-weight: 600;
        }

        .banner-winner {
            background: rgba(16, 185, 129, 0.15);
            border: 1px solid rgba(16, 185, 129, 0.4);
            color: #6ee7b7;
        }

        .banner-seller {
            background: rgba(59, 130, 246, 0.15);
            border: 1px solid rgba(59, 130, 246, 0.4);
            color: #93c5fd;
        }

        /* ================= CERTIFICATE CONTAINER ================= */
        .cert-paper {
            width: 100%;
            max-width: 960px;
            background: #ffffff;
            background-image: 
                radial-gradient(#e5e7eb 0.75px, transparent 0.75px);
            background-size: 24px 24px;
            border-radius: 16px;
            box-shadow: 
                0 25px 60px -15px rgba(0, 0, 0, 0.6),
                0 0 0 1px rgba(255, 255, 255, 0.1);
            position: relative;
            padding: 24px;
            box-sizing: border-box;
        }

        /* Outer Double Filigree Border */
        .cert-border-outer {
            border: 4px solid var(--navy-dark);
            border-radius: 10px;
            padding: 6px;
            position: relative;
            background: #ffffff;
        }

        .cert-border-inner {
            border: 1.5px solid var(--gold-base);
            border-radius: 6px;
            padding: 36px 40px 40px;
            position: relative;
            background: #fffdfa;
        }

        /* Decorative Corner Brackets */
        .corner-bracket {
            position: absolute;
            width: 26px;
            height: 26px;
            border-color: var(--gold-base);
            border-style: solid;
            pointer-events: none;
        }

        .corner-tl { top: 10px; left: 10px; border-width: 3px 0 0 3px; }
        .corner-tr { top: 10px; right: 10px; border-width: 3px 3px 0 0; }
        .corner-bl { bottom: 10px; left: 10px; border-width: 0 0 3px 3px; }
        .corner-br { bottom: 10px; right: 10px; border-width: 0 3px 3px 0; }

        /* ================= CERTIFICATE HEADER ================= */
        .cert-header {
            text-align: center;
            position: relative;
            margin-bottom: 26px;
            padding-bottom: 22px;
            border-bottom: 1.5px solid #ebd9b8;
        }

        .cert-crest {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 64px;
            height: 64px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--navy-dark), var(--navy-base));
            color: #f59e0b;
            box-shadow: 0 4px 14px rgba(6, 19, 37, 0.25);
            margin-bottom: 12px;
            border: 2px solid var(--gold-base);
        }

        .cert-authority {
            font-family: 'Cinzel', Georgia, serif;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 3.5px;
            text-transform: uppercase;
            color: var(--gold-dark);
            margin-bottom: 6px;
        }

        .cert-title {
            font-family: 'Cinzel', Georgia, serif;
            font-size: 30px;
            font-weight: 900;
            letter-spacing: 1.5px;
            color: var(--navy-dark);
            line-height: 1.2;
            margin-bottom: 6px;
            text-transform: uppercase;
        }

        .cert-subtitle {
            font-size: 13px;
            font-weight: 600;
            letter-spacing: 1px;
            color: var(--ink-muted);
            text-transform: uppercase;
        }

        .cert-meta-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 16px;
            padding: 8px 16px;
            background: #f7f3ea;
            border-radius: 6px;
            font-size: 12px;
        }

        .cert-serial {
            font-family: ui-monospace, SFMono-Regular, Consolas, monospace;
            font-weight: 700;
            color: var(--navy-dark);
            letter-spacing: 1px;
        }

        .cert-date {
            color: #64748b;
            font-weight: 600;
        }

        /* ================= PROCLAMATION ================= */
        .cert-proclamation {
            text-align: center;
            font-size: 13.5px;
            line-height: 1.7;
            color: #334155;
            max-width: 780px;
            margin: 0 auto 28px;
            font-style: normal;
        }

        .cert-proclamation strong {
            color: var(--navy-dark);
            font-weight: 700;
        }

        /* ================= LOT / ITEM SPECIFICATIONS ================= */
        .lot-card {
            background: #ffffff;
            border: 1px solid #e7ddca;
            border-radius: 10px;
            padding: 20px 24px;
            margin-bottom: 26px;
            display: grid;
            grid-template-columns: 1.4fr 1fr;
            gap: 24px;
            box-shadow: 0 4px 12px rgba(15, 23, 42, 0.03);
            position: relative;
        }

        .lot-info h3 {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            color: var(--gold-dark);
            font-weight: 800;
            margin-bottom: 6px;
        }

        .lot-title {
            font-size: 20px;
            font-weight: 800;
            color: var(--navy-dark);
            margin-bottom: 6px;
            line-height: 1.3;
        }

        .lot-category {
            display: inline-block;
            background: #f1f5f9;
            color: #475569;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 20px;
            margin-bottom: 8px;
            border: 1px solid #cbd5e1;
        }

        .lot-desc {
            font-size: 12.5px;
            color: #64748b;
            line-height: 1.5;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .lot-financials {
            display: flex;
            flex-direction: column;
            justify-content: center;
            background: #faf8f3;
            border-left: 2px dashed #ebd9b8;
            padding-left: 24px;
        }

        .financial-row {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            color: #64748b;
            margin-bottom: 6px;
        }

        .financial-hammer {
            margin-top: 6px;
            padding-top: 8px;
            border-top: 1.5px solid #ebd9b8;
            display: flex;
            justify-content: space-between;
            align-items: baseline;
        }

        .financial-hammer span {
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--navy-dark);
        }

        .financial-hammer strong {
            font-size: 24px;
            font-weight: 900;
            color: #047857;
            letter-spacing: -0.5px;
        }

        /* ================= PARTIES CONVEYANCE ================= */
        .parties-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }

        .party-box {
            background: #ffffff;
            border: 1px solid #e7ddca;
            border-radius: 8px;
            padding: 16px 20px;
            position: relative;
        }

        .party-box.winner-box {
            background: #fbfdfc;
            border-color: #a7f3d0;
        }

        .party-role-tag {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 10.5px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 3px 8px;
            border-radius: 4px;
            margin-bottom: 10px;
        }

        .tag-seller {
            background: #f1f5f9;
            color: #334155;
            border: 1px solid #cbd5e1;
        }

        .tag-winner {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #6ee7b7;
        }

        .party-name {
            font-size: 16px;
            font-weight: 800;
            color: var(--navy-dark);
            margin-bottom: 4px;
        }

        .party-detail {
            font-size: 12px;
            color: #64748b;
            line-height: 1.5;
        }

        /* ================= FOOTER / SEAL ================= */
        .cert-footer {
            display: flex;
            justify-content: center;
            align-items: center;
            padding-top: 24px;
            border-top: 1.5px solid #ebd9b8;
        }

        /* Official Embossed Seal */
        .seal-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .official-seal {
            width: 110px;
            height: 110px;
            border-radius: 50%;
            border: 3px dashed var(--gold-base);
            padding: 4px;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            background: radial-gradient(circle, #fffaf0 0%, #fef3c7 100%);
            box-shadow: 0 4px 14px rgba(217, 119, 6, 0.2);
        }

        .seal-inner-circle {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            border: 1.5px solid var(--gold-dark);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 6px;
            box-sizing: border-box;
        }

        .seal-text-top {
            font-size: 8px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            color: var(--gold-dark);
        }

        .seal-icon {
            margin: 2px 0;
            color: var(--navy-dark);
        }

        .seal-text-bottom {
            font-size: 7.5px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #047857;
        }

        /* ================= PRINT STYLES ================= */
        @media print {
            body {
                background: #ffffff !important;
                padding: 0 !important;
                margin: 0 !important;
                color: #000000 !important;
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
            }

            .action-toolbar,
            .notice-banner {
                display: none !important;
            }

            .cert-paper {
                box-shadow: none !important;
                border-radius: 0 !important;
                max-width: 100% !important;
                width: 100% !important;
                padding: 0 !important;
            }

            .cert-border-outer {
                border-width: 3px !important;
                border-color: #061325 !important;
            }

            .cert-border-inner {
                padding: 24px 28px !important;
            }

            @page {
                size: A4 portrait;
                margin: 10mm;
            }
        }

        @media (max-width: 768px) {
            .lot-card {
                grid-template-columns: 1fr;
            }
            .lot-financials {
                border-left: none;
                border-top: 1.5px dashed #ebd9b8;
                padding-left: 0;
                padding-top: 16px;
            }
            .parties-grid {
                grid-template-columns: 1fr;
            }
            .cert-footer {
                justify-content: center;
            }
        }
    </style>
</head>
<body>

    <!-- ACTION TOOLBAR (SCREEN ONLY) -->
    <div class="action-toolbar">
        <div class="action-toolbar-left">
            <a href="dashboard.jsp" class="back-link">Back to Dashboard</a>
            <a href="bid.jsp?auctionId=<%= auction.getAuctionId() %>" class="back-link">View Auction Listing</a>
        </div>
        <div class="action-toolbar-right">
            <button onclick="window.print()" class="btn-print">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="6 9 6 2 18 2 18 9"></polyline>
                    <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path>
                    <rect x="6" y="14" width="12" height="8"></rect>
                </svg>
                Print / Save as PDF
            </button>
        </div>
    </div>

    <!-- ROLE NOTIFICATION BANNER (SCREEN ONLY) -->
    <% if (isWinner) { %>
        <div class="notice-banner banner-winner">
            <div>
                <strong>Award Certificate:</strong> Verified purchase record for <%= buyer.getName() %>.
            </div>
        </div>
    <% } else if (isSeller) { %>
        <div class="notice-banner banner-seller">
            <div>
                <strong>Seller Sales Record:</strong> Auction closed. Transfer recorded for winning bidder <%= buyer.getName() %>.
            </div>
        </div>
    <% } %>

    <!-- MAIN CERTIFICATE PAPER -->
    <div class="cert-paper">
        <div class="cert-border-outer">
            <div class="cert-border-inner">

                <!-- Decorative Corners -->
                <div class="corner-bracket corner-tl"></div>
                <div class="corner-bracket corner-tr"></div>
                <div class="corner-bracket corner-bl"></div>
                <div class="corner-bracket corner-br"></div>

                <!-- CERTIFICATE HEADER -->
                <header class="cert-header">
                    <div class="cert-crest">
                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="m14 13-7.5 7.5c-.83.83-2.17.83-3 0 0 0 0 0 0 0a2.12 2.12 0 0 1 0-3L11 10"/>
                            <path d="m16 16 6-6"/>
                            <path d="m8 8 6-6"/>
                            <path d="m9 7 8 8"/>
                            <path d="m21 11-8-8"/>
                        </svg>
                    </div>
                    <div class="cert-authority">E-Auction Settlement Registry</div>
                    <h1 class="cert-title">Certificate of Purchase & Settlement</h1>
                    <div class="cert-subtitle">Official Auction Transaction Record</div>

                    <div class="cert-meta-row">
                        <div>
                            <span style="color: #64748b; font-weight: 600;">CERTIFICATE ID:</span>
                            <span class="cert-serial"><%= certNumber %></span>
                        </div>
                        <div>
                            <span class="cert-date">Date Completed: <%= completionDate %></span>
                        </div>
                    </div>
                </header>

                <!-- PROCLAMATION -->
                <div class="cert-proclamation">
                    This document confirms that the lot described below has been awarded to the registered winning bidder following the conclusion of competitive bidding on the E-Auction platform.
                </div>

                <!-- LOT ASSET SPECIFICATIONS -->
                <div class="lot-card">
                    <div class="lot-info">
                        <h3>Item Specifications</h3>
                        <div class="lot-title"><%= auction.getName() %></div>
                        <div class="lot-category"><%= auction.getCategory() != null ? auction.getCategory() : "General" %> | Auction #<%= auction.getAuctionId() %></div>
                        <div class="lot-desc">
                            <%= auction.getDescription() != null && !auction.getDescription().trim().isEmpty() 
                                    ? auction.getDescription() 
                                    : "No additional description provided." %>
                        </div>
                    </div>

                    <div class="lot-financials">
                        <div class="financial-row">
                            <span>Starting Bid:</span>
                            <strong style="color: #0f172a;">₹<%= String.format("%,.2f", auction.getStartingBid()) %></strong>
                        </div>
                        <div class="financial-row">
                            <span>Total Bids Received:</span>
                            <strong style="color: #0f172a;"><%= totalBids %> <%= totalBids == 1 ? "Bid" : "Bids" %></strong>
                        </div>
                        <div class="financial-hammer">
                            <span>Final Winning Bid:</span>
                            <strong>₹<%= String.format("%,.2f", winningBid.getBidAmount()) %></strong>
                        </div>
                    </div>
                </div>

                <!-- PARTIES OF CONVEYANCE -->
                <div class="parties-grid">
                    <!-- SELLER -->
                    <div class="party-box">
                        <div class="party-role-tag tag-seller">
                            Seller
                        </div>
                        <div class="party-name"><%= seller.getName() %></div>
                        <div class="party-detail">
                            <strong>Seller ID:</strong> #<%= seller.getUserId() %><br>
                            <strong>Email:</strong> <%= seller.getEmail() %><br>
                            <strong>Location:</strong> <%= seller.getAddress() != null && !seller.getAddress().trim().isEmpty() ? seller.getAddress() : "Registered Seller" %>
                        </div>
                    </div>

                    <!-- BUYER / WINNER -->
                    <div class="party-box winner-box">
                        <div class="party-role-tag tag-winner">
                            Winning Bidder
                        </div>
                        <div class="party-name"><%= buyer.getName() %></div>
                        <div class="party-detail">
                            <strong>User ID:</strong> #<%= buyer.getUserId() %><br>
                            <strong>Email:</strong> <%= buyer.getEmail() %><br>
                            <strong>Address:</strong> <%= buyer.getAddress() != null && !buyer.getAddress().trim().isEmpty() ? buyer.getAddress() : "Registered User" %>
                        </div>
                    </div>
                </div>

                <!-- CERTIFICATE FOOTER: SEAL -->
                <footer class="cert-footer">
                    <div class="seal-wrapper">
                        <div class="official-seal">
                            <div class="seal-inner-circle">
                                <span class="seal-text-top">E-AUCTION</span>
                                <div class="seal-icon">
                                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#92400e" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <circle cx="12" cy="8" r="6"></circle>
                                        <path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"></path>
                                    </svg>
                                </div>
                                <span class="seal-text-bottom">SETTLEMENT SEAL</span>
                            </div>
                        </div>
                    </div>
                </footer>

            </div>
        </div>
    </div>

</body>
</html>
