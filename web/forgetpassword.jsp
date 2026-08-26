<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>E-Auction | Forgot Password</title>


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

            background: #06152b;

            overscroll-behavior: none;

            scroll-behavior: smooth;
        }


        body {

            width: 100%;

            min-height: 100vh;

            min-height: 100dvh;

            margin: 0;

            padding: 0;

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


        /* ================= CARD ================= */

        .forgot-card {

            width: 420px;

            background: white;

            padding: 42px 45px 38px;

            border-radius: 18px;

            border: 1px solid #e5eaf2;

            box-shadow:
                0 15px 40px rgba(15, 23, 42, 0.12);

        }


        /* ================= BACK TO LOGIN ================= */

        .back-login {

            display: inline-flex;

            align-items: center;

            gap: 6px;

            color: #64748b;

            text-decoration: none;

            font-size: 14px;

            margin-bottom: 28px;

            transition: 0.2s;

        }


        .back-login:hover {

            color: #1765e8;

        }


        /* ================= HEADING ================= */

        .forgot-card h1 {

            font-size: 30px;

            font-weight: 700;

            color: #0f172a;

            margin-bottom: 10px;

        }


        .description {

            color: #64748b;

            font-size: 15px;

            line-height: 1.6;

            margin-bottom: 30px;

        }


        /* ================= FORM ================= */

        .form-group {

            margin-bottom: 22px;

        }


        .form-group label {

            display: block;

            font-size: 14px;

            font-weight: 600;

            color: #1e293b;

            margin-bottom: 8px;

        }


        .form-group input {

            width: 100%;

            height: 52px;

            padding: 0 15px;

            border: 1px solid #d6deea;

            border-radius: 9px;

            outline: none;

            font-size: 15px;

            color: #0f172a;

            background: #ffffff;

            transition: 0.2s;

        }


        .form-group input::placeholder {

            color: #94a3b8;

        }


        .form-group input:focus {

            border-color: #1765e8;

            box-shadow:
                0 0 0 3px rgba(23, 101, 232, 0.10);

        }


        /* ================= RESET BUTTON ================= */

        .reset-button {

            width: 100%;

            height: 52px;

            border: none;

            border-radius: 9px;

            background: #1765e8;

            color: white;

            font-size: 16px;

            font-weight: 700;

            cursor: pointer;

            transition: 0.2s;

        }


        .reset-button:hover {

            background: #0d4bc0;

            transform: translateY(-1px);

            box-shadow:
                0 6px 15px rgba(23, 101, 232, 0.25);

        }


        .reset-button:active {

            transform: translateY(0);

        }


        /* ================= LOGIN LINK ================= */

        .login-text {

            text-align: center;

            margin-top: 25px;

            padding-top: 22px;

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

                padding: 20px;

            }


            .forgot-card {

                width: 100%;

                padding: 35px 25px 30px;

            }


            .forgot-card h1 {

                font-size: 27px;

            }

        }

    </style>

</head>


<body>


    <!-- ================= FORGOT PASSWORD CARD ================= -->

    <div class="forgot-card">


        <!-- BACK TO LOGIN -->

        <a
            href="login.jsp"
            class="back-login"
        >

            ← Back to Login

        </a>


        <!-- HEADING -->

        <h1>
            Forgot Password?
        </h1>


        <p class="description">

            Don't worry. Enter the email address
            associated with your account and we'll
            send you a link to reset your password.

        </p>


        <!-- FORM -->

        <form
            action="#"
            method="post"
        >


            <div class="form-group">

                <label for="email">
                    Email Address
                </label>


                <input
                    type="email"
                    id="email"
                    name="email"
                    placeholder="Enter your email address"
                    required
                >

            </div>


            <!-- RESET BUTTON -->

            <button
                type="submit"
                class="reset-button"
            >

                Send Reset Link

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

</body>

</html>
