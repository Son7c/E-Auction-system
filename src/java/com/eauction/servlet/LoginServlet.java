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

        // 2. Get login data from form
        loginForm.setEmail(request.getParameter("email"));
        loginForm.setPassword(request.getParameter("password"));

        // 3. Fetch user from database
        UserDAO userDAO = new UserDAO();

        UserForm user = userDAO.getUserByEmail(
                loginForm.getEmail()
        );

        // 4. Verify password
        if (user != null &&
                PasswordUtil.verify(
                        loginForm.getPassword(),
                        user.getPassword())) {

            // 5. Create session
            HttpSession session = request.getSession();

            session.setAttribute("user", user);

            // Temporary testing response
            response.setContentType("text/html");
            response.getWriter().println(
                    "<h1>Login Successful!</h1>"
            );
            response.getWriter().println(
                    "<p>Welcome, " + user.getName() + "</p>"
            );

        } else {

            // Temporary testing response
            response.setContentType("text/html");
            response.getWriter().println(
                    "<h1>Invalid email or password!</h1>"
            );
        }
    }
}