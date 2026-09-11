package com.eauction.dao;

import com.eauction.form.BidForm;
import com.eauction.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BidDAO {

    public boolean placeBid(BidForm bid) {
        String insertSql = """
            INSERT INTO BIDS (BIDDER_ID, AUCTION_ID, BID_AMOUNT, BID_TIME)
            VALUES (?, ?, ?, ?)
            """;
        String updateAuctionSql = """
            UPDATE AUCTIONS
            SET HIGHEST_BID = ?
            WHERE AUCTION_ID = ?
            """;

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            try (PreparedStatement psInsert = con.prepareStatement(insertSql)) {
                psInsert.setInt(1, bid.getBidderId());
                psInsert.setInt(2, bid.getAuctionId());
                psInsert.setDouble(3, bid.getBidAmount());
                psInsert.setTimestamp(4, bid.getBidTime());
                int rows = psInsert.executeUpdate();
                if (rows == 0) {
                    con.rollback();
                    return false;
                }
            }

            try (PreparedStatement psUpdate = con.prepareStatement(updateAuctionSql)) {
                psUpdate.setDouble(1, bid.getBidAmount());
                psUpdate.setInt(2, bid.getAuctionId());
                int rows = psUpdate.executeUpdate();
                if (rows == 0) {
                    con.rollback();
                    return false;
                }
            }

            con.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public List<BidForm> getBidsByAuctionId(int auctionId) {
        List<BidForm> bids = new ArrayList<>();
        String sql = """
            SELECT b.BID_ID, b.BIDDER_ID, b.AUCTION_ID, b.BID_AMOUNT, b.BID_TIME, u.NAME AS BIDDER_NAME
            FROM BIDS b
            JOIN USERS u ON b.BIDDER_ID = u.USER_ID
            WHERE b.AUCTION_ID = ?
            ORDER BY b.BID_AMOUNT DESC, b.BID_TIME DESC
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, auctionId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BidForm bid = new BidForm();
                    bid.setBidId(rs.getInt("BID_ID"));
                    bid.setBidderId(rs.getInt("BIDDER_ID"));
                    bid.setAuctionId(rs.getInt("AUCTION_ID"));
                    bid.setBidAmount(rs.getDouble("BID_AMOUNT"));
                    bid.setBidTime(rs.getTimestamp("BID_TIME"));
                    bid.setBidderName(rs.getString("BIDDER_NAME"));
                    bids.add(bid);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bids;
    }

    public int getBidCount(int auctionId) {
        String sql = "SELECT COUNT(*) FROM BIDS WHERE AUCTION_ID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, auctionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<com.eauction.form.UserBidSummary> getUserBiddingSummary(int userId) {
        List<com.eauction.form.UserBidSummary> list = new ArrayList<>();
        String sql = """
            SELECT a.AUCTION_ID, i.NAME, i.CATEGORY, i.IMAGE_URL,
                   a.STARTING_BID, a.HIGHEST_BID, a.START_TIME, a.END_TIME, a.STATUS,
                   MAX(b.BID_AMOUNT) AS USER_MAX_BID,
                   COUNT(b.BID_ID) AS USER_BID_COUNT
            FROM AUCTIONS a
            JOIN ITEMS i ON a.ITEM_ID = i.ITEM_ID
            JOIN BIDS b ON a.AUCTION_ID = b.AUCTION_ID
            WHERE b.BIDDER_ID = ?
            GROUP BY a.AUCTION_ID, i.NAME, i.CATEGORY, i.IMAGE_URL,
                     a.STARTING_BID, a.HIGHEST_BID, a.START_TIME, a.END_TIME, a.STATUS
            ORDER BY a.AUCTION_ID DESC
            """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    com.eauction.form.UserBidSummary s = new com.eauction.form.UserBidSummary();
                    s.setAuctionId(rs.getInt("AUCTION_ID"));
                    s.setName(rs.getString("NAME"));
                    s.setCategory(rs.getString("CATEGORY"));
                    s.setImageUrl(rs.getString("IMAGE_URL"));
                    s.setStartingBid(rs.getDouble("STARTING_BID"));
                    s.setCurrentHighestBid(rs.getDouble("HIGHEST_BID"));
                    s.setStartTime(rs.getTimestamp("START_TIME"));
                    s.setEndTime(rs.getTimestamp("END_TIME"));
                    s.setStatus(rs.getString("STATUS"));
                    s.setUserHighestBid(rs.getDouble("USER_MAX_BID"));
                    s.setUserBidCount(rs.getInt("USER_BID_COUNT"));
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
