<%@page contentType="text/html" pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>E-Auction | Live Auctions</title>

    <style>

        /* ================= GENERAL ================= */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            width: 100%;
            min-height: 100%;
            margin: 0;
            padding: 0;
            scroll-behavior: smooth;
            background: #f7f9fc;
            overscroll-behavior: none;
        }

        body {
            width: 100%;
            min-height: 100vh;
            min-height: 100dvh;
            margin: 0;
            padding: 0;
            font-family: Arial, Helvetica, sans-serif;
            background: #f7f9fc;
            color: #0f172a;
            overflow-x: hidden;
            overscroll-behavior: none;
        }


        /* ================= NAVBAR ================= */

        .navbar {
            height: 70px;
            background: #06152b;

            display: flex;
            align-items: center;
            justify-content: space-between;

            padding: 0 35px;

            box-shadow:
                0 2px 8px rgba(0, 0, 0, 0.12);
        }


        .logo {
            display: flex;
            align-items: center;
            gap: 9px;

            color: white;
            font-size: 21px;
            font-weight: bold;
        }


        .logo-icon {
            font-size: 26px;
        }


        .logo span {
            color: #2563eb;
        }


        .nav-links {
            display: flex;
            align-items: center;
            gap: 28px;
            list-style: none;
        }


        .nav-links a {
            color: white;
            text-decoration: none;
            font-size: 13px;
            transition: 0.2s;
        }


        .nav-links a:hover {
            color: #60a5fa;
        }


        .nav-links .active {
            color: #60a5fa;
            font-weight: bold;
        }


        /* ================= NAV BUTTONS ================= */

        .nav-buttons {
            display: flex;
            gap: 10px;
        }


        .login-btn {
            padding: 9px 18px;

            border: 1px solid white;
            border-radius: 6px;

            color: white;
            text-decoration: none;

            font-size: 12px;
        }


        .register-btn {
            padding: 9px 18px;

            background: #1765e8;
            color: white;

            border-radius: 6px;

            text-decoration: none;

            font-size: 12px;
            font-weight: bold;
        }


        .login-btn:hover {
            background: white;
            color: #06152b;
        }


        .register-btn:hover {
            background: #0d4bc0;
        }

        .username {
            color: #ffffff !important;
            text-decoration: none;
            font-size: 13px;
        }

        .logout-btn {
            padding: 9px 18px;
            border: 1px solid white;
            border-radius: 6px;
            color: white !important;
            text-decoration: none;
            font-size: 12px;
            transition: 0.2s;
        }

        .logout-btn:hover {
            background: white;
            color: #06152b !important;
        }


        /* ================= MAIN PAGE ================= */

        .page {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 35px 25px 60px;
        }


        /* ================= PAGE HEADER ================= */

        .page-header {
            display: flex;

            align-items: center;

            justify-content: space-between;

            margin-bottom: 25px;
        }


        .page-title h1 {
            font-size: 28px;

            color: #111827;

            margin-bottom: 6px;
        }


        .page-title p {
            color: #64748b;

            font-size: 13px;
        }


        /* ================= CREATE BUTTON ================= */

        .create-button {
            display: inline-flex;

            align-items: center;

            gap: 7px;

            padding: 11px 18px;

            background: #1765e8;

            color: white;

            border: none;

            border-radius: 7px;

            font-size: 12px;

            font-weight: bold;

            text-decoration: none;

            cursor: pointer;

            transition: 0.2s;
        }


        .create-button:hover {
            background: #0d4bc0;

            transform: translateY(-1px);
        }


        /* ================= SEARCH ================= */

        .search-area {
            display: flex;

            gap: 8px;

            margin-bottom: 25px;
        }


        .search-area input {
            flex: 1;

            height: 42px;

            padding: 0 14px;

            border: 1px solid #d6deea;

            border-radius: 7px;

            outline: none;

            font-size: 13px;

            background: white;
        }


        .search-area input:focus {
            border-color: #1765e8;

            box-shadow:
                0 0 0 3px rgba(23, 101, 232, 0.08);
        }


        .search-button {
            height: 42px;

            padding: 0 20px;

            border: none;

            border-radius: 7px;

            background: #1765e8;

            color: white;

            font-size: 12px;

            font-weight: bold;

            cursor: pointer;
        }


        .search-button:hover {
            background: #0d4bc0;
        }

        /* ================= FILTER BAR & CONTROLS ================= */

        .filter-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 22px;
            flex-wrap: wrap;
        }

        .filter-chips {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .filter-chip {
            padding: 7px 14px;
            border-radius: 20px;
            background: #e2e8f0;
            color: #334155;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            transition: 0.2s ease;
        }

        .filter-chip:hover {
            background: #cbd5e1;
        }

        .filter-chip.active {
            background: #1765e8;
            color: #ffffff;
        }

        .auction-count {
            font-size: 12px;
            color: #64748b;
            font-weight: 600;
        }

        /* ================= AUCTION GRID & CARDS ================= */

        .auction-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(285px, 1fr));
            gap: 22px;
            margin-bottom: 35px;
        }

        .auction-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            box-shadow: 0 2px 8px rgba(15, 23, 42, 0.04);
            transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
            position: relative;
        }

        .auction-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(15, 23, 42, 0.08);
            border-color: #cbd5e1;
        }

        .card-media {
            position: relative;
            width: 100%;
            height: 190px;
            background: #0b1c38;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .card-media img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .auction-card:hover .card-media img {
            transform: scale(1.04);
        }

        .card-media-fallback {
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: #94a3b8;
            background: linear-gradient(135deg, #0b1f3d 0%, #172a4e 100%);
        }

        .card-media-fallback span {
            font-size: 38px;
            margin-bottom: 4px;
        }

        .card-status-badge {
            position: absolute;
            top: 12px;
            left: 12px;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.25);
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .badge-active {
            background: #10b981;
            color: #ffffff;
        }

        .badge-upcoming {
            background: #f59e0b;
            color: #ffffff;
        }

        .badge-closed {
            background: #64748b;
            color: #ffffff;
        }

        .card-category-badge {
            position: absolute;
            top: 12px;
            right: 12px;
            background: rgba(15, 23, 42, 0.75);
            backdrop-filter: blur(4px);
            color: #f1f5f9;
            font-size: 11px;
            padding: 3px 9px;
            border-radius: 6px;
            font-weight: 500;
        }

        .card-body {
            padding: 18px 18px 14px;
            display: flex;
            flex-direction: column;
            flex: 1;
        }

        .card-title {
            font-size: 16px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 6px;
            line-height: 1.35;
            display: -webkit-box;
            -webkit-line-clamp: 1;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .card-desc {
            font-size: 12px;
            color: #64748b;
            line-height: 1.5;
            margin-bottom: 14px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            min-height: 36px;
        }

        .card-price-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            padding: 10px 12px;
            background: #f8fafc;
            border-radius: 8px;
            border: 1px solid #eef2f6;
            margin-bottom: 14px;
        }

        .price-col {
            display: flex;
            flex-direction: column;
        }

        .price-label {
            font-size: 10px;
            color: #94a3b8;
            text-transform: uppercase;
            font-weight: 700;
            letter-spacing: 0.5px;
            margin-bottom: 2px;
        }

        .price-value {
            font-size: 17px;
            font-weight: 800;
            color: #0f172a;
        }

        .price-value.highlight {
            color: #1765e8;
        }

        .card-timer-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 11px;
            color: #64748b;
            margin-bottom: 14px;
        }

        .timer-badge {
            font-weight: 600;
            color: #334155;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .card-actions {
            margin-top: auto;
            display: flex;
            gap: 8px;
        }

        .bid-btn {
            flex: 1;
            padding: 10px 14px;
            background: #1765e8;
            color: #ffffff;
            border: none;
            border-radius: 7px;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            transition: background 0.2s ease, transform 0.1s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .bid-btn:hover {
            background: #0d4bc0;
        }

        .bid-btn.disabled {
            background: #cbd5e1;
            color: #64748b;
            cursor: not-allowed;
            pointer-events: none;
        }

        /* ================= EMPTY STATE ================= */

        .empty-state {
            background: white;

            border: 1px solid #dfe5ec;

            border-radius: 10px;

            min-height: 380px;

            display: flex;

            flex-direction: column;

            justify-content: center;

            align-items: center;

            text-align: center;

            padding: 40px;
        }


        .empty-icon {
            width: 75px;
            height: 75px;

            border-radius: 50%;

            background: #edf4ff;

            display: flex;

            align-items: center;

            justify-content: center;

            color: #1765e8;

            font-size: 32px;

            margin-bottom: 20px;
        }


        .empty-state h2 {
            font-size: 21px;

            color: #111827;

            margin-bottom: 8px;
        }


        .empty-state p {
            max-width: 470px;

            color: #64748b;

            font-size: 13px;

            line-height: 1.6;

            margin-bottom: 22px;
        }


        /* ================= FEATURES ================= */

        .features {
            margin-top: 30px;

            background: white;

            border: 1px solid #dfe5ec;

            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            border-radius: 7px;

            overflow: hidden;
        }


        .feature {
            display: flex;

            align-items: center;

            gap: 12px;

            padding: 17px 25px;

            border-right: 1px solid #e5e7eb;
        }


        .feature:last-child {
            border-right: none;
        }


        .feature-icon {
            width: 35px;
            height: 35px;

            border-radius: 50%;

            background: #edf4ff;

            display: flex;

            align-items: center;

            justify-content: center;

            color: #1765e8;

            font-size: 16px;
        }


        .feature h4 {
            font-size: 11px;

            color: #334155;

            margin-bottom: 3px;
        }


        .feature p {
            font-size: 10px;

            color: #94a3b8;
        }


        /* ================= FOOTER ================= */

        footer {
            width: 100%;
            margin: 0;
            padding: 18px;
            background: #06152b;
            color: white;
            text-align: center;
            font-size: 11px;
            flex-shrink: 0;
        }


        /* ================= RESPONSIVE ================= */

        @media (max-width: 900px) {

            .nav-links {
                display: none;
            }

        }


        @media (max-width: 650px) {

            .navbar {
                padding: 15px;

                height: auto;
            }


            .page {
                padding: 25px 15px;
            }


            .page-header {
                flex-direction: column;

                align-items: flex-start;

                gap: 15px;
            }


            .create-button {
                width: 100%;

                justify-content: center;
            }


            .features {
                grid-template-columns: 1fr;
            }


            .feature {
                border-right: none;

                border-bottom: 1px solid #e5e7eb;
            }


            .feature:last-child {
                border-bottom: none;
            }

        }

    </style>

</head>


<body>


    <!-- ================= NAVIGATION ================= -->

    <%@include file="navbar.jsp" %>




    <!-- ================= MAIN ================= -->

    <main class="page">


        <!-- ================= HEADER ================= -->

        <div class="page-header">


            <div class="page-title">

                <h1>
                    Live Auctions
                </h1>

                <p>
                    Discover and bid on amazing products.
                </p>

            </div>


            <!-- OPENS SEPARATE PAGE -->

            <a
                href="create-auction.jsp"
                class="create-button"
            >

                + Create New Auction

            </a>


        </div>



        <!-- ================= SEARCH ================= -->

        <div class="search-area">


            <input
                type="text"
                id="searchInput"
                placeholder="Search items..."
                onkeyup="searchAuctions()"
            >


            <button
                class="search-button"
                onclick="searchAuctions()"
            >
                Search
            </button>

        </div>

        <!-- ================= FILTER & CONTROLS ================= -->

        <div class="filter-bar">
            <div class="filter-chips">
                <button class="filter-chip active" type="button" onclick="filterCategory('All')">All</button>
                <button class="filter-chip" type="button" onclick="filterCategory('Electronics')">Electronics</button>
                <button class="filter-chip" type="button" onclick="filterCategory('Fashion')">Fashion</button>
                <button class="filter-chip" type="button" onclick="filterCategory('Watches')">Watches</button>
                <button class="filter-chip" type="button" onclick="filterCategory('Art & Collectibles')">Art & Collectibles</button>
                <button class="filter-chip" type="button" onclick="filterCategory('Vehicles')">Vehicles</button>
                <button class="filter-chip" type="button" onclick="filterCategory('Home & Lifestyle')">Home & Lifestyle</button>
                <button class="filter-chip" type="button" onclick="filterCategory('Books')">Books</button>
                <button class="filter-chip" type="button" onclick="filterCategory('Other')"> Others</button>
            </div>
            <div id="auctionCount" class="auction-count">Loading auctions...</div>
        </div>

        <!-- ================= AUCTION GRID ================= -->

        <div id="auctionGrid" class="auction-grid" style="display: none;"></div>

        <!-- ================= EMPTY AUCTION AREA ================= -->

        <div id="emptyState" class="empty-state">


            <div class="empty-icon">
                🔨
            </div>


            <h2>
                No Auctions Available
            </h2>


            <p>
                There are currently no live auctions.
                Once sellers create auctions, their
                products will appear here for users
                to explore and bid on.
            </p>


            <a
                href="create-auction.jsp"
                class="create-button"
            >

                + Create Your First Auction

            </a>


        </div>



        <!-- ================= FEATURES ================= -->

        <div class="features">


            <!-- SAFE -->

            <div class="feature">


                <div class="feature-icon">
                    🛡
                </div>


                <div>

                    <h4>
                        Safe & Secure
                    </h4>

                    <p>
                        Your security is our priority.
                    </p>

                </div>


            </div>



            <!-- BEST DEALS -->

            <div class="feature">


                <div class="feature-icon">
                    🏆
                </div>


                <div>

                    <h4>
                        Best Deals
                    </h4>

                    <p>
                        Bid and win at the best prices.
                    </p>

                </div>


            </div>



            <!-- SUPPORT -->

            <div class="feature">


                <div class="feature-icon">
                    💬
                </div>


                <div>

                    <h4>
                        24/7 Support
                    </h4>

                    <p>
                        We are here to help you anytime.
                    </p>

                </div>


            </div>


        </div>


    </main>



    <!-- ================= FOOTER ================= -->

    <footer>

        © 2026 E-Auction System | All Rights Reserved

    </footer>



    <!-- ================= JAVASCRIPT ================= -->

    <script>
        let allAuctions = [];
        let selectedCategory = "All";

        async function fetchAuctions() {
            const countEl = document.getElementById("auctionCount");
            try {
                const response = await fetch("getAllAuctions");
                if (!response.ok) {
                    throw new Error("HTTP error " + response.status);
                }
                allAuctions = await response.json();
                renderAuctions();
            } catch (err) {
                console.error("Failed to load auctions:", err);
                if (countEl) {
                    countEl.textContent = "Unable to load live auctions";
                }
                showEmptyState(true);
            }
        }

        function filterCategory(category) {
            selectedCategory = category;
            const chips = document.querySelectorAll(".filter-chip");
            chips.forEach(chip => {
                if (chip.textContent.trim().toLowerCase() === category.toLowerCase()) {
                    chip.classList.add("active");
                } else {
                    chip.classList.remove("active");
                }
            });
            renderAuctions();
        }

        function searchAuctions() {
            renderAuctions();
        }

        function getCategoryIcon(category) {
            const map = {
                "Electronics": "💻",
                "Fashion": "👔",
                "Watches": "⌚",
                "Art & Collectibles": "🎨",
                "Vehicles": "🚗",
                "Home & Lifestyle": "🏠",
                "Books": "📚"
            };
            return map[category] || "📦";
        }

        function computeStatus(startTimeStr, endTimeStr) {
            const now = new Date().getTime();
            const start = startTimeStr ? new Date(startTimeStr.replace(" ", "T")).getTime() : 0;
            const end = endTimeStr ? new Date(endTimeStr.replace(" ", "T")).getTime() : 0;

            if (start && now < start) {
                return { key: "upcoming", label: "Upcoming", badgeClass: "badge-upcoming", isLive: false };
            }
            if (end && now > end) {
                return { key: "closed", label: "Closed", badgeClass: "badge-closed", isLive: false };
            }
            return { key: "active", label: "● Live", badgeClass: "badge-active", isLive: true };
        }

        function formatCountdown(endTimeStr) {
            if (!endTimeStr) return "Ongoing";
            const now = new Date().getTime();
            const end = new Date(endTimeStr.replace(" ", "T")).getTime();
            const diff = end - now;

            if (diff <= 0) return "Ended";

            const days = Math.floor(diff / (1000 * 60 * 60 * 24));
            const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const mins = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
            const secs = Math.floor((diff % (1000 * 60)) / 1000);

            if (days > 0) return days + "d " + hours + "h left";
            if (hours > 0) return hours + "h " + mins + "m left";
            return mins + "m " + secs + "s left";
        }

        function escapeHTML(str) {
            if (!str) return "";
            return str.replace(/[&<>'"]/g, 
                tag => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', "'": '&#39;', '"': '&quot;' }[tag] || tag)
            );
        }

        function createCardHTML(auction) {
            const statusInfo = computeStatus(auction.startTime, auction.endTime);
            const currentBid = (auction.highestBid && auction.highestBid > 0)
                ? auction.highestBid
                : auction.startingBid;
            const bidLabel = (auction.highestBid && auction.highestBid > 0)
                ? "Highest Bid"
                : "Starting Bid";

            const icon = getCategoryIcon(auction.category);
            const formattedPrice = "₹" + Number(currentBid || 0).toLocaleString("en-IN", {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            });

            const countdownText = formatCountdown(auction.endTime);

            const mediaHTML = auction.imageUrl && auction.imageUrl.trim() !== ""
                ? '<img src="' + escapeHTML(auction.imageUrl) + '" alt="' + escapeHTML(auction.name) + '" onerror="this.onerror=null; this.parentElement.innerHTML=\'<div class=\\\'card-media-fallback\\\'><span>' + icon + '</span><small>' + escapeHTML(auction.category || "Item") + '</small></div>\'">'
                : '<div class="card-media-fallback"><span>' + icon + '</span><small>' + escapeHTML(auction.category || "Item") + '</small></div>';

            const actionBtn = statusInfo.isLive
                ? '<a href="bid.jsp?auctionId=' + auction.auctionId + '" class="bid-btn">🔨 Place Bid</a>'
                : '<button class="bid-btn disabled" disabled>' + (statusInfo.key === "upcoming" ? "Starts Soon" : "Auction Ended") + '</button>';

            const cardCategory = escapeHTML(auction.category || "");
            const categoryBadge = escapeHTML(auction.category || "General");
            const auctionTitle = escapeHTML(auction.name || "");
            const auctionDesc = escapeHTML(auction.description || "No description provided.");
            const startPrice = Number(auction.startingBid || 0).toLocaleString("en-IN");
            const endTimeVal = escapeHTML(auction.endTime || "");

            return '<article class="auction-card" data-category="' + cardCategory + '">' +
                '<div class="card-media">' +
                    mediaHTML +
                    '<span class="card-status-badge ' + statusInfo.badgeClass + '">' +
                        statusInfo.label +
                    '</span>' +
                    '<span class="card-category-badge">' +
                        categoryBadge +
                    '</span>' +
                '</div>' +
                '<div class="card-body">' +
                    '<h3 class="card-title" title="' + auctionTitle + '">' +
                        auctionTitle +
                    '</h3>' +
                    '<p class="card-desc" title="' + auctionDesc + '">' +
                        auctionDesc +
                    '</p>' +
                    '<div class="card-price-row">' +
                        '<div class="price-col">' +
                            '<span class="price-label">' + bidLabel + '</span>' +
                            '<span class="price-value highlight">' + formattedPrice + '</span>' +
                        '</div>' +
                        '<div class="price-col" style="text-align: right;">' +
                            '<span class="price-label">Start Price</span>' +
                            '<span class="price-value" style="font-size: 13px; color: #64748b;">₹' + startPrice + '</span>' +
                        '</div>' +
                    '</div>' +
                    '<div class="card-timer-row">' +
                        '<span class="timer-badge">' +
                            '⏱ <span class="time-countdown" data-endtime="' + endTimeVal + '">' + countdownText + '</span>' +
                        '</span>' +
                        '<span style="font-size: 11px; color: #94a3b8;">' +
                            'ID: #' + auction.auctionId +
                        '</span>' +
                    '</div>' +
                    '<div class="card-actions">' +
                        actionBtn +
                    '</div>' +
                '</div>' +
            '</article>';
        }

        function showEmptyState(show) {
            const emptyEl = document.getElementById("emptyState");
            const gridEl = document.getElementById("auctionGrid");
            if (show) {
                if (emptyEl) emptyEl.style.display = "flex";
                if (gridEl) gridEl.style.display = "none";
            } else {
                if (emptyEl) emptyEl.style.display = "none";
                if (gridEl) gridEl.style.display = "grid";
            }
        }

        function renderAuctions() {
            const searchInput = document.getElementById("searchInput");
            const query = searchInput ? searchInput.value.trim().toLowerCase() : "";
            const gridEl = document.getElementById("auctionGrid");
            const countEl = document.getElementById("auctionCount");

            const filtered = allAuctions.filter(a => {
                const matchesSearch = !query || 
                    (a.name && a.name.toLowerCase().includes(query)) ||
                    (a.description && a.description.toLowerCase().includes(query)) ||
                    (a.category && a.category.toLowerCase().includes(query));

                const matchesCategory = selectedCategory === "All" ||
                    (a.category && a.category.toLowerCase() === selectedCategory.toLowerCase());

                return matchesSearch && matchesCategory;
            });

            if (countEl) {
                countEl.textContent = filtered.length === 1 
                    ? "1 auction available" 
                    : filtered.length + " auctions available";
            }

            if (filtered.length === 0) {
                showEmptyState(true);
            } else {
                showEmptyState(false);
                gridEl.innerHTML = filtered.map(createCardHTML).join("");
            }
        }

        // Live countdown timer ticking every second
        setInterval(() => {
            const timers = document.querySelectorAll(".time-countdown");
            timers.forEach(t => {
                const end = t.getAttribute("data-endtime");
                if (end) {
                    t.textContent = formatCountdown(end);
                }
            });
        }, 1000);

        // Fetch auctions when DOM is ready
        document.addEventListener("DOMContentLoaded", fetchAuctions);
    </script>


</body>

</html>
