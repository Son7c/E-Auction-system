<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.eauction.form.UserForm"%>
<%
    UserForm loggedInUser = null;
    if (session != null && session.getAttribute("user") instanceof UserForm) {
        loggedInUser = (UserForm) session.getAttribute("user");
    }
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>E-Auction | Create Auction</title>


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


        /* ================= NAV LINKS ================= */

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


        /* ================= MAIN ================= */

        .page {
            width: 100%;
            max-width: 1050px;
            margin: 0 auto;
            padding: 35px 25px 60px;
        }


        /* ================= PAGE HEADER ================= */

        .page-header {

            margin-bottom: 25px;

        }


        .back-link {

            display: inline-block;

            color: #1765e8;

            text-decoration: none;

            font-size: 12px;

            font-weight: bold;

            margin-bottom: 15px;

        }


        .back-link:hover {

            color: #0d4bc0;

        }


        .page-header h1 {

            font-size: 28px;

            color: #111827;

            margin-bottom: 7px;

        }


        .page-header p {

            color: #64748b;

            font-size: 13px;

        }


        /* ================= FORM CARD ================= */

        .form-card {

            background: white;

            border: 1px solid #dfe5ec;

            border-radius: 10px;

            padding: 32px;

            box-shadow:
                0 8px 25px rgba(15, 23, 42, 0.05);

        }


        /* ================= FORM SECTION ================= */

        .form-section {

            margin-bottom: 30px;

        }


        .section-title {

            display: flex;

            align-items: center;

            gap: 10px;

            padding-bottom: 13px;

            margin-bottom: 20px;

            border-bottom: 1px solid #e5e7eb;

        }


        .section-number {

            width: 28px;

            height: 28px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 50%;

            background: #edf4ff;

            color: #1765e8;

            font-size: 12px;

            font-weight: bold;

        }


        .section-title h2 {

            font-size: 16px;

            color: #111827;

        }


        /* ================= FORM GRID ================= */

        .form-grid {

            display: grid;

            grid-template-columns: 1fr 1fr;

            gap: 20px 25px;

        }


        .form-group {

            display: flex;

            flex-direction: column;

        }


        .form-group.full {

            grid-column: 1 / -1;

        }


        .form-group label {

            color: #334155;

            font-size: 12px;

            font-weight: bold;

            margin-bottom: 7px;

        }


        .required {

            color: #dc2626;

        }


        .form-group input,

        .form-group select,

        .form-group textarea {

            width: 100%;

            border: 1px solid #d6deea;

            border-radius: 6px;

            outline: none;

            padding: 11px;

            font-family: Arial, Helvetica, sans-serif;

            font-size: 12px;

            color: #0f172a;

            background: white;

            transition: 0.2s;

        }


        .form-group input,

        .form-group select {

            height: 42px;

        }


        .form-group textarea {

            min-height: 105px;

            resize: vertical;

        }


        .form-group input:focus,

        .form-group select:focus,

        .form-group textarea:focus {

            border-color: #1765e8;

            box-shadow:
                0 0 0 3px rgba(23, 101, 232, 0.08);

        }


        .help-text {

            color: #94a3b8;

            font-size: 10px;

            margin-top: 5px;

        }


        /* ================= IMAGE UPLOAD ================= */

        .upload-area {

            border: 2px dashed #cbd5e1;

            border-radius: 8px;

            min-height: 190px;

            display: flex;

            flex-direction: column;

            align-items: center;

            justify-content: center;

            text-align: center;

            padding: 25px;

            cursor: pointer;

            transition: 0.2s;

        }


        .upload-area:hover {

            border-color: #1765e8;

            background: #f8fbff;

        }


        .upload-icon {

            width: 55px;

            height: 55px;

            border-radius: 50%;

            background: #edf4ff;

            display: flex;

            align-items: center;

            justify-content: center;

            color: #1765e8;

            font-size: 24px;

            margin-bottom: 12px;

        }


        .upload-area h3 {

            color: #334155;

            font-size: 13px;

            margin-bottom: 5px;

        }


        .upload-area p {

            color: #94a3b8;

            font-size: 11px;

        }


        .upload-area small {

            color: #cbd5e1;

            font-size: 10px;

            margin-top: 5px;

        }


        #itemImage {

            display: none;

        }


        /* ================= IMAGE PREVIEW ================= */

        .preview-container {

            display: none;

            margin-top: 15px;

            position: relative;

            width: 180px;

            height: 130px;

            margin-left: auto;

            margin-right: auto;

        }


        .preview-container img {

            width: 100%;

            height: 100%;

            object-fit: contain;

            border: 1px solid #dfe5ec;

            border-radius: 7px;

            background: white;

        }


        .remove-image {

            position: absolute;

            top: -8px;

            right: -8px;

            width: 25px;

            height: 25px;

            border: none;

            border-radius: 50%;

            background: #dc2626;

            color: white;

            cursor: pointer;

            font-size: 12px;

        }


        /* ================= PRICE BOX ================= */

        .price-note {

            background: #f8fbff;

            border: 1px solid #dbeafe;

            border-radius: 7px;

            padding: 13px;

            margin-top: 15px;

            color: #475569;

            font-size: 11px;

            line-height: 1.5;

        }


        /* ================= ACTION BUTTONS ================= */

        .form-actions {

            display: flex;

            gap: 10px;

            justify-content: flex-end;

            border-top: 1px solid #e5e7eb;

            padding-top: 25px;

            margin-top: 10px;

        }


        .cancel-button {

            height: 43px;

            padding: 0 25px;

            border: 1px solid #cbd5e1;

            border-radius: 6px;

            background: white;

            color: #475569;

            font-size: 12px;

            font-weight: bold;

            cursor: pointer;

        }


        .cancel-button:hover {

            background: #f1f5f9;

        }


        .create-button {

            height: 43px;

            padding: 0 28px;

            border: none;

            border-radius: 6px;

            background: #1765e8;

            color: white;

            font-size: 12px;

            font-weight: bold;

            cursor: pointer;

        }


        .create-button:hover {

            background: #0d4bc0;

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

                height: auto;

                padding: 15px;

            }


            .page {

                padding: 25px 15px 45px;

            }


            .form-card {

                padding: 22px;

            }


            .form-grid {

                grid-template-columns: 1fr;

            }


            .form-group.full {

                grid-column: auto;

            }


            .form-actions {

                flex-direction: column-reverse;

            }


            .cancel-button,

            .create-button {

                width: 100%;

            }

        }

    </style>

