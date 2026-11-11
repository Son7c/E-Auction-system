package com.eauction.servlet;

import com.eauction.form.UserForm;
import com.eauction.service.AuctionService;
import com.eauction.util.AdminConfig;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(urlPatterns = {"/moderateAuction", "/admin/moderate"})
public class AdminServlet extends HttpServlet {

    private final AuctionService auctionService = new AuctionService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        UserForm user = (session != null && session.getAttribute("user") instanceof UserForm)
                ? (UserForm) session.getAttribute("user") : null;

        boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                || (request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json"));

        if (!AdminConfig.isAdmin(user)) {
            if (isAjax) {
                response.setContentType("application/json;charset=UTF-8");
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"success\":false,\"message\":\"Admin authorization required.\"}");
            } else {
                response.sendRedirect("login.jsp?error=unauthorized");
            }
            return;
        }

        String auctionIdStr = request.getParameter("auctionId");
        String action = request.getParameter("action");

        if (auctionIdStr == null || action == null) {
            if (isAjax) {
                response.setContentType("application/json;charset=UTF-8");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\":false,\"message\":\"Missing auctionId or action.\"}");
            } else {
                response.sendRedirect("admin-dashboard.jsp?error=invalid_params");
            }
            return;
        }

        int auctionId;
        try {
            auctionId = Integer.parseInt(auctionIdStr.trim());
        } catch (NumberFormatException e) {
            if (isAjax) {
                response.setContentType("application/json;charset=UTF-8");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\":false,\"message\":\"Invalid auction ID.\"}");
            } else {
                response.sendRedirect("admin-dashboard.jsp?error=invalid_id");
            }
            return;
        }

        com.eauction.form.AuctionForm existingAuction = auctionService.getAuctionById(auctionId);
        if (existingAuction == null) {
            if (isAjax) {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":false,\"message\":\"Auction #" + auctionId + " not found.\"}");
            } else {
                response.sendRedirect("admin-dashboard.jsp?error=not_found");
            }
            return;
        }

        String normAction = action.toLowerCase().trim();

        // Completed auctions cannot be approved or rejected
        if (existingAuction.isCompleted()) {
            if ("approve".equals(normAction) || "confirm".equals(normAction) || "reject".equals(normAction) || "pending".equals(normAction)) {
                String lockMsg = "Auction #" + auctionId + " is COMPLETED and closed. Its status is finalized and cannot be modified as approved or rejected.";
                if (isAjax) {
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"success\":false,\"message\":\"" + lockMsg + "\"}");
                } else {
                    response.sendRedirect("admin-dashboard.jsp?error=completed_locked");
                }
                return;
            }
        }

        boolean success = false;
        String newStatus = "";
        String errorMessage = null;

        switch (normAction) {
            case "approve":
            case "confirm":
                newStatus = "APPROVED";
                errorMessage = auctionService.updateAuctionStatusWithDetail(auctionId, "APPROVED");
                success = (errorMessage == null);
                break;
            case "reject":
                newStatus = "REJECTED";
                errorMessage = auctionService.updateAuctionStatusWithDetail(auctionId, "REJECTED");
                success = (errorMessage == null);
                break;
            case "pending":
                newStatus = "PENDING";
                errorMessage = auctionService.updateAuctionStatusWithDetail(auctionId, "PENDING");
                success = (errorMessage == null);
                break;
            case "complete":
            case "completed":
                newStatus = "COMPLETED";
                errorMessage = auctionService.updateAuctionStatusWithDetail(auctionId, "COMPLETED");
                success = (errorMessage == null);
                break;
            case "delete":
                newStatus = "DELETED";
                success = auctionService.deleteAuction(auctionId);
                if (!success) {
                    errorMessage = "Failed to delete auction #" + auctionId;
                }
                break;
            default:
                errorMessage = "Unknown action: " + action;
                break;
        }

        if (isAjax) {
            response.setContentType("application/json;charset=UTF-8");
            if (success) {
                response.getWriter().write("{\"success\":true,\"auctionId\":" + auctionId
                        + ",\"action\":\"" + action + "\",\"newStatus\":\"" + newStatus + "\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_OK);
                String safeMsg = (errorMessage != null)
                        ? errorMessage.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ")
                        : "Database update failed.";
                response.getWriter().write("{\"success\":false,\"message\":\"" + safeMsg + "\"}");
            }
        } else {
            if (success) {
                response.sendRedirect("admin-dashboard.jsp?action=" + action + "&status=" + newStatus);
            } else {
                response.sendRedirect("admin-dashboard.jsp?error=action_failed");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward GET requests to the Admin Dashboard
        response.sendRedirect("admin-dashboard.jsp");
    }
}

