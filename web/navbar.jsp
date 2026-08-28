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
        <div class="logo-icon">
            ⚒
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
