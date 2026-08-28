package com.eauction.servlet;

import com.eauction.dao.UserDAO;
import com.eauction.form.LoginForm;
import com.eauction.form.UserForm;
import com.eauction.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Create LoginForm
        LoginForm loginForm = new LoginForm();

        // 2. Get login data from form (supports both 'email' and 'username' form input names)
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            email = request.getParameter("username");
        }
        loginForm.setEmail(email);
        loginForm.setPassword(request.getParameter("password"));

        // 3. Fetch user from database
        UserDAO userDAO = new UserDAO();

        UserForm user = (loginForm.getEmail() != null) ? userDAO.getUserByEmail(loginForm.getEmail()) : null;

        // 4. Verify password
        if (user != null &&
                loginForm.getPassword() != null &&
                PasswordUtil.verify(
                        loginForm.getPassword(),
                        user.getPassword())) {

            // 5. Create session & redirect to homepage
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            response.sendRedirect("homepage.jsp");

        } else {
            // Redirect back with error query parameter
            response.sendRedirect("login.jsp?error=invalid");
        }
    }
}