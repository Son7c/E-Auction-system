package com.eauction.servlet;

import com.eauction.dao.UserDAO;
import com.eauction.form.UserForm;
import com.eauction.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ResetPassword")
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("forgetpassword.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String securityAnswer = request.getParameter("securityAnswer");
        String newPassword = request.getParameter("newPassword");
        if (newPassword == null) {
            newPassword = request.getParameter("password");
        }
        String confirmPassword = request.getParameter("confirmPassword");

        if (email == null || email.trim().isEmpty() ||
            securityAnswer == null || securityAnswer.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("forgetpassword.jsp").forward(request, response);
            return;
        }

        email = email.trim();
        securityAnswer = securityAnswer.trim();

        if (confirmPassword != null && !newPassword.equals(confirmPassword)) {
            UserDAO userDAO = new UserDAO();
            UserForm user = userDAO.getUserByEmail(email);
            if (user != null) {
                request.setAttribute("securityQuestion", user.getSecurityQuestion());
            }
            request.setAttribute("email", email);
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("security-question.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        UserForm user = userDAO.getUserByEmail(email);

        if (user == null) {
            response.sendRedirect("forgetpassword.jsp?error=notfound");
            return;
        }

        // Verify security answer against stored hash
        boolean isAnswerCorrect = false;
        if (user.getSecurityAnswer() != null) {
            isAnswerCorrect = PasswordUtil.verify(securityAnswer, user.getSecurityAnswer());
            if (!isAnswerCorrect) {
                // Also check if non-trimmed was used or case differences if applicable
                isAnswerCorrect = PasswordUtil.verify(request.getParameter("securityAnswer"), user.getSecurityAnswer());
            }
        }

        if (isAnswerCorrect) {
            boolean updated = userDAO.updatePassword(email, newPassword);
            if (updated) {
                response.sendRedirect("login.jsp?reset=true");
            } else {
                request.setAttribute("email", email);
                request.setAttribute("securityQuestion", user.getSecurityQuestion());
                request.setAttribute("error", "Failed to update password. Please try again.");
                request.getRequestDispatcher("security-question.jsp").forward(request, response);
            }
        } else {
            // Incorrect security answer
            request.setAttribute("email", email);
            request.setAttribute("securityQuestion", user.getSecurityQuestion());
            request.setAttribute("userName", user.getName());
            request.setAttribute("error", "Incorrect security answer. Please try again.");
            request.getRequestDispatcher("security-question.jsp").forward(request, response);
        }
    }
}
