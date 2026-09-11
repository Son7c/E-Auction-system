package com.eauction.servlet;

import com.eauction.form.UserForm;
import com.eauction.service.BidService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/placeBid")
public class BidServlet extends HttpServlet {

    private final BidService bidService = new BidService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String auctionIdStr = request.getParameter("auctionId");

        if (auctionIdStr == null || auctionIdStr.trim().isEmpty()) {
            response.sendRedirect("bidding.jsp");
            return;
        }

        int auctionId;
        try {
            auctionId = Integer.parseInt(auctionIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect("bidding.jsp");
            return;
        }

        if (session == null || !(session.getAttribute("user") instanceof UserForm)) {
            response.sendRedirect("login.jsp");
            return;
        }

        UserForm user = (UserForm) session.getAttribute("user");

        String bidAmountStr = request.getParameter("bidAmount");
        if (bidAmountStr == null || bidAmountStr.trim().isEmpty()) {
            String errorMsg = URLEncoder.encode("Please enter a valid bid amount.", StandardCharsets.UTF_8);
            response.sendRedirect("bid.jsp?auctionId=" + auctionId + "&error=" + errorMsg);
            return;
        }

        double bidAmount;
        try {
            bidAmount = Double.parseDouble(bidAmountStr.trim());
            if (bidAmount <= 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            String errorMsg = URLEncoder.encode("Bid amount must be a positive number.", StandardCharsets.UTF_8);
            response.sendRedirect("bid.jsp?auctionId=" + auctionId + "&error=" + errorMsg);
            return;
        }

        String result = bidService.validateAndPlaceBid(auctionId, user.getUserId(), bidAmount);

        if ("SUCCESS".equals(result)) {
            response.sendRedirect("bid.jsp?auctionId=" + auctionId + "&success=true");
        } else {
            String errorMsg = URLEncoder.encode(result, StandardCharsets.UTF_8);
            response.sendRedirect("bid.jsp?auctionId=" + auctionId + "&error=" + errorMsg);
        }
    }
}
