<%@page contentType="text/html" pageEncoding="UTF-8" isELIgnored="true"%>
<%@page import="com.eauction.form.UserForm"%>
<%@page import="com.eauction.form.AuctionForm"%>
<%@page import="com.eauction.form.BidForm"%>
<%@page import="com.eauction.service.AuctionService"%>
<%@page import="com.eauction.service.BidService"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    String auctionIdParam = request.getParameter("auctionId");
    if (auctionIdParam == null || auctionIdParam.trim().isEmpty()) {
        response.sendRedirect("bidding.jsp");
        return;
    }

    int auctionId = 0;
    try {
        auctionId = Integer.parseInt(auctionIdParam.trim());
    } catch (NumberFormatException e) {
        response.sendRedirect("bidding.jsp");
        return;
    }

    AuctionService auctionService = new AuctionService();
    AuctionForm auction = auctionService.getAuctionById(auctionId);
    if (auction == null) {
        response.sendRedirect("bidding.jsp");
        return;
    }

    BidService bidService = new BidService();
    List<BidForm> bidHistory = bidService.getBidsForAuction(auctionId);

    UserForm loggedInUser = null;
    if (session != null && session.getAttribute("user") instanceof UserForm) {
        loggedInUser = (UserForm) session.getAttribute("user");
    }

    long now = System.currentTimeMillis();
    long startTime = auction.getStartTime() != null ? auction.getStartTime().getTime() : 0;
    long endTime = auction.getEndTime() != null ? auction.getEndTime().getTime() : Long.MAX_VALUE;

    boolean isUpcoming = now < startTime;
    boolean isClosed = now > endTime;
    boolean isLive = !isUpcoming && !isClosed;

    boolean isSeller = loggedInUser != null && loggedInUser.getUserId() == auction.getSellerId();

    double currentPrice = (auction.getHighestBid() > 0) ? auction.getHighestBid() : auction.getStartingBid();
    double minNextBid = (auction.getHighestBid() > 0) ? (auction.getHighestBid() + 1.0) : auction.getStartingBid();

    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy 'at' hh:mm a");
    String startTimeFormatted = auction.getStartTime() != null ? sdf.format(auction.getStartTime()) : "Immediate";
    String endTimeFormatted = auction.getEndTime() != null ? sdf.format(auction.getEndTime()) : "Open Ended";

    String errorParam = request.getParameter("error");
    boolean hasSuccess = "true".equals(request.getParameter("success"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>E-Auction | <%= auction.getName() != null ? auction.getName() : "Item Details" %></title>

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

        /* ================= NAVBAR OVERRIDES ================= */
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
            gap: 10px;
        }

        .login-btn,
        .logout-btn {
            padding: 9px 18px;
            border: 1px solid white;
            border-radius: 6px;
            color: white !important;
            text-decoration: none;
            font-size: 12px;
            transition: 0.2s;
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

        .login-btn:hover,
        .logout-btn:hover {
            background: white;
            color: #06152b !important;
        }

        .username {
            color: #ffffff !important;
            text-decoration: none;
            font-size: 13px;
            display: flex;
            align-items: center;
        }

        /* ================= MAIN WRAPPER ================= */
        .page {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 28px 25px 60px;
        }

        /* ================= BREADCRUMBS & TOP BAR ================= */
        .breadcrumb-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
            font-size: 13px;
            color: #64748b;
        }

        .breadcrumb-path {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .breadcrumb-path a {
            color: #64748b;
            text-decoration: none;
            transition: color 0.2s;
        }

        .breadcrumb-path a:hover {
            color: #1765e8;
        }

        .breadcrumb-path .current {
            color: #0f172a;
            font-weight: 600;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 14px;
            background: #ffffff;
            color: #334155;
            border: 1px solid #e2e8f0;
            border-radius: 7px;
            text-decoration: none;
            font-size: 12px;
            font-weight: 600;
            transition: 0.2s;
        }

        .back-btn:hover {
            background: #f1f5f9;
            color: #0f172a;
            border-color: #cbd5e1;
        }

        /* ================= 2-COLUMN GRID ================= */
        .auction-detail-grid {
            display: grid;
            grid-template-columns: 1.15fr 0.85fr;
            gap: 30px;
            align-items: start;
        }

        /* ================= LEFT COLUMN ================= */
        .media-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(15, 23, 42, 0.04);
            margin-bottom: 24px;
        }

        .media-container {
            position: relative;
            width: 100%;
            height: 420px;
            background: #0b1c38;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .media-container img {
            width: 100%;
            height: 100%;
            object-fit: contain;
            background: #08162d;
        }

        .media-fallback {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: #94a3b8;
            font-size: 54px;
        }

        .media-fallback span {
            font-size: 14px;
            margin-top: 10px;
            color: #cbd5e1;
        }

        .status-pill {
            position: absolute;
            top: 16px;
            left: 16px;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.25);
            display: inline-flex;
            align-items: center;
            gap: 6px;
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

        .category-pill {
            position: absolute;
            top: 16px;
            right: 16px;
            background: rgba(15, 23, 42, 0.78);
            backdrop-filter: blur(6px);
            color: #f8fafc;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .item-info-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 28px;
            box-shadow: 0 2px 10px rgba(15, 23, 42, 0.04);
            margin-bottom: 24px;
        }

        .item-header {
            margin-bottom: 18px;
            border-bottom: 1px solid #f1f5f9;
            padding-bottom: 18px;
        }

        .item-title {
            font-size: 26px;
            font-weight: 800;
            color: #0f172a;
            line-height: 1.3;
            margin-bottom: 8px;
        }

        .item-meta {
            display: flex;
            align-items: center;
            gap: 16px;
            font-size: 12px;
            color: #64748b;
        }

        .item-meta span {
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .item-desc-title {
            font-size: 14px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .item-description {
            font-size: 14px;
            color: #475569;
            line-height: 1.7;
            white-space: pre-line;
            margin-bottom: 22px;
        }

        .timeline-box {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            padding: 16px 18px;
            background: #f8fafc;
            border-radius: 10px;
            border: 1px solid #eef2f6;
        }

        .timeline-col small {
            display: block;
            font-size: 11px;
            color: #94a3b8;
            font-weight: 700;
            text-transform: uppercase;
            margin-bottom: 4px;
        }

        .timeline-col strong {
            font-size: 13px;
            color: #1e293b;
        }

        /* ================= RIGHT COLUMN (BIDDING CONSOLE) ================= */
        .bidding-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 26px;
            box-shadow: 0 4px 16px rgba(15, 23, 42, 0.06);
            margin-bottom: 24px;
        }

        .countdown-box {
            background: linear-gradient(135deg, #0b1f3d 0%, #172a4e 100%);
            color: #ffffff;
            border-radius: 10px;
            padding: 18px 20px;
            text-align: center;
            margin-bottom: 22px;
        }

        .countdown-label {
            font-size: 11px;
            letter-spacing: 1px;
            text-transform: uppercase;
            color: #93c5fd;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .countdown-timer {
            font-size: 26px;
            font-weight: 800;
            font-family: monospace;
            letter-spacing: 2px;
            color: #ffffff;
        }

        .pricing-summary {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 18px 20px;
            margin-bottom: 22px;
        }

        .price-label {
            font-size: 11px;
            text-transform: uppercase;
            color: #64748b;
            font-weight: 700;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }

        .current-price {
            font-size: 32px;
            font-weight: 800;
            color: #1765e8;
            line-height: 1.1;
            margin-bottom: 12px;
        }

        .sub-pricing {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
            color: #64748b;
            padding-top: 10px;
            border-top: 1px solid #eef2f6;
        }

        .sub-pricing strong {
            color: #0f172a;
        }

        /* ================= ALERTS ================= */
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .alert-success {
            background: #ecfdf5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }

        .alert-error {
            background: #fef2f2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        .alert-info {
            background: #eff6ff;
            color: #1e40af;
            border: 1px solid #bfdbfe;
        }

        /* ================= BID FORM ================= */
        .bid-form {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .form-label {
            font-size: 12px;
            font-weight: 700;
            color: #334155;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .input-group {
            position: relative;
            display: flex;
            align-items: center;
        }

        .currency-symbol {
            position: absolute;
            left: 16px;
            font-size: 18px;
            font-weight: 700;
            color: #64748b;
            pointer-events: none;
        }

        .bid-input {
            width: 100%;
            height: 52px;
            padding-left: 36px;
            padding-right: 16px;
            font-size: 18px;
            font-weight: 700;
            color: #0f172a;
            border: 2px solid #cbd5e1;
            border-radius: 9px;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .bid-input:focus {
            border-color: #1765e8;
            box-shadow: 0 0 0 4px rgba(23, 101, 232, 0.12);
        }

        .quick-chips {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .quick-chip {
            padding: 6px 12px;
            background: #edf4ff;
            color: #1765e8;
            border: 1px solid #bfdbfe;
            border-radius: 6px;
            font-size: 11px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.15s;
        }

        .quick-chip:hover {
            background: #1765e8;
            color: #ffffff;
            border-color: #1765e8;
        }

        .place-bid-btn {
            width: 100%;
            height: 52px;
            background: #1765e8;
            color: #ffffff;
            border: none;
            border-radius: 9px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s, transform 0.1s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .place-bid-btn:hover {
            background: #0d4bc0;
            transform: translateY(-1px);
        }

        .place-bid-btn:active {
            transform: translateY(0);
        }

        .auth-prompt-btn {
            width: 100%;
            height: 50px;
            background: #1765e8;
            color: white;
            border-radius: 9px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: 0.2s;
        }

        .auth-prompt-btn:hover {
            background: #0d4bc0;
        }

        /* ================= BID HISTORY CARD ================= */
        .history-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 24px;
            box-shadow: 0 2px 10px rgba(15, 23, 42, 0.04);
        }

        .history-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
            border-bottom: 1px solid #f1f5f9;
            padding-bottom: 12px;
        }

        .history-title {
            font-size: 16px;
            font-weight: 700;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .history-badge {
            background: #edf4ff;
            color: #1765e8;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 8px;
            border-radius: 12px;
        }

        .history-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        .history-table th {
            text-align: left;
            padding: 10px 12px;
            color: #64748b;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            border-bottom: 1px solid #e2e8f0;
        }

        .history-table td {
            padding: 12px;
            border-bottom: 1px solid #f1f5f9;
            color: #334155;
        }

        .history-table tr:first-child td {
            background: #f0fdf4;
            font-weight: 700;
            color: #166534;
        }

        .history-table tr:first-child td .crown-icon {
            display: inline-block;
            margin-right: 4px;
        }

        .empty-history {
            text-align: center;
            padding: 30px 15px;
            color: #94a3b8;
            font-size: 13px;
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
            margin-top: 50px;
        }

        /* ================= RESPONSIVE ================= */
        @media (max-width: 900px) {
            .auction-detail-grid {
                grid-template-columns: 1fr;
            }
            .bidding-card {
                position: static;
            }
            .nav-links {
                display: none;
            }
        }
    </style>
</head>
<body>

    <!-- ================= NAVIGATION ================= -->
    <%@include file="navbar.jsp" %>

    <!-- ================= MAIN CONTAINER ================= -->
    <main class="page">

        <!-- BREADCRUMB BAR -->
        <div class="breadcrumb-bar">
            <div class="breadcrumb-path">
                <a href="homepage.jsp">Home</a>
                <span>/</span>
                <a href="bidding.jsp">Auctions</a>
                <span>/</span>
                <span class="current"><%= auction.getName() != null ? auction.getName() : "Item Details" %></span>
            </div>
            <a href="bidding.jsp" class="back-btn">
                ← Back to Live Auctions
            </a>
        </div>

        <!-- 2-COLUMN DETAIL GRID -->
        <div class="auction-detail-grid">

            <!-- LEFT COLUMN: PRODUCT MEDIA & DETAILS -->
            <div class="left-col">

                <!-- MEDIA CARD -->
                <div class="media-card">
                    <div class="media-container">
                        <% if (auction.getImageUrl() != null && !auction.getImageUrl().trim().isEmpty()) { %>
                            <img src="<%= auction.getImageUrl() %>" alt="<%= auction.getName() %>"
                                 onerror="this.onerror=null; this.parentElement.innerHTML='<div class=\'media-fallback\'>📦<span><%= auction.getCategory() != null ? auction.getCategory() : "Item" %></span></div>';">
                        <% } else { %>
                            <div class="media-fallback">
                                📦
                                <span><%= auction.getCategory() != null ? auction.getCategory() : "Item" %></span>
                            </div>
                        <% } %>

                        <!-- STATUS PILL -->
                        <% if (isLive) { %>
                            <span class="status-pill badge-active">● Live Auction</span>
                        <% } else if (isUpcoming) { %>
                            <span class="status-pill badge-upcoming">⏱ Starts Soon</span>
                        <% } else { %>
                            <span class="status-pill badge-closed">Auction Closed</span>
                        <% } %>

                        <!-- CATEGORY PILL -->
                        <span class="category-pill">
                            <%= auction.getCategory() != null ? auction.getCategory() : "General" %>
                        </span>
                    </div>
                </div>

                <!-- ITEM INFORMATION CARD -->
                <div class="item-info-card">
                    <div class="item-header">
                        <h1 class="item-title"><%= auction.getName() %></h1>
                        <div class="item-meta">
                            <span>🏷️ ID: #<%= auction.getAuctionId() %></span>
                            <span>📁 Category: <%= auction.getCategory() != null ? auction.getCategory() : "General" %></span>
                            <span>👤 Seller: <%= (auction.getSellerName() != null && !auction.getSellerName().trim().isEmpty()) ? auction.getSellerName() : ("Seller #" + auction.getSellerId()) %></span>
                        </div>
                    </div>

                    <div class="item-desc-title">Description</div>
                    <p class="item-description">
                        <%= (auction.getDescription() != null && !auction.getDescription().trim().isEmpty())
                            ? auction.getDescription()
                            : "No description provided by the seller." %>
                    </p>

                    <!-- TIMELINE BOX -->
                    <div class="timeline-box">
                        <div class="timeline-col">
                            <small>Auction Start Time</small>
                            <strong><%= startTimeFormatted %></strong>
                        </div>
                        <div class="timeline-col">
                            <small>Auction End Time</small>
                            <strong><%= endTimeFormatted %></strong>
                        </div>
                    </div>
                </div>

            </div>

            <!-- RIGHT COLUMN: BIDDING CONSOLE & HISTORY -->
            <div class="right-col">

                <!-- BIDDING CARD -->
                <div class="bidding-card">

                    <!-- COUNTDOWN TIMER -->
                    <div class="countdown-box">
                        <div class="countdown-label">
                            <%= isLive ? "Time Remaining" : (isUpcoming ? "Starts In" : "Auction Status") %>
                        </div>
                        <div class="countdown-timer" id="countdownTimer" data-endtime="<%= auction.getEndTime() != null ? auction.getEndTime().toString() : "" %>" data-starttime="<%= auction.getStartTime() != null ? auction.getStartTime().toString() : "" %>">
                            <%= isClosed ? "AUCTION ENDED" : "Calculating..." %>
                        </div>
                    </div>

                    <!-- PRICING SUMMARY -->
                    <div class="pricing-summary">
                        <div class="price-label">
                            <%= isClosed ? "Final Closing Price" : ((auction.getHighestBid() > 0) ? "Current Highest Bid" : "Starting Price") %>
                        </div>
                        <div class="current-price">
                            ₹<%= String.format("%,.2f", currentPrice) %>
                        </div>
                        <div class="sub-pricing">
                            <span>Start Price: <strong>₹<%= String.format("%,.2f", auction.getStartingBid()) %></strong></span>
                            <span>Total Bids: <strong><%= bidHistory.size() %></strong></span>
                        </div>
                    </div>

                    <!-- NOTIFICATIONS / ALERTS -->
                    <% if (hasSuccess) { %>
                        <div class="alert alert-success">
                            🎉 Your bid was placed successfully! You are now the leading bidder.
                        </div>
                    <% } %>

                    <% if (errorParam != null && !errorParam.trim().isEmpty()) { %>
                        <div class="alert alert-error">
                            ⚠️ <%= errorParam %>
                        </div>
                    <% } %>

                    <% if (isSeller) { %>
                        <div class="alert alert-info">
                            ℹ️ You are the seller of this auction. Sellers cannot bid on their own listings.
                        </div>
                    <% } %>

                    <!-- BID PLACEMENT FORM / GUEST ACTIONS -->
                    <% if (isClosed) { %>
                        <div class="alert alert-error">
                            🔒 This auction has officially closed. No further bids can be accepted.
                        </div>
                        <% if (!bidHistory.isEmpty()) { 
                               BidForm winner = bidHistory.get(0);
                               String winnerName = (winner.getBidderName() != null && !winner.getBidderName().trim().isEmpty())
                                   ? winner.getBidderName()
                                   : ("Bidder #" + winner.getBidderId());
                               boolean isWinnerUser = loggedInUser != null && loggedInUser.getUserId() == winner.getBidderId();
                        %>
                            <div style="background: <%= isWinnerUser ? "#ecfdf5" : "#f8fafc" %>; border: 2px solid <%= isWinnerUser ? "#10b981" : "#cbd5e1" %>; border-radius: 10px; padding: 18px 20px; text-align: center; margin-bottom: 14px;">
                                <div style="font-size: 32px; margin-bottom: 6px;"><%= isWinnerUser ? "🎉 🏆" : "🏆" %></div>
                                <div style="font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: <%= isWinnerUser ? "#059669" : "#64748b" %>; margin-bottom: 4px;">
                                    <%= isWinnerUser ? "Winning Confirmation" : "Official Auction Winner" %>
                                </div>
                                <div style="font-size: 20px; font-weight: 800; color: <%= isWinnerUser ? "#065f46" : "#0f172a" %>; margin-bottom: 8px;">
                                    <%= isWinnerUser ? "You Won This Auction!" : winnerName %>
                                </div>
                                <div style="font-size: 13px; color: #475569;">
                                    Final Winning Bid: <strong style="color: #1765e8; font-size: 16px;">₹<%= String.format("%,.2f", winner.getBidAmount()) %></strong>
                                </div>
                                <% if (isWinnerUser) { %>
                                    <div style="margin-top: 12px;">
                                        <a href="certificate?auctionId=<%= auctionId %>" class="auth-prompt-btn" style="background: #10b981; color: #fff; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; gap: 8px; font-weight: 700; width: 100%; box-sizing: border-box; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.25);">
                                            View Certificate
                                        </a>
                                    </div>
                                <% } else if (isSeller) { %>
                                    <div style="margin-top: 12px;">
                                        <a href="certificate?auctionId=<%= auctionId %>" class="auth-prompt-btn" style="background: #0f172a; color: #fff; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; gap: 8px; font-weight: 700; width: 100%; box-sizing: border-box;">
                                            View Sale Record
                                        </a>
                                    </div>
                                <% } %>
                            </div>
                        <% } else { %>
                            <div class="alert alert-info">
                                ℹ️ This auction closed with no bids placed.
                            </div>
                        <% } %>
                    <% } else if (isUpcoming) { %>
                        <div class="alert alert-info">
                            This auction has not started yet. Bidding will open on <%= startTimeFormatted %>.
                        </div>
                    <% } else if (loggedInUser == null) { %>
                        <div style="text-align: center; margin-top: 10px;">
                            <p style="font-size: 13px; color: #64748b; margin-bottom: 14px;">
                                You must be signed in to your account to place a bid on this item.
                            </p>
                            <a href="login.jsp" class="auth-prompt-btn">
                                🔐 Login to Place Bid
                            </a>
                        </div>
                    <% } else if (isSeller) { %>
                        <button class="place-bid-btn" disabled style="background: #cbd5e1; cursor: not-allowed;">
                            Seller Bidding Disabled
                        </button>
                    <% } else { %>
                        <form action="placeBid" method="post" class="bid-form" onsubmit="return validateBidInput();">
                            <input type="hidden" name="auctionId" value="<%= auction.getAuctionId() %>">

                            <label class="form-label" for="bidAmountInput">
                                Enter Your Bid (Minimum: ₹<%= String.format("%,.2f", minNextBid) %>)
                            </label>

                            <div class="input-group">
                                <span class="currency-symbol">₹</span>
                                <input type="number"
                                       id="bidAmountInput"
                                       name="bidAmount"
                                       class="bid-input"
                                       step="any"
                                       min="<%= minNextBid %>"
                                       value="<%= String.format("%.2f", minNextBid) %>"
                                       required
                                       autofocus>
                            </div>

                            <!-- QUICK INCREMENT BUTTONS -->
                            <div class="quick-chips">
                                <button type="button" class="quick-chip" onclick="addBidIncrement(100)">+₹100</button>
                                <button type="button" class="quick-chip" onclick="addBidIncrement(500)">+₹500</button>
                                <button type="button" class="quick-chip" onclick="addBidIncrement(1000)">+₹1,000</button>
                                <button type="button" class="quick-chip" onclick="addBidIncrement(5000)">+₹5,000</button>
                            </div>

                            <button type="submit" class="place-bid-btn">
                                🔨 Confirm & Place Bid
                            </button>
                        </form>
                    <% } %>

                </div>

                <!-- BID HISTORY CARD -->
                <div class="history-card">
                    <div class="history-header">
                        <div class="history-title">
                            📜 Bid History
                        </div>
                        <span class="history-badge"><%= bidHistory.size() %> <%= bidHistory.size() == 1 ? "Bid" : "Bids" %></span>
                    </div>

                    <% if (bidHistory.isEmpty()) { %>
                        <div class="empty-history">
                            🔨 No bids placed yet.<br>Be the first bidder to take the lead!
                        </div>
                    <% } else { %>
                        <table class="history-table">
                            <thead>
                                <tr>
                                    <th>Bidder</th>
                                    <th>Amount</th>
                                    <th style="text-align: right;">Time</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (int i = 0; i < bidHistory.size(); i++) {
                                       BidForm b = bidHistory.get(i);
                                       String timeText = b.getBidTime() != null ? sdf.format(b.getBidTime()) : "";
                                %>
                                    <tr>
                                        <td>
                                            <% if (i == 0) { %>
                                                <span class="crown-icon">👑</span>
                                            <% } %>
                                            <%= (b.getBidderName() != null && !b.getBidderName().trim().isEmpty())
                                                ? b.getBidderName()
                                                : ("Bidder #" + b.getBidderId()) %>
                                        </td>
                                        <td>
                                            <strong>₹<%= String.format("%,.2f", b.getBidAmount()) %></strong>
                                        </td>
                                        <td style="text-align: right; color: #94a3b8; font-size: 11px;">
                                            <%= timeText %>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } %>
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
        const minAllowedBid = <%= minNextBid %>;

        function addBidIncrement(amount) {
            const input = document.getElementById("bidAmountInput");
            if (!input) return;
            let current = parseFloat(input.value) || minAllowedBid;
            input.value = (current + amount).toFixed(2);
        }

        function validateBidInput() {
            const input = document.getElementById("bidAmountInput");
            if (!input) return true;
            const val = parseFloat(input.value);
            if (isNaN(val) || val < minAllowedBid) {
                alert("Your bid must be at least ₹" + minAllowedBid.toLocaleString("en-IN", { minimumFractionDigits: 2 }));
                input.focus();
                return false;
            }
            return true;
        }

        function updateCountdown() {
            const el = document.getElementById("countdownTimer");
            if (!el) return;

            const endStr = el.getAttribute("data-endtime");
            const startStr = el.getAttribute("data-starttime");

            if (!endStr) return;

            const now = new Date().getTime();
            const end = new Date(endStr.replace(" ", "T")).getTime();
            const start = startStr ? new Date(startStr.replace(" ", "T")).getTime() : 0;

            if (start && now < start) {
                const diff = start - now;
                const d = Math.floor(diff / (1000 * 60 * 60 * 24));
                const h = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                const m = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
                const s = Math.floor((diff % (1000 * 60)) / 1000);
                el.textContent = "Starts in " + (d > 0 ? d + "d " : "") + h + "h " + m + "m " + s + "s";
                return;
            }

            const diff = end - now;
            if (diff <= 0) {
                el.textContent = "AUCTION CLOSED";
                el.style.color = "#f87171";
                return;
            }

            const d = Math.floor(diff / (1000 * 60 * 60 * 24));
            const h = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const m = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
            const s = Math.floor((diff % (1000 * 60)) / 1000);

            const pad = num => String(num).padStart(2, '0');
            el.textContent = (d > 0 ? d + "d " : "") + pad(h) + ":" + pad(m) + ":" + pad(s);
        }

        setInterval(updateCountdown, 1000);
        updateCountdown();
    </script>
</body>
</html>
