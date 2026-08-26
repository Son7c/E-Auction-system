package com.eauction.servlet;

import com.eauction.dao.UserDAO;
import com.eauction.form.UserForm;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/signup")
public class SignUpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Create UserForm object
        UserForm user = new UserForm();

        // 2. Get data from HTML form (supports both 'name' and 'fullName')
        String name = request.getParameter("name");
        if (name == null || name.trim().isEmpty()) {
            name = request.getParameter("fullName");
        }
        user.setName(name);
        user.setEmail(request.getParameter("email"));
        user.setPassword(request.getParameter("password"));
        user.setPhoneNo(request.getParameter("phoneNo"));
        user.setAddress(request.getParameter("address"));
        user.setSecurityQuestion(
                request.getParameter("securityQuestion")
        );
        user.setSecurityAnswer(
                request.getParameter("securityAnswer")
        );

        // 3. Send data to DAO
        UserDAO userDAO = new UserDAO();

        boolean success = userDAO.registerUser(user);

        // 4. Decide what to do after registration
        if (success) {
            response.sendRedirect("login.jsp?registered=true");
        } else {
            response.sendRedirect("signup.jsp?error=failed");
        }
    }
}