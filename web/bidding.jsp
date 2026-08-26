<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
            background: #06152b;
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

    <jsp:include page="navbar.jsp" />




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



        <!-- ================= EMPTY AUCTION AREA ================= -->

        <div class="empty-state">


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

        function searchAuctions() {

            const search =
                document
                .getElementById("searchInput")
                .value
                .toLowerCase();


            /*
             * Auctions will later be loaded
             * from the database by the backend.
             *
             * This function is kept ready
             * for the auction cards.
             */

            console.log(
                "Searching for:",
                search
            );

        }

    </script>


</body>

</html>
