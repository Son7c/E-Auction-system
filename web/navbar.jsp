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
    boolean isAuctions = requestURI.endsWith("bidding.jsp");
%>
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
            <span class="username"><%= navbarUser.getName() %></span>
            <a href="LogoutServlet" class="logout-btn">
                Logout
            </a>
        <% } %>
    </div>

</nav>
