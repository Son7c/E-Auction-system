package com.eauction.service;

import com.eauction.dao.AuctionDAO;
import com.eauction.dao.BidDAO;
import com.eauction.form.AuctionForm;
import com.eauction.form.BidForm;

import java.sql.Timestamp;
import java.util.List;

public class BidService {

    private final BidDAO bidDAO = new BidDAO();
    private final AuctionDAO auctionDAO = new AuctionDAO();

    public String validateAndPlaceBid(int auctionId, int bidderId, double bidAmount) {
        AuctionForm auction = auctionDAO.getAuctionById(auctionId);
        if (auction == null) {
            return "Auction does not exist.";
        }

        if (auction.getSellerId() == bidderId) {
            return "You cannot bid on your own auction.";
        }

        long now = System.currentTimeMillis();
        long start = auction.getStartTime() != null ? auction.getStartTime().getTime() : 0;
        long end = auction.getEndTime() != null ? auction.getEndTime().getTime() : Long.MAX_VALUE;

        if (now < start) {
            return "This auction has not started yet.";
        }

        if (now > end) {
            return "This auction has already ended.";
        }

        double currentHighest = auction.getHighestBid();
        double startingBid = auction.getStartingBid();

        if (currentHighest > 0) {
            if (bidAmount <= currentHighest) {
                return String.format("Bid must be strictly higher than the current highest bid (₹%,.2f).", currentHighest);
            }
        } else {
            if (bidAmount < startingBid) {
                return String.format("Bid must be at least the starting price (₹%,.2f).", startingBid);
            }
        }

        BidForm bid = new BidForm(bidderId, auctionId, bidAmount, new Timestamp(now));
        boolean success = bidDAO.placeBid(bid);
        if (success) {
            return "SUCCESS";
        } else {
            return "Failed to record your bid due to a database error. Please try again.";
        }
    }

    public List<BidForm> getBidsForAuction(int auctionId) {
        return bidDAO.getBidsByAuctionId(auctionId);
    }

    public int getBidCount(int auctionId) {
        return bidDAO.getBidCount(auctionId);
    }

    public List<com.eauction.form.UserBidSummary> getUserBiddingSummary(int userId) {
        return bidDAO.getUserBiddingSummary(userId);
    }
}