</head>


<body>


    <!-- ================= NAVIGATION ================= -->

    <%@include file="navbar.jsp" %>




    <!-- ================= MAIN ================= -->

    <main class="page">


        <!-- ================= PAGE HEADER ================= -->

        <div class="page-header">


            <a
                href="bidding.jsp"
                class="back-link"
            >
                ← Back to Auctions
            </a>


            <h1>
                Create New Auction
            </h1>


            <p>
                List your item and let users compete to win it.
            </p>


        </div>



        <!-- ================= FORM CARD ================= -->

        <div class="form-card">

            <!-- ALERT NOTIFICATION -->
            <div id="alertMessage" style="display: none; padding: 12px; border-radius: 8px; font-size: 14px; margin-bottom: 20px; text-align: center;"></div>

            <form
                id="auctionForm"
                action="createItem"
                method="post"
                onsubmit="return validateDates()"
            >


                <!-- ================= ITEM DETAILS ================= -->

                <div class="form-section">


                    <div class="section-title">

                        <div class="section-number">
                            1
                        </div>

                        <h2>
                            Item Details
                        </h2>

                    </div>


                    <div class="form-grid">


                        <!-- ITEM NAME -->

                        <div class="form-group">

                            <label>
                                Item Name
                                <span class="required">*</span>
                            </label>


                            <input
                                type="text"
                                id="itemName"
                                name="name"
                                placeholder="e.g. Canon EOS 200D Camera"
                                required
                            >

                        </div>


                        <!-- CATEGORY -->

                        <div class="form-group">

                            <label>
                                Category
                                <span class="required">*</span>
                            </label>


                            <select
                                id="category"
                                name="category"
                                required
                            >

                                <option value="">
                                    Select Category
                                </option>

                                <option value="Electronics">
                                    Electronics
                                </option>

                                <option value="Fashion">
                                    Fashion
                                </option>

                                <option value="Watches">
                                    Watches
                                </option>

                                <option value="Art & Collectibles">
                                    Art & Collectibles
                                </option>

                                <option value="Vehicles">
                                    Vehicles
                                </option>

                                <option value="Home & Lifestyle">
                                    Home & Lifestyle
                                </option>

                                <option value="Books">
                                    Books
                                </option>

                                <option value="Other">
                                    Other
                                </option>

                            </select>

                        </div>


                        <!-- DESCRIPTION -->

                        <div class="form-group full">

                            <label>
                                Item Description
                                <span class="required">*</span>
                            </label>


                            <textarea
                                id="description"
                                name="description"
                                placeholder="Describe the item, its condition, features, specifications, etc."
                                required
                            ></textarea>


                            <span class="help-text">
                                Provide accurate information about the item to help bidders make an informed decision.
                            </span>

                        </div>


                    </div>


                </div>



                <!-- ================= IMAGE ================= -->

                <div class="form-section">


                    <div class="section-title">

                        <div class="section-number">
                            2
                        </div>

                        <h2>
                            Item Images
                        </h2>

                    </div>


                    <div class="form-group full">

                        <label for="imageUrl">
                            Image URL
                        </label>

                        <input
                            type="url"
                            id="imageUrl"
                            name="imageUrl"
                            placeholder="e.g. https://example.com/image.jpg or images/auction.png"
                            oninput="previewImageUrl(this.value)"
                        >

                        <span class="help-text">
                            Enter a direct web image link or local image path.
                        </span>

                    </div>


                    <div
                        class="preview-container"
                        id="previewContainer"
                    >

                        <img
                            id="imagePreview"
                            alt="Item Preview"
                            onerror="handleImageError()"
                        >


                        <button
                            type="button"
                            class="remove-image"
                            onclick="removeImage()"
                        >
                            ×
                        </button>

                    </div>


                </div>



                <!-- ================= AUCTION SETTINGS ================= -->

                <div class="form-section">


                    <div class="section-title">

                        <div class="section-number">
                            3
                        </div>

                        <h2>
                            Auction Settings
                        </h2>

                    </div>


                    <div class="form-grid">


                        <!-- STARTING PRICE -->

                        <div class="form-group">

                            <label>
                                Starting Price (₹)
                                <span class="required">*</span>
                            </label>


                            <input
                                type="number"
                                id="startingPrice"
                                name="startingPrice"
                                placeholder="e.g. 5000"
                                min="1"
                                required
                            >


                            <span class="help-text">
                                The first bid will start from this amount.
                            </span>

                        </div>


                        <!-- BID INCREMENT -->

                        <div class="form-group">

                            <label>
                                Minimum Bid Increment (₹)
                                <span class="required">*</span>
                            </label>


                            <input
                                type="number"
                                id="bidIncrement"
                                name="bidIncrement"
                                placeholder="e.g. 500"
                                min="1"
                                required
                            >


                            <span class="help-text">
                                Minimum amount by which each new bid must increase.
                            </span>

                        </div>


                        <!-- START DATE -->

                        <div class="form-group">

                            <label>
                                Auction Start
                                <span class="required">*</span>
                            </label>


                            <input
                                type="datetime-local"
                                id="startDate"
                                name="startDate"
                                required
                            >

                        </div>


                        <!-- END DATE -->

                        <div class="form-group">

                            <label>
                                Auction End
                                <span class="required">*</span>
                            </label>


                            <input
                                type="datetime-local"
                                id="endDate"
                                name="endDate"
                                required
                            >

                        </div>


                    </div>


                    <div class="price-note">

                        <strong>
                            💡 Tip:
                        </strong>

                        Set a reasonable starting price and minimum bid
                        increment to encourage more users to participate
                        in your auction.

                    </div>


                </div>



                <!-- ================= ACTIONS ================= -->

                <div class="form-actions">


                    <button
                        type="button"
                        class="cancel-button"
                        onclick="cancelAuction()"
                    >
                        Cancel
                    </button>


                    <button
                        type="submit"
                        class="create-button"
                    >
                        Create Auction
                    </button>


                </div>


            </form>


        </div>


    </main>



    <!-- ================= FOOTER ================= -->

    <footer>

        © 2026 E-Auction System | All Rights Reserved

    </footer>



    <!-- ================= JAVASCRIPT ================= -->

    <script>


        /* ================= IMAGE PREVIEW ================= */

        function previewImageUrl(url) {

            const preview =
                document.getElementById("imagePreview");


            const container =
                document.getElementById("previewContainer");


            const trimmedUrl = url.trim();

            if (!trimmedUrl) {

                container.style.display = "none";

                preview.src = "";

                return;

            }


            preview.src = trimmedUrl;

            container.style.display = "block";

        }



        function handleImageError() {

            const container =
                document.getElementById("previewContainer");

            container.style.display = "none";

        }



        /* ================= REMOVE IMAGE ================= */

        function removeImage() {

            const imageUrlInput =
                document.getElementById("imageUrl");

            if (imageUrlInput) {

                imageUrlInput.value = "";

            }


            document
                .getElementById("previewContainer")
                .style.display = "none";


            document
                .getElementById("imagePreview")
                .src = "";

        }



        /* ================= VALIDATE DATES BEFORE SUBMIT ================= */

        function validateDates() {

            const startVal =
                document.getElementById("startDate").value;

            const endVal =
                document.getElementById("endDate").value;

            if (startVal && endVal) {

                const startDate = new Date(startVal);
                const endDate = new Date(endVal);

                if (endDate <= startDate) {

                    alert(
                        "Auction end time must be after the start time."
                    );

                    return false;

                }

            }

            return true;

        }



        /* ================= CANCEL ================= */

        function cancelAuction() {

            const confirmCancel =
                confirm(
                    "Are you sure you want to cancel? All entered information will be lost."
                );


            if (confirmCancel) {

                window.location.href =
                    "bidding.jsp";

            }

        }

        // Check for URL status parameters
        window.addEventListener("DOMContentLoaded", () => {
            const urlParams = new URLSearchParams(window.location.search);
            const alertBox = document.getElementById("alertMessage");
            if (alertBox && urlParams.get("error") === "failed") {
                alertBox.style.display = "block";
                alertBox.style.background = "#fee2e2";
                alertBox.style.color = "#b91c1c";
                alertBox.style.border = "1px solid #fecaca";
                alertBox.textContent = "Failed to create auction. Please try again.";
            }
        });

    </script>


</body>

</html>
