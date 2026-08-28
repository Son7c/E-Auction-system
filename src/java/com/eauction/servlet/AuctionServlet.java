package com.eauction.servlet;

import com.eauction.form.AuctionForm;
import com.eauction.form.ItemForm;
import com.eauction.form.UserForm;
import com.eauction.service.AuctionService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/createAuction")
public class AuctionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        //Check session
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        UserForm user
                = (UserForm) session.getAttribute("user");

        // 3. Create ItemForm
        ItemForm item = new ItemForm();

        item.setSellerId(user.getUserId());
        item.setName(request.getParameter("name"));
        item.setDescription(request.getParameter("description"));
        item.setCategory(request.getParameter("category"));
        item.setImageUrl(request.getParameter("imageUrl"));

        // 4. Create AuctionForm
        AuctionForm auction = new AuctionForm();

        auction.setStartingBid(
                Double.parseDouble(
                        request.getParameter("startingBid")
                )
        );

        auction.setStartTime(
                Timestamp.valueOf(
                        request.getParameter("startTime").replace("T", " ") + ":00"
                )
        );

        auction.setEndTime(
                Timestamp.valueOf(
                        request.getParameter("endTime").replace("T", " ") + ":00"
                )
        );

        AuctionService auctionService
                = new AuctionService();

        boolean success
                = auctionService.createItemWithAuction(
                        item,
                        auction
                );

        response.setContentType("text/html");

        if (success) {
            response.getWriter().println(
                    "<h1>Item and Auction Created Successfully!</h1>"
            );
        } else {
            response.getWriter().println(
                    "<h1>Creation Failed!</h1>"
            );
        }
    }
}
