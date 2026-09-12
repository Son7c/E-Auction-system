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
import java.util.List;

@WebServlet(urlPatterns = {"/createAuction", "/getAllAuctions"})
public class AuctionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        AuctionService auctionService = new AuctionService();
        List<AuctionForm> auctions = auctionService.getAllAuctions();

        StringBuilder sb = new StringBuilder();
        sb.append("[");
        for (int i = 0; i < auctions.size(); i++) {
            AuctionForm a = auctions.get(i);
            sb.append("{");
            sb.append("\"auctionId\":").append(a.getAuctionId()).append(",");
            sb.append("\"itemId\":").append(a.getItemId()).append(",");
            sb.append("\"startingBid\":").append(a.getStartingBid()).append(",");
            sb.append("\"highestBid\":").append(a.getHighestBid()).append(",");
            sb.append("\"startTime\":").append(escapeJson(a.getStartTime() != null ? a.getStartTime().toString() : "")).append(",");
            sb.append("\"endTime\":").append(escapeJson(a.getEndTime() != null ? a.getEndTime().toString() : "")).append(",");
            sb.append("\"status\":").append(escapeJson(a.getStatus())).append(",");
            sb.append("\"sellerId\":").append(a.getSellerId()).append(",");
            sb.append("\"sellerName\":").append(escapeJson(a.getSellerName())).append(",");
            sb.append("\"name\":").append(escapeJson(a.getName())).append(",");
            sb.append("\"description\":").append(escapeJson(a.getDescription())).append(",");
            sb.append("\"category\":").append(escapeJson(a.getCategory())).append(",");
            sb.append("\"imageUrl\":").append(escapeJson(a.getImageUrl()));
            sb.append("}");
            if (i < auctions.size() - 1) {
                sb.append(",");
            }
        }
        sb.append("]");

        response.getWriter().write(sb.toString());
    }

    private String escapeJson(String input) {
        if (input == null) {
            return "null";
        }
        return "\"" + input.replace("\\", "\\\\")
                           .replace("\"", "\\\"")
                           .replace("\b", "\\b")
                           .replace("\f", "\\f")
                           .replace("\n", "\\n")
                           .replace("\r", "\\r")
                           .replace("\t", "\\t") + "\"";
    }

    @Override
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

        if (success) {
            response.sendRedirect("bidding.jsp?created=success");
        } else {
            response.sendRedirect("create-auction.jsp?error=failed");
        }
    }
}
