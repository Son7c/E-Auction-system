<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String email = (String) request.getAttribute("email");
    if (email == null) {
        email = request.getParameter("email");
    }

    String securityQuestion = (String) request.getAttribute("securityQuestion");
    if (securityQuestion == null) {
        securityQuestion = request.getParameter("securityQuestion");
    }

    String errorMessage = (String) request.getAttribute("error");
    if (errorMessage == null) {
        String errorParam = request.getParameter("error");
        if ("invalid_answer".equals(errorParam)) {
            errorMessage = "Incorrect security answer. Please try again.";
        } else if ("mismatch".equals(errorParam)) {
            errorMessage = "Passwords do not match.";
        }
    }

    // If accessed directly without an email or question, redirect to forgot password
    if ((email == null || email.trim().isEmpty()) && (securityQuestion == null || securityQuestion.trim().isEmpty())) {
        response.sendRedirect("forgetpassword.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>E-Auction | Security Verification</title>


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
            scroll-behavior: smooth;
        }


        body {
            width: 100%;
            min-height: 100vh;
            min-height: 100dvh;
            margin: 0;
            padding: 25px;
            font-family: Arial, Helvetica, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(
                135deg,
                #f4f8ff,
                #eaf2ff
            );
            color: #0f172a;
            overflow-x: hidden;
            overscroll-behavior: none;
        }

        html::before {
            content: "";
            position: fixed;
            inset: 0;
            background: #eaf2ff;
            z-index: -9999;
            pointer-events: none;
        }


        /* ================= CARD ================= */

        .security-card {
            width: 440px;
            background: #ffffff;
            padding: 42px 45px 38px;
            border-radius: 18px;
            border: 1px solid #e5eaf2;
            box-shadow:
                0 15px 40px rgba(15, 23, 42, 0.12);
        }


        /* ================= BACK LINK ================= */

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #64748b;
            text-decoration: none;
            font-size: 14px;
            margin-bottom: 24px;
            transition: 0.2s;
        }

        .back-link:hover {
            color: #1765e8;
        }


        /* ================= HEADING ================= */

        .security-card h1 {
            font-size: 28px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 8px;
        }


        .description {
            color: #64748b;
            font-size: 14px;
            line-height: 1.5;
            margin-bottom: 22px;
        }


        /* ================= USER ACCOUNT BADGE ================= */

        .account-badge {
            display: flex;
            align-items: center;
            gap: 8px;
            background: #f1f5f9;
            border: 1px solid #e2e8f0;
            padding: 10px 14px;
            border-radius: 9px;
            margin-bottom: 20px;
            font-size: 13px;
            color: #475569;
            word-break: break-all;
        }

        .account-badge .badge-label {
            font-weight: 700;
            color: #334155;
            text-transform: uppercase;
            font-size: 11px;
            letter-spacing: 0.4px;
        }

        .account-badge .badge-email {
            color: #1765e8;
            font-weight: 600;
        }


        /* ================= QUESTION BOX ================= */

        .question-box {
            background: #f0f7ff;
            border: 1px solid #cbe0fe;
            border-left: 4px solid #1765e8;
            border-radius: 10px;
            padding: 14px 16px;
            margin-bottom: 22px;
        }

        .question-label {
            display: block;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #1765e8;
            margin-bottom: 6px;
        }

        .question-text {
            font-size: 15px;
            font-weight: 600;
            color: #0f172a;
            line-height: 1.45;
            margin: 0;
        }


        /* ================= ALERT NOTIFICATION ================= */

        .alert-box {
            padding: 12px;
            border-radius: 8px;
            font-size: 14px;
            margin-bottom: 20px;
            text-align: center;
            background: #fee2e2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }


        /* ================= FORM ================= */

        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 7px;
        }

        .input-box {
            position: relative;
        }

        .input-box input {
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

        .input-box input:focus {
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


        /* ================= ERROR MESSAGE ================= */

        .error-message {
            display: none;
            color: #dc2626;
            font-size: 13px;
            margin-top: 5px;
        }


        /* ================= SUBMIT BUTTON ================= */

        .submit-button {
            width: 100%;
            height: 50px;
            margin-top: 6px;
            border: none;
            border-radius: 9px;
            background: #1765e8;
            color: white;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.2s;
        }

        .submit-button:hover {
            background: #0d4bc0;
            transform: translateY(-1px);
            box-shadow:
                0 6px 15px rgba(23, 101, 232, 0.25);
        }

        .submit-button:active {
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

            .security-card {
                width: 100%;
                padding: 35px 25px 30px;
                border-radius: 15px;
            }

            .security-card h1 {
                font-size: 25px;
            }

            .description {
                font-size: 13px;
            }
        }

    </style>

</head>


<body>


    <!-- ================= SECURITY QUESTION CARD ================= -->

    <div class="security-card">


        <!-- BACK LINK -->

        <a
            href="forgetpassword.jsp"
            class="back-link"
        >
            ← Change Email
        </a>


        <!-- HEADING -->

        <h1>
            Security Verification
        </h1>

        <p class="description">
            Answer the security question associated with your account to set a new password.
        </p>


        <!-- ACCOUNT BADGE -->

        <% if (email != null && !email.trim().isEmpty()) { %>
        <div class="account-badge">
            <span class="badge-label">Email:</span>
            <span class="badge-email"><%= email %></span>
        </div>
        <% } %>


        <!-- DYNAMIC ERROR ALERT -->

        <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>
        <div class="alert-box">
            <%= errorMessage %>
        </div>
        <% } %>


        <!-- SECURITY QUESTION BOX -->

        <div class="question-box">
            <span class="question-label">Security Question</span>
            <p class="question-text">
                <%= (securityQuestion != null && !securityQuestion.trim().isEmpty()) ? securityQuestion : "Security question not found." %>
            </p>
        </div>


        <!-- RESET PASSWORD FORM -->

        <form
            action="ResetPassword"
            method="post"
            onsubmit="return validateForm()"
        >

            <!-- HIDDEN EMAIL -->
            <input
                type="hidden"
                name="email"
                value="<%= email != null ? email : "" %>"
            >


            <!-- SECURITY ANSWER -->

            <div class="form-group">

                <label for="securityAnswer">
                    Your Security Answer
                </label>

                <div class="input-box">

                    <input
                        type="text"
                        id="securityAnswer"
                        name="securityAnswer"
                        placeholder="Type your answer here"
                        required
                        autofocus
                    >

                </div>

            </div>


            <!-- NEW PASSWORD -->

            <div class="form-group">

                <label for="newPassword">
                    New Password
                </label>

                <div class="input-box">

                    <input
                        type="password"
                        id="newPassword"
                        name="newPassword"
                        class="password-input"
                        placeholder="Create a new password"
                        required
                    >

                    <button
                        type="button"
                        class="eye-button"
                        onclick="togglePassword('newPassword', 'eye1')"
                        id="eye1"
                    >
                        👁
                    </button>

                </div>

            </div>


            <!-- CONFIRM NEW PASSWORD -->

            <div class="form-group">

                <label for="confirmPassword">
                    Confirm New Password
                </label>

                <div class="input-box">

                    <input
                        type="password"
                        id="confirmPassword"
                        name="confirmPassword"
                        class="password-input"
                        placeholder="Confirm your new password"
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


            <!-- SUBMIT BUTTON -->

            <button
                type="submit"
                class="submit-button"
            >
                Reset Password
            </button>


        </form>


        <!-- LOGIN LINK -->

        <p class="login-text">
            Remember your password?
            <a href="login.jsp">
                Login here
            </a>
        </p>

    </div>


    <!-- ================= JAVASCRIPT ================= -->

    <script>

        /* ================= SHOW / HIDE PASSWORD ================= */

        function togglePassword(inputId, buttonId) {
            const password = document.getElementById(inputId);
            const button = document.getElementById(buttonId);

            if (password.type === "password") {
                password.type = "text";
                button.textContent = "🙈";
            } else {
                password.type = "password";
                button.textContent = "👁";
            }
        }


        /* ================= PASSWORD MATCH VALIDATION ================= */

        function validateForm() {
            const newPassword = document.getElementById("newPassword").value;
            const confirmPassword = document.getElementById("confirmPassword").value;
            const error = document.getElementById("passwordError");

            if (newPassword !== confirmPassword) {
                error.style.display = "block";
                return false;
            }

            error.style.display = "none";
            return true;
        }

    </script>

</body>

</html>
