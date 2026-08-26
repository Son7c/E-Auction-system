<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>E-Auction | Create Account</title>


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
            background: #eaf2ff;
            overscroll-behavior: none;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            min-height: 100vh;
            min-height: 100dvh;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(
                135deg,
                #f4f8ff,
                #eaf2ff
            );
            color: #0f172a;
            padding: 25px;
            box-sizing: border-box;
            overflow-x: hidden;
            overscroll-behavior: none;
        }

        /* Prevent white area from being exposed during overscroll */
        html::before {
            content: "";
            position: fixed;
            inset: 0;
            background: #eaf2ff;
            z-index: -9999;
            pointer-events: none;
        }


        /* ================= SIGNUP CARD ================= */

        .signup-card {

            width: 440px;

            background: #ffffff;

            padding: 42px 45px 32px;

            border-radius: 18px;

            border: 1px solid #e5eaf2;

            box-shadow:
                0 15px 40px rgba(15, 23, 42, 0.12);

        }


        /* ================= HEADING ================= */

        .signup-card h1 {

            text-align: center;

            font-size: 30px;

            font-weight: 700;

            color: #0f172a;

            margin-bottom: 7px;

        }


        .subtitle {

            text-align: center;

            color: #64748b;

            font-size: 15px;

            margin-bottom: 30px;

        }


        /* ================= FORM ================= */

        .form-group {

            margin-bottom: 17px;

        }


        .form-group label {

            display: block;

            font-size: 14px;

            font-weight: 600;

            color: #1e293b;

            margin-bottom: 7px;

        }


        /* ================= INPUT BOX ================= */

        .input-box {

            position: relative;

        }


        .input-box input,
        .input-box select {

            width: 100%;

            height: 48px;

            padding: 0 14px;

            border: 1px solid #d6deea;

            border-radius: 9px;

            outline: none;

            font-size: 14px;

            color: #0f172a;

            background: #ffffff;

            transition: 0.2s;

        }


        .input-box input::placeholder {

            color: #94a3b8;

        }


        .input-box input:focus,
        .input-box select:focus {

            border-color: #1765e8;

            box-shadow:
                0 0 0 3px rgba(23, 101, 232, 0.10);

        }


        /* ================= PASSWORD INPUT ================= */

        .password-input {

            padding-right: 48px !important;

        }


        .eye-button {

            position: absolute;

            right: 14px;

            top: 50%;

            transform: translateY(-50%);

            border: none;

            background: transparent;

            cursor: pointer;

            font-size: 17px;

            color: #64748b;

        }


        .eye-button:hover {

            color: #1765e8;

        }


        /* ================= PASSWORD ERROR ================= */

        .error-message {

            display: none;

            color: #dc2626;

            font-size: 13px;

            margin-top: 5px;

        }


        /* ================= REGISTER BUTTON ================= */

        .register-button {

            width: 100%;

            height: 50px;

            margin-top: 7px;

            border: none;

            border-radius: 9px;

            background: #1765e8;

            color: white;

            font-size: 16px;

            font-weight: 700;

            cursor: pointer;

            transition: 0.2s;

        }


        .register-button:hover {

            background: #0d4bc0;

            transform: translateY(-1px);

            box-shadow:
                0 6px 15px rgba(23, 101, 232, 0.25);

        }


        .register-button:active {

            transform: translateY(0);

        }


        /* ================= LOGIN LINK ================= */

        .login-text {

            text-align: center;

            margin-top: 22px;

            padding-top: 20px;

            border-top: 1px solid #e2e8f0;

            color: #64748b;

            font-size: 14px;

        }


        .login-text a {

            color: #1765e8;

            text-decoration: none;

            font-weight: 600;

        }


        .login-text a:hover {

            text-decoration: underline;

        }


        /* ================= MOBILE ================= */

        @media (max-width: 500px) {

            body {

                padding: 18px;

            }


            .signup-card {

                width: 100%;

                padding: 35px 25px 30px;

                border-radius: 15px;

            }


            .signup-card h1 {

                font-size: 27px;

            }


            .subtitle {

                font-size: 14px;

                margin-bottom: 25px;

            }

        }


        /* ================= FINAL OVERSCROLL FIX ================= */
        html,
        body {
            overscroll-behavior: none;
        }

    </style>

</head>


