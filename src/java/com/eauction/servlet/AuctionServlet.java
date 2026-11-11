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

        HttpSession session = request.getSession(false);
        UserForm user = (session != null && session.getAttribute("user") instanceof UserForm)
                ? (UserForm) session.getAttribute("user") : null;
        boolean isAdmin = com.eauction.util.AdminConfig.isAdmin(user);

        String scope = request.getParameter("scope");
        List<AuctionForm> auctions;
        if ("all".equalsIgnoreCase(scope) && isAdmin) {
            auctions = auctionService.getAllAuctions();
        } else {
            auctions = auctionService.getApprovedAuctions();
        }

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

    private Timestamp parseTimestamp(String input) {
        if (input == null || input.trim().isEmpty()) {
            return null;
        }
        String clean = input.trim().replace("T", " ");
        if (clean.length() == 16) {
            clean += ":00";
        }
        return Timestamp.valueOf(clean);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Check session
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        UserForm user = (UserForm) session.getAttribute("user");

        // Ensure user has valid ID from database
        int sellerId = user.getUserId();
        if (sellerId <= 0 && user.getEmail() != null) {
            com.eauction.dao.UserDAO userDAO = new com.eauction.dao.UserDAO();
            UserForm dbUser = userDAO.getUserByEmail(user.getEmail());
            if (dbUser != null) {
                sellerId = dbUser.getUserId();
                user.setUserId(sellerId);
                session.setAttribute("user", user);
            }
        }

        if (sellerId <= 0) {
            response.sendRedirect("create-auction.jsp?error=invalid_user");
            return;
        }

        try {
            // 3. Create ItemForm
            ItemForm item = new ItemForm();
            item.setSellerId(sellerId);
            item.setName(request.getParameter("name"));
            item.setDescription(request.getParameter("description"));
            item.setCategory(request.getParameter("category"));
            item.setImageUrl(request.getParameter("imageUrl"));

            // 4. Create AuctionForm
            AuctionForm auction = new AuctionForm();

            String startingBidParam = request.getParameter("startingBid");
            if (startingBidParam == null || startingBidParam.trim().isEmpty()) {
                response.sendRedirect("create-auction.jsp?error=price");
                return;
            }
            auction.setStartingBid(Double.parseDouble(startingBidParam.trim()));

            Timestamp startTime = parseTimestamp(request.getParameter("startTime"));
            Timestamp endTime = parseTimestamp(request.getParameter("endTime"));

            if (startTime == null || endTime == null) {
                response.sendRedirect("create-auction.jsp?error=date");
                return;
            }

            auction.setStartTime(startTime);
            auction.setEndTime(endTime);

            // Every new auction listing starts with PENDING status for moderation
            auction.setStatus("PENDING");

            AuctionService auctionService = new AuctionService();
            boolean success = auctionService.createItemWithAuction(item, auction);

            boolean userIsAdmin = com.eauction.util.AdminConfig.isAdmin(user);

            if (success) {
                if (userIsAdmin) {
                    response.sendRedirect("admin-dashboard.jsp?action=created&status=PENDING");
                } else {
                    response.sendRedirect("dashboard.jsp?listing=pending");
                }
            } else {
                response.sendRedirect("create-auction.jsp?error=failed");
            }
        } catch (NumberFormatException e) {
            System.err.println("AuctionServlet NumberFormatException: " + e.getMessage());
            response.sendRedirect("create-auction.jsp?error=price");
        } catch (IllegalArgumentException e) {
            System.err.println("AuctionServlet IllegalArgumentException: " + e.getMessage());
            response.sendRedirect("create-auction.jsp?error=date");
        } catch (Exception e) {
            System.err.println("AuctionServlet unexpected error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("create-auction.jsp?error=" + java.net.URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "failed", "UTF-8"));
        }
    }
}
