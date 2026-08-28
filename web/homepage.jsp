<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0"
            >

        <title>E-Auction System</title>


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
                color: #0f172a;
                background: #ffffff;
                display: flex;
                flex-direction: column;
                overflow-x: hidden;
                overscroll-behavior: none;
            }

            main {
                width: 100%;
                flex: 1 0 auto;
                margin: 0;
                padding: 0;
            }

            section {
                width: 100%;
                margin: 0;
            }


            /* ================= NAVIGATION BAR ================= */

            .navbar {

                height: 85px;

                background: #06152b;

                display: flex;

                align-items: center;

                justify-content: space-between;

                padding: 0 60px;

            }


            .logo {

                display: flex;

                align-items: center;

                gap: 10px;

                color: white;

                font-size: 24px;

                font-weight: bold;

            }


            .logo-icon {
                font-size: 32px;
            }


            .logo span {
                color: #2563eb;
            }


            .nav-links {

                display: flex;

                gap: 32px;

                list-style: none;

            }


            .nav-links a {

                text-decoration: none;

                color: white;

                font-size: 15px;

                transition: 0.2s;

            }


            .nav-links a:hover {

                color: #3b82f6;

            }

            .username {
                color: #ffffff !important;
                text-decoration: none;
            }

            .logout-btn {
                color: #ffffff !important;
                text-decoration: none;
            }


            /* ================= NAV BUTTONS ================= */

            .nav-buttons {

                display: flex;

                gap: 15px;

            }


            .login-btn {

                padding: 13px 28px;

                border: 1px solid white;

                border-radius: 8px;

                color: white;

                text-decoration: none;

            }


            .register-btn {

                padding: 14px 28px;

                background: #1765e8;

                color: white;

                border-radius: 8px;

                text-decoration: none;

                font-weight: bold;

            }


            .login-btn:hover {

                background: white;

                color: #06152b;

            }


            .register-btn:hover {

                background: #0d4bc0;

            }


            /* ================= HERO SECTION ================= */

            .hero {

                min-height: 525px;

                padding: 55px 65px;

                display: flex;

                align-items: center;

                justify-content: space-between;

                background: linear-gradient(
                    110deg,
                    #ffffff 45%,
                    #f1f6ff 100%
                    );

            }


            .hero-content {

                width: 48%;

            }


            .secure-text {

                display: inline-block;

                padding: 10px 18px;

                border-radius: 25px;

                background: #eef4ff;

                color: #174ea6;

                font-size: 14px;

                font-weight: bold;

                margin-bottom: 25px;

            }


            .hero h1 {

                font-size: 58px;

                line-height: 1.08;

                margin-bottom: 22px;

                color: #101827;

            }


            .hero h1 span {

                color: #1765e8;

            }


            .hero-description {

                color: #64748b;

                font-size: 18px;

                line-height: 1.7;

                max-width: 520px;

                margin-bottom: 30px;

            }


            .hero-buttons {

                display: flex;

                gap: 18px;

            }


            .explore-btn {

                padding: 16px 30px;

                background: #125ce5;

                color: white;

                text-decoration: none;

                border-radius: 8px;

                font-weight: bold;

            }


            .works-btn {

                padding: 16px 30px;

                border: 1px solid #cbd5e1;

                color: #1e293b;

                text-decoration: none;

                border-radius: 8px;

                background: white;

                font-weight: bold;

            }


            .explore-btn:hover {

                background: #0d4bc0;

            }


            .works-btn:hover {

                background: #f1f5f9;

            }


            /* ================= HERO IMAGE ================= */

            .hero-visual {

                width: 46%;

                height: 420px;

                position: relative;

                display: flex;

                align-items: center;

                justify-content: center;

            }


            .hero-image {

                width: 90%;

                height: 380px;

                object-fit: cover;

                border-radius: 20px;

                box-shadow:
                    0 15px 35px rgba(0,0,0,0.12);

            }


            /* ================= HAPPY BIDDERS ================= */

            .bidders-card {

                position: absolute;

                right: 0;

                bottom: 50px;

                width: 175px;

                padding: 18px;

                background: white;

                border-radius: 12px;

                box-shadow:
                    0 8px 25px rgba(0,0,0,0.15);

            }


            .bidders-card strong {

                font-size: 27px;

                color: #174ea6;

            }


            .bidders-card p {

                margin-top: 5px;

                color: #64748b;

                font-size: 13px;

            }


            /* ================= HOW IT WORKS ================= */

            .how-it-works {

                padding: 75px 60px;

                background: white;

                text-align: center;

            }


            .how-it-works h2 {

                font-size: 32px;

                margin-bottom: 55px;

                color: #111827;

            }


            .steps {

                max-width: 1250px;

                margin: auto;

                display: flex;

                align-items: center;

                justify-content: space-between;

            }


            .step {

                width: 20%;

                text-align: center;

            }


            .step-icon {

                width: 75px;

                height: 75px;

                margin: 0 auto 18px;

                border-radius: 50%;

                background: #edf4ff;

                display: flex;

                justify-content: center;

                align-items: center;

                font-size: 32px;

                color: #1765e8;

            }


            .step h3 {

                font-size: 16px;

                margin-bottom: 10px;

                color: #111827;

            }


            .step p {

                color: #64748b;

                font-size: 13px;

                line-height: 1.5;

            }


            /* ================= ARROWS ================= */

            .arrow {

                width: 70px;

                display: flex;

                justify-content: center;

                align-items: center;

                margin-top: -45px;

            }


            .arrow span {

                font-size: 38px;

                color: #1765e8;

                font-weight: bold;

            }


            /* ================= ABOUT US ================= */

            .about-section {

                padding: 85px 60px;

                background: linear-gradient(
                    135deg,
                    #f8fbff 0%,
                    #eef5ff 100%
                    );

                text-align: center;

            }


            .about-content {

                max-width: 900px;

                margin: auto;

            }


            .about-section h2 {

                font-size: 34px;

                color: #111827;

                margin-bottom: 18px;

                font-weight: 700;

            }


            .about-section h2::after {

                content: "";

                display: block;

                width: 55px;

                height: 4px;

                background: #1765e8;

                border-radius: 10px;

                margin: 12px auto 30px;

            }


            /* ABOUT CARDS */

            .about-boxes {

                display: flex;

                justify-content: center;

                gap: 25px;

                margin-top: 25px;

            }


            .about-box {

                flex: 1;

                max-width: 400px;

                padding: 30px;

                background: white;

                border-radius: 15px;

                border: 1px solid #e2e8f0;

                box-shadow:
                    0 8px 25px rgba(15, 23, 42, 0.07);

                text-align: left;

                transition: 0.3s;

            }


            .about-box:hover {

                transform: translateY(-5px);

                box-shadow:
                    0 15px 35px rgba(23, 101, 232, 0.12);

                border-color: #bfdbfe;

            }


            .about-box-icon {

                width: 48px;

                height: 48px;

                display: flex;

                align-items: center;

                justify-content: center;

                border-radius: 12px;

                background: #edf4ff;

                color: #1765e8;

                font-size: 23px;

                margin-bottom: 18px;

            }


            .about-box h3 {

                font-size: 18px;

                color: #111827;

                margin-bottom: 10px;

            }


            .about-box p {

                color: #64748b;

                font-size: 14px;

                line-height: 1.7;

            }


            /* ================= CONTACT ================= */

            .contact-section {

                padding: 85px 60px;

                background: white;

                text-align: center;

            }


            .contact-content {

                max-width: 900px;

                margin: auto;

            }


            .contact-section h2 {

                font-size: 34px;

                color: #111827;

                margin-bottom: 18px;

                font-weight: 700;

            }


            .contact-section h2::after {

                content: "";

                display: block;

                width: 55px;

                height: 4px;

                background: #1765e8;

                border-radius: 10px;

                margin: 12px auto 20px;

            }


            .contact-description {

                color: #64748b;

                font-size: 16px;

                line-height: 1.6;

                margin-bottom: 40px;

            }


            /* CONTACT CARDS */

            .contact-details {

                display: flex;

                justify-content: center;

                gap: 25px;

            }


            .contact-box {

                width: 280px;

                padding: 28px 25px;

                background: #f8fafc;

                border: 1px solid #e2e8f0;

                border-radius: 15px;

                box-shadow:
                    0 8px 25px rgba(15, 23, 42, 0.06);

                transition: 0.3s;

            }


            .contact-box:hover {

                transform: translateY(-5px);

                background: #ffffff;

                border-color: #bfdbfe;

                box-shadow:
                    0 15px 30px rgba(23, 101, 232, 0.12);

            }


            /* CONTACT ICON */

            .contact-icon {

                width: 50px;

                height: 50px;

                margin: 0 auto 15px;

                display: flex;

                align-items: center;

                justify-content: center;

                border-radius: 50%;

                background: #edf4ff;

                color: #1765e8;

                font-size: 22px;

            }


            .contact-box h3 {

                color: #1765e8;

                font-size: 16px;

                margin-bottom: 8px;

            }


            .contact-box p {

                color: #64748b;

                font-size: 14px;

            }


            /* ================= FOOTER ================= */

            footer {
                width: 100%;
                flex-shrink: 0;
                margin: 0;
                padding: 20px;
                background: #06152b;
                color: white;
                text-align: center;
                font-size: 13px;
            }


            /* ================= RESPONSIVE ================= */

            @media (max-width: 1000px) {

                .navbar {

                    padding: 0 25px;

                }


                .nav-links {

                    display: none;

                }


                .hero {

                    flex-direction: column;

                    text-align: center;

                    padding: 50px 30px;

                }


                .hero-content {

                    width: 100%;

                }


                .hero-description {

                    margin-left: auto;

                    margin-right: auto;

                }


                .hero-buttons {

                    justify-content: center;

                }


                .hero-visual {

                    width: 100%;

                    margin-top: 40px;

                }


                .steps {

                    flex-direction: column;

                    gap: 30px;

                }


                .step {

                    width: 100%;

                }


                .arrow {

                    transform: rotate(90deg);

                    margin: 0;

                }

            }


            @media (max-width: 700px) {

                .about-section,
                .contact-section {

                    padding: 60px 25px;

                }


                .about-section h2,
                .contact-section h2 {

                    font-size: 28px;

                }


                .about-boxes {

                    flex-direction: column;

                    align-items: center;

                }


                .about-box {

                    width: 100%;

                }


                .contact-details {

                    flex-direction: column;

                    align-items: center;

                }


                .contact-box {

                    width: 100%;

                    max-width: 350px;

                }

            }


            @media (max-width: 600px) {

                .navbar {

                    height: 70px;

                    padding: 0 15px;

                }


                .logo {

                    font-size: 18px;

                }


                .nav-buttons {

                    gap: 7px;

                }


                .login-btn,
                .register-btn {

                    padding: 9px 13px;

                    font-size: 11px;

                }


                .hero h1 {

                    font-size: 38px;

                }


                .hero-description {

                    font-size: 15px;

                }


                .hero-buttons {

                    flex-direction: column;

                    align-items: center;

                }


                .hero-visual {

                    height: 300px;

                }


                .hero-image {

                    height: 270px;

                }

            }


            /* ===== FINAL OVERSCROLL PROTECTION ===== */
            html,
            body {
                overscroll-behavior: none;
            }

        </style>

    </head>


    <body>


        <!-- ================= NAVIGATION ================= -->

        <%@include file="navbar.jsp" %>



        <main>

            <!-- ================= HERO ================= -->

            <section class="hero">


                <div class="hero-content">


                    <div class="secure-text">

                        🛡 Safe. Transparent. Secure.

                    </div>


                    <h1>

                        Bid. Win.<br>

                        Own <span>Extraordinary.</span>

                    </h1>


                    <p class="hero-description">

                        Join thousands of smart bidders in our secure
                        e-auction platform. Find unique items and win
                        them at the best prices.

                    </p>


                    <div class="hero-buttons">


                        <a
                            href="bidding.jsp"
                            class="explore-btn"
                            >
                            Explore Auctions &nbsp; →
                        </a>


                        <a
                            href="#how-it-works"
                            class="works-btn"
                            >
                            How It Works &nbsp; →
                        </a>


                    </div>


                </div>



                <!-- HERO IMAGE -->

                <div class="hero-visual">


                    <img
                        src="images/auction.png"
                        alt="Auction Items"
                        class="hero-image"
                        >


                    <div class="bidders-card">

                        <strong>
                            10K+
                        </strong>

                        <p>
                            Happy Bidders
                        </p>

                    </div>


                </div>


            </section>



            <!-- ================= HOW IT WORKS ================= -->

            <section
                class="how-it-works"
                id="how-it-works"
                >


                <h2>
                    How It Works
                </h2>


                <div class="steps">


                    <!-- STEP 1 -->

                    <div class="step">

                        <div class="step-icon">
                            👤
                        </div>

                        <h3>
                            1. Create Account
                        </h3>

                        <p>
                            Sign up for free and join
                            our auction community.
                        </p>

                    </div>


                    <!-- ARROW -->

                    <div class="arrow">

                        <span>
                            →
                        </span>

                    </div>


                    <!-- STEP 2 -->

                    <div class="step">

                        <div class="step-icon">
                            🔍
                        </div>

                        <h3>
                            2. Find Auctions
                        </h3>

                        <p>
                            Discover items you love
                            and place your bids.
                        </p>

                    </div>


                    <!-- ARROW -->

                    <div class="arrow">

                        <span>
                            →
                        </span>

                    </div>


                    <!-- STEP 3 -->

                    <div class="step">

                        <div class="step-icon">
                            🔨
                        </div>

                        <h3>
                            3. Place Your Bid
                        </h3>

                        <p>
                            Compete in real-time and
                            bid higher to win.
                        </p>

                    </div>


                    <!-- ARROW -->

                    <div class="arrow">

                        <span>
                            →
                        </span>

                    </div>


                    <!-- STEP 4 -->

                    <div class="step">

                        <div class="step-icon">
                            🏆
                        </div>

                        <h3>
                            4. Win & Enjoy
                        </h3>

                        <p>
                            Win the auction and get
                            your item delivered.
                        </p>

                    </div>


                </div>


            </section>



            <!-- ================= ABOUT US ================= -->

            <section
                class="about-section"
                id="about-us"
                >

                <div class="about-content">


                    <h2>
                        About Us
                    </h2>


                    <div class="about-boxes">


                        <!-- ABOUT BOX 1 -->

                        <div class="about-box">


                            <div class="about-box-icon">
                                🔒
                            </div>


                            <h3>
                                Secure & Transparent
                            </h3>


                            <p>

                                Our e-auction platform provides
                                a secure and transparent environment
                                where users can participate in
                                auctions with confidence.

                            </p>


                        </div>


                        <!-- ABOUT BOX 2 -->

                        <div class="about-box">


                            <div class="about-box-icon">
                                ⚡
                            </div>


                            <h3>
                                Simple & Convenient
                            </h3>


                            <p>

                                Discover unique items, place
                                competitive bids, and manage
                                your auctions through a simple
                                and easy-to-use platform.

                            </p>


                        </div>


                    </div>


                </div>

            </section>



            <!-- ================= CONTACT ================= -->

            <section
                class="contact-section"
                id="contact"
                >


                <div class="contact-content">


                    <h2>
                        Contact Us
                    </h2>


                    <p class="contact-description">

                        Have a question or need help?
                        Our team is here to assist you.

                    </p>


                    <div class="contact-details">


                        <!-- EMAIL -->

                        <div class="contact-box">


                            <div class="contact-icon">
                                ✉
                            </div>


                            <h3>
                                Email Us
                            </h3>


                            <p>
                                support@eauction.com
                            </p>


                        </div>


                        <!-- PHONE -->

                        <div class="contact-box">


                            <div class="contact-icon">
                                ☎
                            </div>


                            <h3>
                                Call Us
                            </h3>


                            <p>
                                +91 62050 12885
                            </p>


                        </div>


                        <!-- SUPPORT -->

                        <div class="contact-box">


                            <div class="contact-icon">
                                💬
                            </div>


                            <h3>
                                Support
                            </h3>


                            <p>
                                Available Monday – Friday
                            </p>


                        </div>


                    </div>


                </div>


            </section>


        </main>


        <!-- ================= FOOTER ================= -->

        <footer>

            © 2026 E-Auction System | All Rights Reserved

        </footer>


    </body>

</html>
