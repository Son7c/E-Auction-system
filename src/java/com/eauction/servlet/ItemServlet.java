package com.eauction.servlet;

import com.eauction.dao.ItemDAO;
import com.eauction.form.ItemForm;
import com.eauction.form.UserForm;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

@WebServlet("/createItem")
public class ItemServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // Get existing session
        HttpSession session = request.getSession(false);

        // User must be logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get logged-in user safely
        Object userObj = session.getAttribute("user");
        if (!(userObj instanceof UserForm)) {
            response.sendRedirect("login.jsp");
            return;
        }
        UserForm user = (UserForm) userObj;

        // Create ItemForm
        ItemForm item = new ItemForm();

        // Seller comes from session
        item.setSellerId(user.getUserId());

        // Get item data from request
        item.setName(request.getParameter("name"));
        item.setDescription(request.getParameter("description"));
        item.setCategory(request.getParameter("category"));
        item.setImageUrl(request.getParameter("imageUrl"));

        // Send data to DAO
        ItemDAO itemDAO = new ItemDAO();

        boolean success = itemDAO.createItem(item);

        // Temporary testing response
        response.setContentType("text/html");

        if (success) {
            response.getWriter().println(
                    "<h1>Item Created Successfully!</h1>"
            );
        } else {
            response.getWriter().println(
                    "<h1>Item Creation Failed!</h1>"
            );
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        ItemDAO itemDAO = new ItemDAO();

        List<ItemForm> items = itemDAO.getAllItems();

        request.setAttribute("items", items);

        request.getRequestDispatcher("homepage.jsp")
        .forward(request, response);
    }
}
