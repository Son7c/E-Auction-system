<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.eauction.form.UserForm"%>
<%
    UserForm navbarUser = null;
    try {
        if (session != null) {
            Object userObj = session.getAttribute("user");
            if (userObj instanceof UserForm) {
                navbarUser = (UserForm) userObj;
            }
        }
    } catch (Exception e) {
        navbarUser = null;
    }
    String requestURI = (request != null && request.getRequestURI() != null) ? request.getRequestURI() : "";
    boolean isHome = requestURI.endsWith("homepage.jsp") || requestURI.endsWith("/");
    boolean isAuctions = requestURI.endsWith("bidding.jsp") || requestURI.endsWith("bid.jsp");
    boolean isDashboard = requestURI.endsWith("dashboard.jsp");
    boolean isAdminDashboard = requestURI.endsWith("admin-dashboard.jsp");
    boolean navbarIsAdmin = com.eauction.util.AdminConfig.isAdmin(navbarUser);
%>
<style>
    /* Global self-contained styles for navbar across all pages */
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
        position: relative;
        z-index: 100;
    }

    .navbar .logo {
        display: flex;
        align-items: center;
        gap: 9px;
        color: white;
        font-size: 21px;
        font-weight: bold;
        text-decoration: none;
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

    .navbar .login-btn {
        padding: 7px 16px;
        background: transparent;
        border: 1px solid white;
        border-radius: 6px;
        color: white !important;
        text-decoration: none;
        font-size: 13px;
        transition: 0.2s;
    }

    .navbar .login-btn:hover {
        background: white;
        color: #06152b !important;
    }

    .navbar .register-btn {
        padding: 7px 16px;
        background: #2563eb;
        border: 1px solid #2563eb;
        border-radius: 6px;
        color: white !important;
        text-decoration: none;
        font-size: 13px;
        font-weight: bold;
        transition: 0.2s;
    }

    .navbar .register-btn:hover {
        background: #1d4ed8;
        border-color: #1d4ed8;
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
</style>
<!-- ================= NAVIGATION ================= -->
<nav class="navbar">

    <!-- LOGO -->
    <div class="logo">
        <div class="logo-icon" style="display: flex; align-items: center;">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="m14 13-7.5 7.5c-.83.83-2.17.83-3 0 0 0 0 0 0 0a2.12 2.12 0 0 1 0-3L11 10"/>
                <path d="m16 16 6-6"/>
                <path d="m8 8 6-6"/>
                <path d="m9 7 8 8"/>
                <path d="m21 11-8-8"/>
            </svg>
        </div>
        <div>
            E-<span>AUCTION</span>
        </div>
    </div>

    <!-- NAVIGATION LINKS -->
    <ul class="nav-links">
        <li>
            <a href="homepage.jsp" class="<%= isHome ? "active" : "" %>">
                Home
            </a>
        </li>
        <li>
            <a href="bidding.jsp" class="<%= isAuctions ? "active" : "" %>">
                Auctions
            </a>
        </li>
        <li>
            <a href="homepage.jsp#how-it-works">
                How It Works
            </a>
        </li>
        <li>
            <a href="homepage.jsp#about-us">
                About Us
            </a>
        </li>
        <li>
            <a href="homepage.jsp#contact">
                Contact
            </a>
        </li>
    </ul>

    <!-- LOGIN / REGISTER / USER SESSION -->
    <div class="nav-buttons">
        <% if (navbarUser == null) { %>
            <a href="login.jsp" class="login-btn">
                Login
            </a>
            <a href="signup.jsp" class="register-btn">
                Register
            </a>
        <% } else { %>
            <% if (navbarIsAdmin) { %>
                <a href="admin-dashboard.jsp" class="dashboard-nav-btn <%= isAdminDashboard ? "active" : "" %>" style="display: inline-flex; align-items: center; gap: 5px; padding: 7px 13px; background: rgba(234, 88, 12, 0.2); color: #fdba74; border: 1px solid #ea580c; border-radius: 6px; text-decoration: none; font-size: 12px; font-weight: 700;">
                    🛡️ Admin Panel
                </a>
            <% } %>
            <a href="dashboard.jsp" class="dashboard-nav-btn <%= isDashboard ? "active" : "" %>" style="display: inline-flex; align-items: center; gap: 5px; padding: 7px 13px; background: rgba(37,99,235,0.2); color: #93c5fd; border: 1px solid #3b82f6; border-radius: 6px; text-decoration: none; font-size: 12px; font-weight: 700;">
                📊 Dashboard (<%= navbarUser.getName() %>)
            </a>
            <a href="LogoutServlet" class="logout-btn">
                Logout
            </a>
        <% } %>
    </div>

</nav>
