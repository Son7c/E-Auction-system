<%@page contentType="text/html" pageEncoding="UTF-8" isELIgnored="true"%>
<%@page import="com.eauction.form.UserForm"%>
<%@page import="com.eauction.form.AuctionForm"%>
<%@page import="com.eauction.form.UserBidSummary"%>
<%@page import="com.eauction.service.AuctionService"%>
<%@page import="com.eauction.service.BidService"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    UserForm user = null;
    if (session != null && session.getAttribute("user") instanceof UserForm) {
        user = (UserForm) session.getAttribute("user");
    }
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    BidService bidService = new BidService();
    AuctionService auctionService = new AuctionService();

    List<UserBidSummary> userBids = bidService.getUserBiddingSummary(user.getUserId());
    List<AuctionForm> sellerListings = auctionService.getAuctionsBySellerId(user.getUserId());

    int winningCount = 0;
    int outbidCount = 0;
    int wonCount = 0;
    int totalBidsPlaced = 0;

    for (UserBidSummary b : userBids) {
        totalBidsPlaced += b.getUserBidCount();
        if (b.isClosed()) {
            if (b.isTopBidder()) wonCount++;
        } else if (b.isLive()) {
            if (b.isTopBidder()) winningCount++;
            else outbidCount++;
        }
    }

    long now = System.currentTimeMillis();
    int activeListingsCount = 0;
    for (AuctionForm a : sellerListings) {
        long start = a.getStartTime() != null ? a.getStartTime().getTime() : 0;
        long end = a.getEndTime() != null ? a.getEndTime().getTime() : Long.MAX_VALUE;
        if (now >= start && now <= end) {
            activeListingsCount++;
        }
    }

    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy 'at' hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>E-Auction | User Dashboard</title>

    <style>
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
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.12);
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

        .nav-links a:hover,
        .nav-links .active {
            color: #60a5fa;
        }

        .nav-buttons {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .dashboard-nav-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 14px;
            background: rgba(37, 99, 235, 0.2);
            color: #93c5fd !important;
            border: 1px solid #3b82f6;
            border-radius: 6px;
            text-decoration: none;
            font-size: 12px;
            font-weight: 700;
            transition: 0.2s;
        }

        .dashboard-nav-btn:hover {
            background: #1765e8;
            color: #ffffff !important;
        }

        .logout-btn {
            padding: 7px 14px;
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

        /* ================= PAGE CONTAINER ================= */
        .page {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 35px 25px 60px;
        }

        /* ================= PROFILE HEADER ================= */
        .profile-banner {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 28px 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 28px;
            box-shadow: 0 2px 10px rgba(15, 23, 42, 0.04);
            flex-wrap: wrap;
            gap: 20px;
        }

        .profile-user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .avatar-circle {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            background: linear-gradient(135deg, #1765e8 0%, #0d4bc0 100%);
            color: #ffffff;
            font-size: 26px;
            font-weight: 800;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 12px rgba(23, 101, 232, 0.25);
        }

        .profile-details h1 {
            font-size: 24px;
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 4px;
        }

        .profile-details p {
            font-size: 13px;
            color: #64748b;
        }

        .profile-actions {
            display: flex;
            gap: 10px;
        }

        .create-btn {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 11px 20px;
            background: #1765e8;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
            transition: 0.2s;
        }

        .create-btn:hover {
            background: #0d4bc0;
            transform: translateY(-1px);
        }

        /* ================= METRIC CARDS ================= */
        .metrics-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-bottom: 32px;
        }

        .metric-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 20px 22px;
            display: flex;
            align-items: center;
            gap: 16px;
            box-shadow: 0 2px 8px rgba(15, 23, 42, 0.04);
            transition: transform 0.2s;
        }

        .metric-card:hover {
            transform: translateY(-2px);
        }

        .metric-icon {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            flex-shrink: 0;
        }

        .icon-blue { background: #eff6ff; color: #1765e8; }
        .icon-green { background: #ecfdf5; color: #10b981; }
        .icon-gold { background: #fefce8; color: #ca8a04; }
        .icon-purple { background: #faf5ff; color: #9333ea; }

        .metric-content small {
            display: block;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
            font-weight: 700;
            margin-bottom: 2px;
        }

        .metric-content strong {
            font-size: 24px;
            font-weight: 800;
            color: #0f172a;
        }

        /* ================= TAB CONTROLS ================= */
        .tabs-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 1px;
            flex-wrap: wrap;
            gap: 12px;
        }

        .tab-buttons {
            display: flex;
            gap: 8px;
        }

        .tab-btn {
            padding: 12px 20px;
            background: transparent;
            border: none;
            border-bottom: 3px solid transparent;
            font-size: 14px;
            font-weight: 700;
            color: #64748b;
            cursor: pointer;
            transition: 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .tab-btn:hover {
            color: #0f172a;
        }

        .tab-btn.active {
            color: #1765e8;
            border-bottom-color: #1765e8;
        }

        .tab-count {
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 700;
            background: #e2e8f0;
            color: #334155;
        }

        .tab-btn.active .tab-count {
            background: #eff6ff;
            color: #1765e8;
        }

        /* ================= TABLE CARDS ================= */
        .table-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(15, 23, 42, 0.04);
        }

        .dashboard-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        .dashboard-table th {
            background: #f8fafc;
            padding: 14px 18px;
            text-align: left;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
            border-bottom: 1px solid #e2e8f0;
        }

        .dashboard-table td {
            padding: 16px 18px;
            border-bottom: 1px solid #f1f5f9;
            color: #334155;
            vertical-align: middle;
        }

        .dashboard-table tr:hover td {
            background: #fafcff;
        }

        .item-cell {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .item-thumb {
            width: 52px;
            height: 52px;
            border-radius: 8px;
            object-fit: cover;
            background: #0b1c38;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-size: 20px;
        }

        .item-cell-info h4 {
            font-size: 14px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 3px;
        }

        .item-cell-info small {
            font-size: 11px;
            color: #64748b;
        }

        /* ================= STATUS BADGES ================= */
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.3px;
        }

        .badge-winning {
            background: #ecfdf5;
            color: #059669;
            border: 1px solid #a7f3d0;
        }

        .badge-outbid {
            background: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }

        .badge-won {
            background: #fefce8;
            color: #ca8a04;
            border: 1px solid #fef08a;
        }

        .badge-lost {
            background: #f1f5f9;
            color: #64748b;
            border: 1px solid #e2e8f0;
        }

        .badge-live {
            background: #eff6ff;
            color: #1765e8;
            border: 1px solid #bfdbfe;
        }

        .badge-upcoming {
            background: #fffbeb;
            color: #d97706;
            border: 1px solid #fde68a;
        }

        .badge-closed {
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #cbd5e1;
        }

        .action-link {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 7px 14px;
            background: #1765e8;
            color: #ffffff;
            border-radius: 6px;
            text-decoration: none;
            font-size: 12px;
            font-weight: 700;
            transition: 0.2s;
        }

        .action-link:hover {
            background: #0d4bc0;
        }

        .action-link.secondary {
            background: #ffffff;
            color: #334155;
            border: 1px solid #cbd5e1;
        }

        .action-link.secondary:hover {
            background: #f1f5f9;
            color: #0f172a;
        }

        /* ================= EMPTY STATE ================= */
        .empty-box {
            text-align: center;
            padding: 50px 20px;
            color: #64748b;
        }

        .empty-box-icon {
            font-size: 42px;
            margin-bottom: 12px;
        }

        .empty-box h3 {
            font-size: 17px;
            color: #1e293b;
            margin-bottom: 6px;
        }

        .empty-box p {
            font-size: 13px;
            max-width: 400px;
            margin: 0 auto 18px;
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
            margin-top: 60px;
        }

        /* ================= RESPONSIVE ================= */
        @media (max-width: 900px) {
            .metrics-row {
                grid-template-columns: repeat(2, 1fr);
            }
            .nav-links {
                display: none;
            }
        }

        @media (max-width: 600px) {
            .metrics-row {
                grid-template-columns: 1fr;
            }
            .profile-banner {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>

    <!-- ================= NAVIGATION ================= -->
    <%@include file="navbar.jsp" %>

    <!-- ================= MAIN ================= -->
    <main class="page">

        <!-- PROFILE BANNER -->
        <div class="profile-banner">
            <div class="profile-user-info">
                <div class="avatar-circle">
                    <%= user.getName() != null && !user.getName().isEmpty() ? user.getName().substring(0, 1).toUpperCase() : "U" %>
                </div>
                <div class="profile-details">
                    <h1>Welcome back, <%= user.getName() %>!</h1>
                    <p>📧 <%= user.getEmail() %> &nbsp;•&nbsp; 🏷️ User ID: #<%= user.getUserId() %></p>
                </div>
            </div>
            <div class="profile-actions">
                <a href="create-auction.jsp" class="create-btn">
                    + Create New Auction
                </a>
            </div>
        </div>

        <!-- METRIC CARDS -->
        <div class="metrics-row">
            <div class="metric-card">
                <div class="metric-icon icon-blue">🔨</div>
                <div class="metric-content">
                    <small>Total Bids Placed</small>
                    <strong><%= totalBidsPlaced %></strong>
                </div>
            </div>

            <div class="metric-card">
                <div class="metric-icon icon-green">🟢</div>
                <div class="metric-content">
                    <small>Currently Winning</small>
                    <strong><%= winningCount %></strong>
                </div>
            </div>

            <div class="metric-card">
                <div class="metric-icon icon-gold">🏆</div>
                <div class="metric-content">
                    <small>Auctions Won</small>
                    <strong><%= wonCount %></strong>
                </div>
            </div>

            <div class="metric-card">
                <div class="metric-icon icon-purple">📦</div>
                <div class="metric-content">
                    <small>My Active Listings</small>
                    <strong><%= activeListingsCount %></strong>
                </div>
            </div>
        </div>

        <!-- TABS HEADER -->
        <div class="tabs-header">
            <div class="tab-buttons">
                <button class="tab-btn active" id="bidsTabBtn" onclick="switchTab('bids')">
                    🔨 My Bids & Activity <span class="tab-count"><%= userBids.size() %></span>
                </button>
                <button class="tab-btn" id="listingsTabBtn" onclick="switchTab('listings')">
                    📦 My Created Listings <span class="tab-count"><%= sellerListings.size() %></span>
                </button>
            </div>
        </div>

        <!-- TAB 1: MY BIDS CONTENT -->
        <div id="bidsSection" class="table-card">
            <% if (userBids.isEmpty()) { %>
                <div class="empty-box">
                    <div class="empty-box-icon">🔨</div>
                    <h3>No Bids Placed Yet</h3>
                    <p>Explore our catalog of live auctions to place bids and start winning products today.</p>
                    <a href="bidding.jsp" class="create-btn" style="display: inline-flex;">Browse Live Auctions →</a>
                </div>
            <% } else { %>
                <table class="dashboard-table">
                    <thead>
                        <tr>
                            <th>Item Details</th>
                            <th>Status</th>
                            <th>Your Highest Bid</th>
                            <th>Current Top Bid</th>
                            <th>Auction End Date</th>
                            <th style="text-align: right;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (UserBidSummary b : userBids) { %>
                            <tr>
                                <td>
                                    <div class="item-cell">
                                        <% if (b.getImageUrl() != null && !b.getImageUrl().trim().isEmpty()) { %>
                                            <img src="<%= b.getImageUrl() %>" alt="<%= b.getName() %>" class="item-thumb"
                                                 onerror="this.onerror=null; this.parentElement.innerHTML='<div class=\'item-thumb\'>📦</div>';">
                                        <% } else { %>
                                            <div class="item-thumb">📦</div>
                                        <% } %>
                                        <div class="item-cell-info">
                                            <h4><%= b.getName() %></h4>
                                            <small><%= b.getCategory() != null ? b.getCategory() : "General" %> • ID #<%= b.getAuctionId() %></small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge <%= b.getBadgeClass() %>">
                                        <%= b.getBadgeLabel() %>
                                    </span>
                                </td>
                                <td>
                                    <strong style="color: #0f172a; font-size: 14px;">₹<%= String.format("%,.2f", b.getUserHighestBid()) %></strong>
                                    <small style="display: block; color: #94a3b8; font-size: 11px;"><%= b.getUserBidCount() %> <%= b.getUserBidCount() == 1 ? "bid" : "bids" %> placed</small>
                                </td>
                                <td>
                                    <strong style="color: #1765e8; font-size: 14px;">₹<%= String.format("%,.2f", b.getCurrentHighestBid()) %></strong>
                                </td>
                                <td style="color: #64748b; font-size: 12px;">
                                    <%= b.getEndTime() != null ? sdf.format(b.getEndTime()) : "Open Ended" %>
                                </td>
                                <td style="text-align: right;">
                                    <% if (b.isLive()) { %>
                                        <a href="bid.jsp?auctionId=<%= b.getAuctionId() %>" class="action-link">
                                            <%= !b.isTopBidder() ? "Increase Bid ⚡" : "View Auction →" %>
                                        </a>
                                    <% } else { %>
                                        <% if (b.isTopBidder()) { %>
                                            <a href="certificate?auctionId=<%= b.getAuctionId() %>" class="action-link" style="background: #10b981; border-color: #10b981; color: white;">
                                                Certificate
                                            </a>
                                        <% } else { %>
                                            <a href="bid.jsp?auctionId=<%= b.getAuctionId() %>" class="action-link secondary">
                                                View Result →
                                            </a>
                                        <% } %>
                                    <% } %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>

        <!-- TAB 2: MY CREATED LISTINGS CONTENT -->
        <div id="listingsSection" class="table-card" style="display: none;">
            <% if (sellerListings.isEmpty()) { %>
                <div class="empty-box">
                    <div class="empty-box-icon">📦</div>
                    <h3>No Listings Created Yet</h3>
                    <p>You haven't listed any items for auction. Put your products up for live bidding!</p>
                    <a href="create-auction.jsp" class="create-btn" style="display: inline-flex;">+ Create First Auction</a>
                </div>
            <% } else { %>
                <table class="dashboard-table">
                    <thead>
                        <tr>
                            <th>Item Details</th>
                            <th>Status</th>
                            <th>Starting Price</th>
                            <th>Current Top Bid</th>
                            <th>Total Bids</th>
                            <th>Ends On</th>
                            <th style="text-align: right;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (AuctionForm a : sellerListings) {
                               long aStart = a.getStartTime() != null ? a.getStartTime().getTime() : 0;
                               long aEnd = a.getEndTime() != null ? a.getEndTime().getTime() : Long.MAX_VALUE;
                               boolean aLive = (now >= aStart && now <= aEnd);
                               boolean aUpcoming = (now < aStart);
                               boolean aClosed = (now > aEnd);
                        %>
                            <tr>
                                <td>
                                    <div class="item-cell">
                                        <% if (a.getImageUrl() != null && !a.getImageUrl().trim().isEmpty()) { %>
                                            <img src="<%= a.getImageUrl() %>" alt="<%= a.getName() %>" class="item-thumb"
                                                 onerror="this.onerror=null; this.parentElement.innerHTML='<div class=\'item-thumb\'>📦</div>';">
                                        <% } else { %>
                                            <div class="item-thumb">📦</div>
                                        <% } %>
                                        <div class="item-cell-info">
                                            <h4><%= a.getName() %></h4>
                                            <small><%= a.getCategory() != null ? a.getCategory() : "General" %> • ID #<%= a.getAuctionId() %></small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <% if (aLive) { %>
                                        <span class="badge badge-live">● Live</span>
                                    <% } else if (aUpcoming) { %>
                                        <span class="badge badge-upcoming">⏱ Upcoming</span>
                                    <% } else { %>
                                        <span class="badge badge-closed">Closed</span>
                                    <% } %>
                                </td>
                                <td>
                                    ₹<%= String.format("%,.2f", a.getStartingBid()) %>
                                </td>
                                <td>
                                    <strong style="color: #1765e8;">₹<%= String.format("%,.2f", a.getHighestBid()) %></strong>
                                </td>
                                <td>
                                    <span style="font-weight: 700;"><%= a.getBidCount() %></span> <%= a.getBidCount() == 1 ? "bid" : "bids" %>
                                </td>
                                <td style="color: #64748b; font-size: 12px;">
                                    <%= a.getEndTime() != null ? sdf.format(a.getEndTime()) : "Open Ended" %>
                                </td>
                                <td style="text-align: right;">
                                    <% 
                                        long sellerNow = System.currentTimeMillis();
                                        boolean isSellerClosed = (a.getEndTime() != null && sellerNow >= a.getEndTime().getTime()) || "COMPLETED".equalsIgnoreCase(a.getStatus());
                                        if (isSellerClosed && a.getBidCount() > 0) { 
                                    %>
                                        <a href="certificate?auctionId=<%= a.getAuctionId() %>" class="action-link" style="background: #0f172a; border-color: #0f172a; color: white; margin-right: 6px;">
                                            Sale Record
                                        </a>
                                    <% } %>
                                    <a href="bid.jsp?auctionId=<%= a.getAuctionId() %>" class="action-link secondary">
                                        View Details →
                                    </a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>

    </main>

    <!-- ================= FOOTER ================= -->
    <footer>
        © 2026 E-Auction System | All Rights Reserved
    </footer>

    <!-- ================= JAVASCRIPT ================= -->
    <script>
        function switchTab(tab) {
            const bidsBtn = document.getElementById("bidsTabBtn");
            const listingsBtn = document.getElementById("listingsTabBtn");
            const bidsSec = document.getElementById("bidsSection");
            const listingsSec = document.getElementById("listingsSection");

            if (tab === "bids") {
                bidsBtn.classList.add("active");
                listingsBtn.classList.remove("active");
                bidsSec.style.display = "block";
                listingsSec.style.display = "none";
            } else {
                listingsBtn.classList.add("active");
                bidsBtn.classList.remove("active");
                listingsSec.style.display = "block";
                bidsSec.style.display = "none";
            }
        }
    </script>
</body>
</html>