<body>


    <!-- ================= SIGNUP CARD ================= -->

    <div class="signup-card">


        <!-- HEADING -->

        <h1>
            Create Account
        </h1>


        <p class="subtitle">
            Join our e-auction platform
        </p>


        <!-- ALERT NOTIFICATION -->
        <div id="alertMessage" style="display: none; padding: 12px; border-radius: 8px; font-size: 14px; margin-bottom: 20px; text-align: center;"></div>

        <!-- ================= REGISTRATION FORM ================= -->

        <form
            action="signup"
            method="post"
            onsubmit="return validateForm()"
        >


            <!-- FULL NAME -->

            <div class="form-group">

                <label for="name">
                    Full Name
                </label>

                <div class="input-box">

                    <input
                        type="text"
                        id="name"
                        name="name"
                        placeholder="Enter your full name"
                        required
                    >

                </div>

            </div>

            <!-- EMAIL -->

            <div class="form-group">

                <label for="email">
                    Email
                </label>

                <div class="input-box">

                    <input
                        type="email"
                        id="email"
                        name="email"
                        placeholder="Enter your email"
                        required
                    >

                </div>

            </div>

            <!-- PHONE NUMBER -->

            <div class="form-group">

                <label for="phoneNo">
                    Phone Number
                </label>

                <div class="input-box">

                    <input
                        type="tel"
                        id="phoneNo"
                        name="phoneNo"
                        placeholder="Enter phone number"
                        required
                    >

                </div>

            </div>

            <!-- ADDRESS -->

            <div class="form-group">

                <label for="address">
                    Address
                </label>

                <div class="input-box">

                    <input
                        type="text"
                        id="address"
                        name="address"
                        placeholder="Enter your address"
                        required
                    >

                </div>

            </div>

            <!-- SECURITY QUESTION -->

            <div class="form-group">

                <label for="securityQuestion">
                    Security Question
                </label>

                <div class="input-box">

                    <select
                        id="securityQuestion"
                        name="securityQuestion"
                        required
                    >
                        <option value="">Select a Security Question</option>
                        <option value="What is your mother's maiden name?">What is your mother's maiden name?</option>
                        <option value="What was the name of your first pet?">What was the name of your first pet?</option>
                        <option value="What city were you born in?">What city were you born in?</option>
                        <option value="What is your favorite book?">What is your favorite book?</option>
                    </select>

                </div>

            </div>

            <!-- SECURITY ANSWER -->

            <div class="form-group">

                <label for="securityAnswer">
                    Security Answer
                </label>

                <div class="input-box">

                    <input
                        type="text"
                        id="securityAnswer"
                        name="securityAnswer"
                        placeholder="Enter security answer"
                        required
                    >

                </div>

            </div>


            <!-- PASSWORD -->

            <div class="form-group">

                <label for="password">
                    Password
                </label>

                <div class="input-box">

                    <input
                        type="password"
                        id="password"
                        name="password"
                        class="password-input"
                        placeholder="Create a password"
                        required
                    >

                    <button
                        type="button"
                        class="eye-button"
                        onclick="togglePassword('password', 'eye1')"
                        id="eye1"
                    >
                        👁
                    </button>

                </div>

            </div>


            <!-- CONFIRM PASSWORD -->

            <div class="form-group">

                <label for="confirmPassword">
                    Confirm Password
                </label>

                <div class="input-box">

                    <input
                        type="password"
                        id="confirmPassword"
                        name="confirmPassword"
                        class="password-input"
                        placeholder="Confirm your password"
                        required
                    >

                    <button
                        type="button"
                        class="eye-button"
                        onclick="togglePassword('confirmPassword', 'eye2')"
                        id="eye2"
                    >
                        👁
                    </button>

                </div>


                <p
                    class="error-message"
                    id="passwordError"
                >
                    Passwords do not match.
                </p>

            </div>


            <!-- REGISTER BUTTON -->

            <button
                type="submit"
                class="register-button"
            >
                Register
            </button>


        </form>


        <!-- ================= LOGIN LINK ================= -->

        <p class="login-text">

            Already have an account?

            <a href="login.jsp">
                Login here
            </a>

        </p>


    </div>


    <!-- ================= JAVASCRIPT ================= -->

    <script>


        /* ================= SHOW / HIDE PASSWORD ================= */

        function togglePassword(inputId, buttonId) {

            const password =
                document.getElementById(inputId);

            const button =
                document.getElementById(buttonId);


            if (password.type === "password") {

                password.type = "text";

                button.textContent = "🙈";

            }

            else {

                password.type = "password";

                button.textContent = "👁";

            }

        }


        /* ================= PASSWORD MATCH ================= */

        function validateForm() {

            const password =
                document.getElementById("password").value;

            const confirmPassword =
                document.getElementById("confirmPassword").value;

            const error =
                document.getElementById("passwordError");


            if (password !== confirmPassword) {

                error.style.display = "block";

                return false;

            }


            error.style.display = "none";

            return true;

        }

        // Check for URL status parameters
        window.addEventListener("DOMContentLoaded", () => {
            const urlParams = new URLSearchParams(window.location.search);
            const alertBox = document.getElementById("alertMessage");

            if (urlParams.get("error") === "failed") {
                alertBox.style.display = "block";
                alertBox.style.background = "#fee2e2";
                alertBox.style.color = "#b91c1c";
                alertBox.style.border = "1px solid #fecaca";
                alertBox.textContent = "Registration failed. Email may already be in use or data invalid.";
            }
        });

    </script>


</body>

</html>
