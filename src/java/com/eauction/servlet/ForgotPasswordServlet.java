package com.eauction.servlet;

import com.eauction.dao.UserDAO;
import com.eauction.form.UserForm;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ForgotPassword")
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("forgetpassword.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect("forgetpassword.jsp?error=empty");
            return;
        }

        email = email.trim();
        UserDAO userDAO = new UserDAO();
        UserForm user = userDAO.getUserByEmail(email);

        if (user != null && user.getSecurityQuestion() != null && !user.getSecurityQuestion().trim().isEmpty()) {
            // Set user attributes for the security question page
            request.setAttribute("email", user.getEmail());
            request.setAttribute("securityQuestion", user.getSecurityQuestion());
            request.setAttribute("userName", user.getName());

            // Forward to the security question JSP
            request.getRequestDispatcher("security-question.jsp").forward(request, response);
        } else {
            // User not found or security question not configured
            response.sendRedirect("forgetpassword.jsp?error=notfound");
        }
    }
}
