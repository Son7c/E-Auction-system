<%@page contentType="text/html" pageEncoding="UTF-8" isELIgnored="true"%>
<%@page import="com.eauction.form.UserForm"%>
<%@page import="com.eauction.form.AuctionForm"%>
<%@page import="com.eauction.service.AuctionService"%>
<%@page import="com.eauction.util.AdminConfig"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    UserForm user = null;
    if (session != null && session.getAttribute("user") instanceof UserForm) {
        user = (UserForm) session.getAttribute("user");
    }

    if (!AdminConfig.isAdmin(user)) {
        response.sendRedirect("login.jsp?error=unauthorized");
        return;
    }

    AuctionService auctionService = new AuctionService();
    List<AuctionForm> allAuctions = auctionService.getAllAuctions();

    List<AuctionForm> pendingList = new ArrayList<>();
    List<AuctionForm> approvedList = new ArrayList<>();
    List<AuctionForm> completedList = new ArrayList<>();
    List<AuctionForm> rejectedList = new ArrayList<>();

    for (AuctionForm a : allAuctions) {
        if (a.isPending()) {
            pendingList.add(a);
        } else if (a.isRejected()) {
            rejectedList.add(a);
        } else if (a.isCompleted()) {
            completedList.add(a);
        } else {
            approvedList.add(a);
        }
    }

    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy 'at' hh:mm a");
    String flashMsg = request.getParameter("action");
    String flashStatus = request.getParameter("status");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>E-Auction | Admin Control Center</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            width: 100%;
            min-height: 100%;
            background: #f8fafc;
            scroll-behavior: smooth;
        }

        body {
            width: 100%;
            min-height: 100vh;
            font-family: Arial, Helvetica, sans-serif;
            background: #f8fafc;
            color: #0f172a;
            overflow-x: hidden;
        }

        /* ================= NAVBAR STYLES ================= */
        .navbar {
            height: 70px;
            background: #06152b;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 35px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.12);
            width: 100%;
            box-sizing: border-box;
        }

        .navbar .logo {
            display: flex;
            align-items: center;
            gap: 9px;
            color: white;
            font-size: 21px;
            font-weight: bold;
        }

        .navbar .logo-icon {
            font-size: 26px;
            display: flex;
            align-items: center;
        }

        .navbar .logo span {
            color: #2563eb;
        }

        .navbar .nav-links {
            display: flex;
            align-items: center;
            gap: 28px;
            list-style: none;
            margin: 0;
            padding: 0;
        }

        .navbar .nav-links a {
            color: white;
            text-decoration: none;
            font-size: 13px;
            transition: 0.2s;
        }

        .navbar .nav-links a:hover,
        .navbar .nav-links .active {
            color: #60a5fa;
        }

        .navbar .nav-buttons {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .navbar .dashboard-nav-btn {
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

        .navbar .dashboard-nav-btn:hover {
            background: #1765e8;
            color: #ffffff !important;
        }

        .navbar .logout-btn {
            padding: 7px 14px;
            border: 1px solid white;
            border-radius: 6px;
            color: white !important;
            text-decoration: none;
            font-size: 12px;
            transition: 0.2s;
        }

        .navbar .logout-btn:hover {
            background: white;
            color: #06152b !important;
        }

        /* ================= PAGE CONTAINER ================= */
        .admin-page {
            max-width: 1240px;
            margin: 0 auto;
            padding: 30px 24px 80px;
        }

        /* ================= HEADER BANNER ================= */
        .admin-header {
            background: linear-gradient(135deg, #091a33 0%, #0d284f 100%);
            border-radius: 16px;
            padding: 32px 36px;
            color: #ffffff;
            margin-bottom: 28px;
            box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.25);
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 20px;
            border: 1px solid rgba(255, 255, 255, 0.08);
        }

        .header-title-box {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .admin-shield-icon {
            width: 54px;
            height: 54px;
            background: rgba(234, 88, 12, 0.2);
            border: 2px solid #f97316;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            box-shadow: 0 0 20px rgba(249, 115, 22, 0.3);
        }

        .header-title-box h1 {
            font-size: 24px;
            font-weight: 800;
            letter-spacing: -0.5px;
            margin-bottom: 4px;
        }

        .header-subtitle {
            font-size: 13px;
            color: #94a3b8;
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .admin-badge-active {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 3px 10px;
            border-radius: 20px;
            background: rgba(16, 185, 129, 0.2);
            color: #34d399;
            border: 1px solid rgba(16, 185, 129, 0.4);
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .create-btn {
            background: #2563eb;
            color: white;
            padding: 10px 18px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: 0.2s;
            border: 1px solid #3b82f6;
        }

        .create-btn:hover {
            background: #1d4ed8;
            transform: translateY(-1px);
        }

        /* ================= KPI STATS ROW ================= */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 18px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 20px 22px;
            display: flex;
            align-items: center;
            gap: 16px;
            box-shadow: 0 2px 8px rgba(15, 23, 42, 0.04);
            transition: 0.2s;
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(15, 23, 42, 0.08);
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            flex-shrink: 0;
        }

        .stat-icon-pending {
            background: #fffbeb;
            color: #d97706;
            border: 1px solid #fde68a;
        }

        .stat-icon-approved {
            background: #ecfdf5;
            color: #059669;
            border: 1px solid #a7f3d0;
        }

        .stat-icon-completed {
            background: #f1f5f9;
            color: #334155;
            border: 1px solid #cbd5e1;
        }

        .stat-icon-rejected {
            background: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }

        .stat-icon-total {
            background: #eff6ff;
            color: #2563eb;
            border: 1px solid #bfdbfe;
        }

        .stat-details h3 {
            font-size: 26px;
            font-weight: 800;
            color: #0f172a;
            line-height: 1;
            margin-bottom: 4px;
        }

        .stat-details p {
            font-size: 12px;
            color: #64748b;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* ================= TAB CONTROLS ================= */
        .tabs-nav {
            display: flex;
            align-items: center;
            gap: 8px;
            border-bottom: 2px solid #e2e8f0;
            margin-bottom: 24px;
        }

        .tab-btn {
            background: transparent;
            border: none;
            padding: 12px 20px;
            font-size: 14px;
            font-weight: 700;
            color: #64748b;
            cursor: pointer;
            border-bottom: 3px solid transparent;
            margin-bottom: -2px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: 0.2s;
        }

        .tab-btn:hover {
            color: #0f172a;
        }

        .tab-btn.active {
            color: #ea580c;
            border-bottom-color: #ea580c;
        }

        .tab-pill {
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 800;
            background: #e2e8f0;
            color: #475569;
        }

        .tab-btn.active .tab-pill {
            background: #ffedd5;
            color: #c2410c;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        /* ================= FLASH ALERTS ================= */
        .alert-banner {
            padding: 14px 18px;
            border-radius: 10px;
            font-size: 13px;
            margin-bottom: 22px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .alert-success {
            background: #ecfdf5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }

        /* ================= PENDING CARDS LIST ================= */
        .pending-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 22px;
            margin-bottom: 18px;
            box-shadow: 0 2px 10px rgba(15, 23, 42, 0.04);
            display: grid;
            grid-template-columns: 120px 1fr auto;
            gap: 22px;
            align-items: center;
            transition: 0.2s;
        }

        .pending-card:hover {
            border-color: #cbd5e1;
            box-shadow: 0 6px 18px rgba(15, 23, 42, 0.06);
        }

        .pending-img {
            width: 120px;
            height: 110px;
            border-radius: 10px;
            object-fit: cover;
            background: #f1f5f9;
            border: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            overflow: hidden;
        }

        .pending-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .pending-info h3 {
            font-size: 18px;
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 6px;
        }

        .pending-meta {
            display: flex;
            align-items: center;
            gap: 14px;
            font-size: 12px;
            color: #64748b;
            margin-bottom: 8px;
            flex-wrap: wrap;
        }

        .category-tag {
            background: #eff6ff;
            color: #2563eb;
            padding: 3px 8px;
            border-radius: 6px;
            font-weight: 700;
        }

        .pending-desc {
            font-size: 13px;
            color: #475569;
            line-height: 1.5;
            margin-bottom: 10px;
            max-width: 650px;
        }

        .pending-pricing {
            display: flex;
            align-items: center;
            gap: 20px;
            font-size: 13px;
            color: #334155;
        }

        .pending-pricing strong {
            color: #0f172a;
            font-size: 15px;
        }

        .pending-actions {
            display: flex;
            flex-direction: column;
            gap: 10px;
            min-width: 170px;
        }

        .btn-approve {
            background: #10b981;
            color: white;
            border: none;
            padding: 10px 16px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            transition: 0.2s;
        }

        .btn-approve:hover {
            background: #059669;
            transform: translateY(-1px);
        }

        .btn-reject {
            background: #ef4444;
            color: white;
            border: none;
            padding: 10px 16px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            transition: 0.2s;
        }

        .btn-reject:hover {
            background: #dc2626;
            transform: translateY(-1px);
        }

        .btn-preview {
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #cbd5e1;
            padding: 8px 14px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
            transition: 0.2s;
        }

        .btn-preview:hover {
            background: #e2e8f0;
            color: #0f172a;
        }

        /* ================= TABLE DESIGN ================= */
        .table-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(15, 23, 42, 0.04);
        }

        .table-filters {
            padding: 18px 22px;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
        }

        .search-box {
            display: flex;
            align-items: center;
            gap: 8px;
            background: #ffffff;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            padding: 8px 14px;
            width: 320px;
        }

        .search-box input {
            border: none;
            outline: none;
            width: 100%;
            font-size: 13px;
        }

        .filter-select {
            padding: 8px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 13px;
            background: #ffffff;
            outline: none;
            color: #334155;
            font-weight: 600;
        }

        .admin-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        .admin-table th {
            background: #f8fafc;
            padding: 12px 18px;
            text-align: left;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
            font-weight: 700;
            border-bottom: 1px solid #e2e8f0;
        }

        .admin-table td {
            padding: 16px 18px;
            border-bottom: 1px solid #f1f5f9;
            color: #334155;
            vertical-align: middle;
        }

        .admin-table tr:hover {
            background: #f8fafc;
        }

        /* ================= STATUS PILLS ================= */
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.3px;
        }

        .badge-pending {
            background: #fef3c7;
            color: #b45309;
            border: 1px solid #fde68a;
        }

        .badge-approved {
            background: #ecfdf5;
            color: #059669;
            border: 1px solid #a7f3d0;
        }

        .badge-rejected {
            background: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }

        .badge-completed {
            background: #f1f5f9;
            color: #334155;
            border: 1px solid #cbd5e1;
        }

        /* ================= EMPTY STATE ================= */
        .empty-state {
            padding: 60px 20px;
            text-align: center;
            color: #64748b;
        }

        .empty-icon {
            font-size: 48px;
            margin-bottom: 12px;
        }

        .empty-state h3 {
            font-size: 18px;
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 6px;
        }

        .empty-state p {
            font-size: 13px;
            max-width: 420px;
            margin: 0 auto;
        }

        /* ================= CONFIG INFO CARD ================= */
        .config-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(15, 23, 42, 0.04);
        }

        .config-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 0;
            border-bottom: 1px solid #f1f5f9;
        }

        .config-item:last-child {
            border-bottom: none;
        }

        .config-key {
            font-weight: 700;
            font-size: 14px;
            color: #0f172a;
        }

        .config-val {
            font-family: monospace;
            background: #f1f5f9;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 13px;
            color: #1e293b;
            font-weight: 600;
        }

        /* ================= RESPONSIVE ================= */
        @media (max-width: 900px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .pending-card {
                grid-template-columns: 1fr;
            }
            .pending-actions {
                flex-direction: row;
                flex-wrap: wrap;
            }
        }

        @media (max-width: 600px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

    <!-- ================= NAVBAR ================= -->
    <%@include file="navbar.jsp" %>

    <!-- ================= MAIN ADMIN WRAPPER ================= -->
    <main class="admin-page">

        <!-- HEADER BANNER -->
        <div class="admin-header">
            <div class="header-title-box">
                <div class="admin-shield-icon">🛡️</div>
                <div>
                    <h1>Auction Moderation & Admin Control Center</h1>
                    <div class="header-subtitle">
                        <span>Signed in as <strong><%= user.getName() %></strong> (<%= user.getEmail() %>)</span>
                        <span>•</span>
                        <span>Address: <strong><%= user.getAddress() %></strong></span>
                        <span class="admin-badge-active">● Admin Mode Active</span>
                    </div>
                </div>
            </div>
            <div class="header-actions">
                <a href="create-auction.jsp" class="create-btn">
                    ➕ Create Listing
                </a>
            </div>
        </div>

        <!-- FLASH NOTIFICATION -->
        <% if (flashMsg != null) { %>
            <div class="alert-banner alert-success">
                <span style="font-size: 20px;">✅</span>
                <span>Action <strong><%= flashMsg.toUpperCase() %></strong> completed successfully! The listing status is now <strong><%= flashStatus != null ? flashStatus : "UPDATED" %></strong>.</span>
            </div>
        <% } %>

        <!-- KPI STATS OVERVIEW -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon stat-icon-pending">⏳</div>
                <div class="stat-details">
                    <h3><%= pendingList.size() %></h3>
                    <p>Pending Moderation</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon stat-icon-approved">✅</div>
                <div class="stat-details">
                    <h3><%= approvedList.size() %></h3>
                    <p>Live / Approved</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon stat-icon-completed">🏁</div>
                <div class="stat-details">
                    <h3><%= completedList.size() %></h3>
                    <p>Completed Auctions</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon stat-icon-rejected">❌</div>
                <div class="stat-details">
                    <h3><%= rejectedList.size() %></h3>
                    <p>Rejected Listings</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon stat-icon-total">📦</div>
                <div class="stat-details">
                    <h3><%= allAuctions.size() %></h3>
                    <p>Total Submissions</p>
                </div>
            </div>
        </div>

        <!-- TAB NAVIGATION -->
        <div class="tabs-nav">
            <button class="tab-btn <%= !pendingList.isEmpty() ? "active" : "" %>" onclick="switchTab('pendingTab', this)">
                ⏳ Pending Approvals
                <span class="tab-pill"><%= pendingList.size() %></span>
            </button>
            <button class="tab-btn <%= pendingList.isEmpty() ? "active" : "" %>" onclick="switchTab('allTab', this)">
                📋 All Listings Moderation
                <span class="tab-pill"><%= allAuctions.size() %></span>
            </button>
            <button class="tab-btn" onclick="switchTab('completedTab', this)">
                🏁 Completed Auctions
                <span class="tab-pill"><%= completedList.size() %></span>
            </button>
            <button class="tab-btn" onclick="switchTab('configTab', this)">
                ⚙️ Admin Security & Mode Info
            </button>
        </div>

        <!-- TAB 1: PENDING CONFIRMATIONS -->
        <div id="pendingTab" class="tab-content <%= !pendingList.isEmpty() ? "active" : "" %>">
            <% if (pendingList.isEmpty()) { %>
                <div class="table-card empty-state">
                    <div class="empty-icon">🎉</div>
                    <h3>All Caught Up!</h3>
                    <p>There are currently no listings awaiting moderation. All submitted auctions have been reviewed.</p>
                </div>
            <% } else { %>
                <div style="margin-bottom: 16px; font-size: 13px; color: #64748b;">
                    Showing <strong><%= pendingList.size() %></strong> listing<%= pendingList.size() == 1 ? "" : "s" %> awaiting your confirmation:
                </div>
                <% for (AuctionForm a : pendingList) { %>
                    <div class="pending-card" id="card-<%= a.getAuctionId() %>">
                        <div class="pending-img">
                            <% if (a.getImageUrl() != null && !a.getImageUrl().trim().isEmpty()) { %>
                                <img src="<%= a.getImageUrl() %>" alt="<%= a.getName() %>"
                                     onerror="this.onerror=null; this.parentElement.innerHTML='📦';">
                            <% } else { %>
                                📦
                            <% } %>
                        </div>
                        <div class="pending-info">
                            <h3><%= a.getName() %></h3>
                            <div class="pending-meta">
                                <span class="category-tag"><%= a.getCategory() != null ? a.getCategory() : "General" %></span>
                                <span>Seller: <strong><%= a.getSellerName() != null ? a.getSellerName() : ("User #" + a.getSellerId()) %></strong></span>
                                <span>Auction ID: #<%= a.getAuctionId() %></span>
                                <span>Duration: <%= a.getStartTime() != null ? sdf.format(a.getStartTime()) : "Now" %> → <%= a.getEndTime() != null ? sdf.format(a.getEndTime()) : "End" %></span>
                            </div>
                            <p class="pending-desc">
                                <%= a.getDescription() != null && !a.getDescription().trim().isEmpty() ? a.getDescription() : "No detailed description provided." %>
                            </p>
                            <div class="pending-pricing">
                                <span>Starting Bid: <strong>₹<%= String.format("%,.2f", a.getStartingBid()) %></strong></span>
                            </div>
                        </div>
                        <div class="pending-actions">
                            <button class="btn-approve" onclick="handleModeration(<%= a.getAuctionId() %>, 'approve')">
                                ✅ Confirm & List
                            </button>
                            <button class="btn-reject" onclick="handleModeration(<%= a.getAuctionId() %>, 'reject')">
                                ❌ Reject
                            </button>
                            <a href="bid.jsp?auctionId=<%= a.getAuctionId() %>" target="_blank" class="btn-preview">
                                🔍 Preview
                            </a>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>

        <!-- TAB 2: ALL LISTINGS MODERATION -->
        <div id="allTab" class="tab-content <%= pendingList.isEmpty() ? "active" : "" %>">
            <div class="table-card">
                <div class="table-filters">
                    <div class="search-box">
                        <span>🔍</span>
                        <input type="text" id="tableSearch" placeholder="Search by item name, seller, or ID..." onkeyup="filterTable()">
                    </div>
                    <select id="statusFilter" class="filter-select" onchange="filterTable()">
                        <option value="ALL">All Statuses</option>
                        <option value="PENDING">Pending Approval</option>
                        <option value="APPROVED">Live / Approved</option>
                        <option value="COMPLETED">Completed</option>
                        <option value="REJECTED">Rejected</option>
                    </select>
                </div>
                <div style="overflow-x: auto;">
                    <table class="admin-table" id="moderationTable">
                        <thead>
                            <tr>
                                <th>Item</th>
                                <th>Seller</th>
                                <th>Starting Bid</th>
                                <th>Current Bid</th>
                                <th>Status</th>
                                <th>End Time</th>
                                <th style="text-align: right;">Moderation Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (allAuctions.isEmpty()) { %>
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 40px; color: #94a3b8;">
                                        No auctions have been submitted to the database yet.
                                    </td>
                                </tr>
                            <% } else { %>
                                <% for (AuctionForm a : allAuctions) { %>
                                    <tr id="row-<%= a.getAuctionId() %>" data-status="<%= a.getStatus() %>">
                                        <td>
                                            <div style="display: flex; align-items: center; gap: 12px;">
                                                <div style="width: 40px; height: 40px; border-radius: 8px; background: #f1f5f9; display: flex; align-items: center; justify-content: center; overflow: hidden; flex-shrink: 0; font-size: 16px;">
                                                    <% if (a.getImageUrl() != null && !a.getImageUrl().trim().isEmpty()) { %>
                                                        <img src="<%= a.getImageUrl() %>" alt="<%= a.getName() %>" style="width: 100%; height: 100%; object-fit: cover;" onerror="this.onerror=null; this.parentElement.innerHTML='📦';">
                                                    <% } else { %>
                                                        📦
                                                    <% } %>
                                                </div>
                                                <div>
                                                    <strong style="color: #0f172a; display: block;"><%= a.getName() %></strong>
                                                    <small style="color: #64748b;"><%= a.getCategory() != null ? a.getCategory() : "General" %> • ID #<%= a.getAuctionId() %></small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <span style="font-weight: 600;"><%= a.getSellerName() != null ? a.getSellerName() : ("User #" + a.getSellerId()) %></span>
                                        </td>
                                        <td>
                                            ₹<%= String.format("%,.2f", a.getStartingBid()) %>
                                        </td>
                                        <td>
                                            <strong style="color: #1765e8;">₹<%= String.format("%,.2f", a.getHighestBid()) %></strong>
                                        </td>
                                        <td>
                                            <% if (a.isPending()) { %>
                                                <span class="badge badge-pending">⏳ Pending Approval</span>
                                            <% } else if (a.isRejected()) { %>
                                                <span class="badge badge-rejected">❌ Rejected</span>
                                            <% } else if (a.isCompleted()) { %>
                                                <span class="badge badge-completed">🏁 Completed</span>
                                            <% } else { %>
                                                <span class="badge badge-approved">● Live / Approved</span>
                                            <% } %>
                                        </td>
                                        <td style="color: #64748b; font-size: 12px;">
                                            <%= a.getEndTime() != null ? sdf.format(a.getEndTime()) : "Open" %>
                                        </td>
                                        <td style="text-align: right;">
                                            <div style="display: inline-flex; align-items: center; gap: 6px;">
                                                <% if (a.isCompleted()) { %>
                                                    <span style="font-size: 11px; font-weight: 700; color: #475569; padding: 4px 8px; background: #f1f5f9; border: 1px solid #cbd5e1; border-radius: 6px;">
                                                        🔒 Finalized
                                                    </span>
                                                    <% if (a.getBidCount() > 0) { %>
                                                        <a href="certificate?auctionId=<%= a.getAuctionId() %>" target="_blank" class="btn-preview" style="padding: 6px 10px; font-size: 11px; color: #059669; font-weight: 700; text-decoration: none;" title="View Winner Certificate">
                                                            📜 Certificate
                                                        </a>
                                                    <% } %>
                                                <% } else { %>
                                                    <% if (!a.isApproved()) { %>
                                                        <button onclick="handleModeration(<%= a.getAuctionId() %>, 'approve')" class="btn-approve" style="padding: 6px 12px; font-size: 11px;">
                                                            Approve
                                                        </button>
                                                    <% } %>
                                                    <% if (!a.isRejected()) { %>
                                                        <button onclick="handleModeration(<%= a.getAuctionId() %>, 'reject')" class="btn-reject" style="padding: 6px 12px; font-size: 11px;">
                                                            Reject
                                                        </button>
                                                    <% } %>
                                                <% } %>
                                                <button onclick="handleModeration(<%= a.getAuctionId() %>, 'delete')" class="btn-preview" style="padding: 6px 10px; font-size: 11px; color: #dc2626;" title="Delete Auction">
                                                    🗑️
                                                </button>
                                                <a href="bid.jsp?auctionId=<%= a.getAuctionId() %>" target="_blank" class="btn-preview" style="padding: 6px 10px; font-size: 11px;" title="View Details">
                                                    🔍
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- TAB: COMPLETED AUCTIONS -->
        <div id="completedTab" class="tab-content">
            <div class="table-card">
                <div style="padding: 20px 24px; border-bottom: 1px solid #f1f5f9; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px;">
                    <div>
                        <h2 style="font-size: 18px; font-weight: 800; color: #0f172a; display: flex; align-items: center; gap: 8px;">
                            <span>🏁</span> Completed & Finalized Auctions
                        </h2>
                        <p style="font-size: 12px; color: #64748b; margin-top: 4px;">
                            Auctions whose bidding period has concluded. These listings are officially closed and cannot be approved or rejected.
                        </p>
                    </div>
                    <span class="badge badge-completed" style="font-size: 12px; padding: 6px 12px;">
                        <%= completedList.size() %> Completed Listing<%= completedList.size() == 1 ? "" : "s" %>
                    </span>
                </div>

                <div style="overflow-x: auto;">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Item</th>
                                <th>Seller</th>
                                <th>Starting Bid</th>
                                <th>Winning / Final Bid</th>
                                <th>Total Bids</th>
                                <th>Ended On</th>
                                <th style="text-align: right;">Status & Records</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (completedList.isEmpty()) { %>
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 40px; color: #94a3b8;">
                                        No auctions have completed yet. Active auctions will automatically move here once their end time arrives.
                                    </td>
                                </tr>
                            <% } else { %>
                                <% for (AuctionForm c : completedList) { %>
                                    <tr>
                                        <td>
                                            <div style="display: flex; align-items: center; gap: 12px;">
                                                <div style="width: 40px; height: 40px; border-radius: 8px; background: #f1f5f9; display: flex; align-items: center; justify-content: center; overflow: hidden; flex-shrink: 0; font-size: 16px;">
                                                    <% if (c.getImageUrl() != null && !c.getImageUrl().trim().isEmpty()) { %>
                                                        <img src="<%= c.getImageUrl() %>" alt="<%= c.getName() %>" style="width: 100%; height: 100%; object-fit: cover;" onerror="this.onerror=null; this.parentElement.innerHTML='📦';">
                                                    <% } else { %>
                                                        📦
                                                    <% } %>
                                                </div>
                                                <div>
                                                    <strong style="color: #0f172a; display: block;"><%= c.getName() %></strong>
                                                    <small style="color: #64748b;"><%= c.getCategory() != null ? c.getCategory() : "General" %> • ID #<%= c.getAuctionId() %></small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <span style="font-weight: 600;"><%= c.getSellerName() != null ? c.getSellerName() : ("User #" + c.getSellerId()) %></span>
                                        </td>
                                        <td>
                                            ₹<%= String.format("%,.2f", c.getStartingBid()) %>
                                        </td>
                                        <td>
                                            <% if (c.getHighestBid() > 0) { %>
                                                <strong style="color: #059669;">₹<%= String.format("%,.2f", c.getHighestBid()) %> 🏆</strong>
                                            <% } else { %>
                                                <span style="color: #94a3b8;">No bids</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <span style="font-weight: 700;"><%= c.getBidCount() %></span> <%= c.getBidCount() == 1 ? "bid" : "bids" %>
                                        </td>
                                        <td style="color: #64748b; font-size: 12px;">
                                            <%= c.getEndTime() != null ? sdf.format(c.getEndTime()) : "Concluded" %>
                                        </td>
                                        <td style="text-align: right;">
                                            <div style="display: inline-flex; align-items: center; gap: 8px;">
                                                <span class="badge badge-completed">🏁 Completed</span>
                                                <% if (c.getBidCount() > 0) { %>
                                                    <a href="certificate?auctionId=<%= c.getAuctionId() %>" target="_blank" class="btn-preview" style="padding: 6px 12px; font-size: 12px; color: #065f46; background: #ecfdf5; border: 1px solid #a7f3d0; text-decoration: none; font-weight: 700;" title="View Official Certificate">
                                                        📜 Settlement Record
                                                    </a>
                                                <% } %>
                                                <a href="bid.jsp?auctionId=<%= c.getAuctionId() %>" target="_blank" class="btn-preview" style="padding: 6px 10px; font-size: 11px;" title="View Details">
                                                    🔍
                                                </a>
                                                <button onclick="handleModeration(<%= c.getAuctionId() %>, 'delete')" class="btn-preview" style="padding: 6px 10px; font-size: 11px; color: #dc2626;" title="Delete Auction">
                                                    🗑️
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- TAB 3: ADMIN CREDENTIALS & MODE INFO -->
        <div id="configTab" class="tab-content">
            <div class="config-card">
                <h2 style="font-size: 20px; font-weight: 800; margin-bottom: 8px;">Admin Mode Activation & Security Details</h2>
                <p style="font-size: 13px; color: #64748b; margin-bottom: 24px; line-height: 1.5;">
                    Admin mode is automatically activated when any signed-in user profile matches the designated Admin email and Admin address.
                </p>

                <div class="config-item">
                    <div>
                        <div class="config-key">Required Admin Email</div>
                        <div style="font-size: 12px; color: #64748b;">The user profile email address that activates admin privileges.</div>
                    </div>
                    <div class="config-val"><%= AdminConfig.getAdminEmail() %></div>
                </div>

                <div class="config-item">
                    <div>
                        <div class="config-key">Required Admin Address</div>
                        <div style="font-size: 12px; color: #64748b;">The user profile physical address that must match to trigger admin mode.</div>
                    </div>
                    <div class="config-val"><%= AdminConfig.getAdminAddress() %></div>
                </div>

                <div class="config-item">
                    <div>
                        <div class="config-key">Current Signed-in Profile</div>
                        <div style="font-size: 12px; color: #64748b;">The currently authenticated user session.</div>
                    </div>
                    <div class="config-val"><%= user.getEmail() %> • <%= user.getAddress() %></div>
                </div>

                <div class="config-item">
                    <div>
                        <div class="config-key">Moderation Enforcement Policy</div>
                        <div style="font-size: 12px; color: #64748b;">Listings created by standard sellers require admin confirmation before public bidding.</div>
                    </div>
                    <div class="config-val" style="color: #059669; background: #ecfdf5;">ENFORCED (PENDING BY DEFAULT)</div>
                </div>

                <div style="margin-top: 24px; padding: 16px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; font-size: 13px; color: #475569;">
                    💡 <strong>Tip:</strong> To change the admin credentials, you can configure <code>admin.email</code> and <code>admin.address</code> inside <code>src/java/config/db.properties</code>, or update <code>AdminConfig.java</code>.
                </div>
            </div>
        </div>

    </main>

    <!-- ================= JAVASCRIPT LOGIC ================= -->
    <script>
        function switchTab(tabId, btn) {
            document.querySelectorAll(".tab-content").forEach(el => el.classList.remove("active"));
            document.querySelectorAll(".tab-btn").forEach(el => el.classList.remove("active"));

            const target = document.getElementById(tabId);
            if (target) {
                target.classList.add("active");
            }
            if (btn) {
                btn.classList.add("active");
            }
        }

        async function handleModeration(auctionId, action) {
            if (action === "delete" && !confirm("Are you sure you want to permanently delete auction #" + auctionId + "?")) {
                return;
            }

            try {
                const formData = new URLSearchParams();
                formData.append("auctionId", auctionId);
                formData.append("action", action);

                const response = await fetch("moderateAuction", {
                    method: "POST",
                    headers: {
                        "X-Requested-With": "XMLHttpRequest",
                        "Accept": "application/json",
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: formData.toString()
                });

                const data = await response.json();
                if (data.success) {
                    window.location.href = "admin-dashboard.jsp?action=" + action + "&status=" + (data.newStatus || (action === 'approve' ? 'APPROVED' : (action === 'reject' ? 'REJECTED' : 'DELETED')));
                } else {
                    alert("Moderation failed: " + (data.message || "Could not update status."));
                }
            } catch (err) {
                console.error("Moderation AJAX error:", err);
                // Fallback to standard form submission
                const form = document.createElement("form");
                form.method = "POST";
                form.action = "moderateAuction";

                const idInput = document.createElement("input");
                idInput.type = "hidden";
                idInput.name = "auctionId";
                idInput.value = auctionId;
                form.appendChild(idInput);

                const actInput = document.createElement("input");
                actInput.type = "hidden";
                actInput.name = "action";
                actInput.value = action;
                form.appendChild(actInput);

                document.body.appendChild(form);
                form.submit();
            }
        }

        function filterTable() {
            const query = document.getElementById("tableSearch").value.toLowerCase();
            const statusFilter = document.getElementById("statusFilter").value.toUpperCase();
            const rows = document.querySelectorAll("#moderationTable tbody tr");

            rows.forEach(row => {
                const text = row.innerText.toLowerCase();
                const status = (row.getAttribute("data-status") || "").toUpperCase();

                const matchesQuery = query === "" || text.includes(query);
                const matchesStatus = statusFilter === "ALL" || status === statusFilter || (statusFilter === "APPROVED" && status === "");

                if (matchesQuery && matchesStatus) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            });
        }
    </script>

</body>
</html>

