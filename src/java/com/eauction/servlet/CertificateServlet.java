package com.eauction.servlet;

import com.eauction.dao.AuctionDAO;
import com.eauction.dao.BidDAO;
import com.eauction.dao.UserDAO;
import com.eauction.form.AuctionForm;
import com.eauction.form.BidForm;
import com.eauction.form.UserForm;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet({"/certificate", "/CertificateServlet"})
public class CertificateServlet extends HttpServlet {

    private final AuctionDAO auctionDAO = new AuctionDAO();
    private final BidDAO bidDAO = new BidDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        UserForm currentUser = (session != null) ? (UserForm) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String auctionIdParam = request.getParameter("auctionId");
        if (auctionIdParam == null || auctionIdParam.trim().isEmpty()) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        int auctionId;
        try {
            auctionId = Integer.parseInt(auctionIdParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        AuctionForm auction = auctionDAO.getAuctionById(auctionId);
        if (auction == null) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        long now = System.currentTimeMillis();
        boolean isClosed = (auction.getEndTime() != null && now >= auction.getEndTime().getTime())
                || "COMPLETED".equalsIgnoreCase(auction.getStatus());

        if (!isClosed) {
            request.setAttribute("errorMessage", "Certificate cannot be generated: This auction is still active or upcoming.");
            request.getRequestDispatcher("bid.jsp?auctionId=" + auctionId).forward(request, response);
            return;
        }

        List<BidForm> bids = bidDAO.getBidsByAuctionId(auctionId);
        if (bids == null || bids.isEmpty()) {
            request.setAttribute("errorMessage", "This auction concluded with no winning bids placed.");
            request.getRequestDispatcher("bid.jsp?auctionId=" + auctionId).forward(request, response);
            return;
        }

        BidForm winningBid = bids.get(0);

        boolean isWinner = (currentUser.getUserId() == winningBid.getBidderId());
        boolean isSeller = (currentUser.getUserId() == auction.getSellerId());

        if (!isWinner && !isSeller) {
            request.setAttribute("errorMessage", "Access Restricted: You are neither the winning bidder nor the seller of this auction.");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            return;
        }

        UserForm buyer = userDAO.getUserById(winningBid.getBidderId());
        if (buyer == null) {
            buyer = new UserForm();
            buyer.setUserId(winningBid.getBidderId());
            buyer.setName(winningBid.getBidderName() != null ? winningBid.getBidderName() : "Bidder #" + winningBid.getBidderId());
            buyer.setEmail("N/A");
            buyer.setAddress("Registered E-Auction Account");
        }

        UserForm seller = userDAO.getUserById(auction.getSellerId());
        if (seller == null) {
            seller = new UserForm();
            seller.setUserId(auction.getSellerId());
            seller.setName(auction.getSellerName() != null ? auction.getSellerName() : "Seller #" + auction.getSellerId());
            seller.setEmail("N/A");
            seller.setAddress("Registered E-Auction Seller");
        }

        String certNumber = String.format("EAC-%04d-%04d-%06X",
                auction.getAuctionId(),
                winningBid.getBidId(),
                Math.abs((auction.getName() + winningBid.getBidAmount()).hashCode() % 0xFFFFFF));

        SimpleDateFormat sdf = new SimpleDateFormat("MMMM dd, yyyy 'at' hh:mm a");
        String completionDate = (auction.getEndTime() != null)
                ? sdf.format(auction.getEndTime())
                : sdf.format(new java.util.Date());

        request.setAttribute("auction", auction);
        request.setAttribute("winningBid", winningBid);
        request.setAttribute("buyer", buyer);
        request.setAttribute("seller", seller);
        request.setAttribute("isWinner", isWinner);
        request.setAttribute("isSeller", isSeller);
        request.setAttribute("currentUser", currentUser);
        request.setAttribute("certNumber", certNumber);
        request.setAttribute("completionDate", completionDate);
        request.setAttribute("totalBids", bids.size());

        request.getRequestDispatcher("certificate.jsp").forward(request, response);
    }
}
