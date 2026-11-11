package com.eauction.dao;

import com.eauction.form.AuctionForm;
import com.eauction.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class AuctionDAO {

    public boolean createAuction(AuctionForm auction, Connection con) {
        String status = auction.getStatus();
        if (status == null || status.trim().isEmpty()) {
            status = "PENDING";
        }

        String sql = """
            INSERT INTO AUCTIONS
            (ITEM_ID, STARTING_BID, START_TIME, END_TIME, STATUS)
            VALUES (?, ?, ?, ?, ?)
            """;

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, auction.getItemId());
            ps.setDouble(2, auction.getStartingBid());
            ps.setTimestamp(3, auction.getStartTime());
            ps.setTimestamp(4, auction.getEndTime());
            ps.setString(5, status);

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("AuctionDAO.createAuction failed: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Automatically updates status to 'COMPLETED' for any approved auctions whose end time has passed.
     */
    public void updateCompletedAuctions() {
        String sql = """
            UPDATE AUCTIONS 
            SET STATUS = 'COMPLETED' 
            WHERE END_TIME <= CURRENT_TIMESTAMP 
              AND (STATUS = 'APPROVED' OR STATUS = 'ACTIVE')
            """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            con.setAutoCommit(false);
            ps.executeUpdate();
            con.commit();
        } catch (SQLException e) {
            System.err.println("Notice: updateCompletedAuctions: " + e.getMessage());
        }
    }

    /**
     * Retrieves all auctions across all statuses (used by Admin Dashboard).
     */
    public List<AuctionForm> getAllAuctions() {
        updateCompletedAuctions();
        List<AuctionForm> auctions = new ArrayList<>();
        String sql = """
            SELECT a.AUCTION_ID, a.ITEM_ID, a.STARTING_BID, a.HIGHEST_BID,
                   a.START_TIME, a.END_TIME, a.STATUS,
                   i.SELLER_ID, i.NAME, i.DESCRIPTION, i.CATEGORY, i.IMAGE_URL,
                   u.NAME AS SELLER_NAME,
                   (SELECT COUNT(*) FROM BIDS b WHERE b.AUCTION_ID = a.AUCTION_ID) AS BID_COUNT
            FROM AUCTIONS a
            JOIN ITEMS i ON a.ITEM_ID = i.ITEM_ID
            LEFT JOIN USERS u ON i.SELLER_ID = u.USER_ID
            ORDER BY a.AUCTION_ID DESC
            """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                auctions.add(mapAuction(rs));
            }
        } catch (SQLException e) {
            System.err.println("AuctionDAO.getAllAuctions failed: " + e.getMessage());
            e.printStackTrace();
        }

        return auctions;
    }

    /**
     * Retrieves only approved/active auctions (used by public browsing & bidding).
     */
    public List<AuctionForm> getApprovedAuctions() {
        updateCompletedAuctions();
        List<AuctionForm> auctions = new ArrayList<>();
        String sql = """
            SELECT a.AUCTION_ID, a.ITEM_ID, a.STARTING_BID, a.HIGHEST_BID,
                   a.START_TIME, a.END_TIME, a.STATUS,
                   i.SELLER_ID, i.NAME, i.DESCRIPTION, i.CATEGORY, i.IMAGE_URL,
                   u.NAME AS SELLER_NAME,
                   (SELECT COUNT(*) FROM BIDS b WHERE b.AUCTION_ID = a.AUCTION_ID) AS BID_COUNT
            FROM AUCTIONS a
            JOIN ITEMS i ON a.ITEM_ID = i.ITEM_ID
            LEFT JOIN USERS u ON i.SELLER_ID = u.USER_ID
            WHERE a.STATUS = 'APPROVED' AND (a.END_TIME IS NULL OR a.END_TIME > CURRENT_TIMESTAMP)
            ORDER BY a.AUCTION_ID DESC
            """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                auctions.add(mapAuction(rs));
            }
        } catch (SQLException e) {
            System.err.println("AuctionDAO.getApprovedAuctions failed: " + e.getMessage());
            e.printStackTrace();
        }

        return auctions;
    }

    /**
     * Retrieves auctions filtered by a specific status (e.g. 'PENDING').
     */
    public List<AuctionForm> getAuctionsByStatus(String status) {
        List<AuctionForm> auctions = new ArrayList<>();
        String sql = """
            SELECT a.AUCTION_ID, a.ITEM_ID, a.STARTING_BID, a.HIGHEST_BID,
                   a.START_TIME, a.END_TIME, a.STATUS,
                   i.SELLER_ID, i.NAME, i.DESCRIPTION, i.CATEGORY, i.IMAGE_URL,
                   u.NAME AS SELLER_NAME,
                   (SELECT COUNT(*) FROM BIDS b WHERE b.AUCTION_ID = a.AUCTION_ID) AS BID_COUNT
            FROM AUCTIONS a
            JOIN ITEMS i ON a.ITEM_ID = i.ITEM_ID
            LEFT JOIN USERS u ON i.SELLER_ID = u.USER_ID
            WHERE UPPER(a.STATUS) = UPPER(?)
            ORDER BY a.AUCTION_ID DESC
            """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    auctions.add(mapAuction(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("AuctionDAO.getAuctionsByStatus failed: " + e.getMessage());
            e.printStackTrace();
        }

        return auctions;
    }

    public AuctionForm getAuctionById(int auctionId) {
        String sql = """
            SELECT a.AUCTION_ID, a.ITEM_ID, a.STARTING_BID, a.HIGHEST_BID,
                   a.START_TIME, a.END_TIME, a.STATUS,
                   i.SELLER_ID, i.NAME, i.DESCRIPTION, i.CATEGORY, i.IMAGE_URL,
                   u.NAME AS SELLER_NAME,
                   (SELECT COUNT(*) FROM BIDS b WHERE b.AUCTION_ID = a.AUCTION_ID) AS BID_COUNT
            FROM AUCTIONS a
            JOIN ITEMS i ON a.ITEM_ID = i.ITEM_ID
            LEFT JOIN USERS u ON i.SELLER_ID = u.USER_ID
            WHERE a.AUCTION_ID = ?
            """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, auctionId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAuction(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("AuctionDAO.getAuctionById failed: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    public List<AuctionForm> getAuctionsBySellerId(int sellerId) {
        List<AuctionForm> list = new ArrayList<>();
        String sql = """
            SELECT a.AUCTION_ID, a.ITEM_ID, a.STARTING_BID, a.HIGHEST_BID,
                   a.START_TIME, a.END_TIME, a.STATUS,
                   i.SELLER_ID, i.NAME, i.DESCRIPTION, i.CATEGORY, i.IMAGE_URL,
                   u.NAME AS SELLER_NAME,
                   (SELECT COUNT(*) FROM BIDS b WHERE b.AUCTION_ID = a.AUCTION_ID) AS BID_COUNT
            FROM AUCTIONS a
            JOIN ITEMS i ON a.ITEM_ID = i.ITEM_ID
            LEFT JOIN USERS u ON i.SELLER_ID = u.USER_ID
            WHERE i.SELLER_ID = ?
            ORDER BY a.AUCTION_ID DESC
            """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, sellerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAuction(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("AuctionDAO.getAuctionsBySellerId failed: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Updates the status of an auction and returns null on success, or the detailed error string on failure.
     */
    public String updateAuctionStatusWithDetail(int auctionId, String status) {
        String sql = "UPDATE AUCTIONS SET STATUS = ? WHERE AUCTION_ID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            con.setAutoCommit(false);
            ps.setString(1, status);
            ps.setInt(2, auctionId);

            int updated = ps.executeUpdate();
            con.commit();

            if (updated > 0) {
                System.out.println("updateAuctionStatus: AUCTION_ID=" + auctionId + " set to " + status);
                return null; // Success!
            } else {
                return "No auction found in database matching AUCTION_ID = " + auctionId;
            }
        } catch (SQLException e) {
            System.err.println("updateAuctionStatus failed for id=" + auctionId + ": " + e.getMessage());
            e.printStackTrace();
            return "Database error updating AUCTION_ID=" + auctionId + ": " + e.getMessage();
        }
    }

    /**
     * Updates the status of an auction (e.g. APPROVED, REJECTED, PENDING).
     */
    public boolean updateAuctionStatus(int auctionId, String status) {
        return updateAuctionStatusWithDetail(auctionId, status) == null;
    }

    /**
     * Deletes an auction and its related item and bids.
     */
    public boolean deleteAuction(int auctionId) {
        String findItemSql = "SELECT ITEM_ID FROM AUCTIONS WHERE AUCTION_ID = ?";
        String deleteBidsSql = "DELETE FROM BIDS WHERE AUCTION_ID = ?";
        String deleteAuctionSql = "DELETE FROM AUCTIONS WHERE AUCTION_ID = ?";
        String deleteItemSql = "DELETE FROM ITEMS WHERE ITEM_ID = ?";

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            int itemId = -1;
            try (PreparedStatement psFind = con.prepareStatement(findItemSql)) {
                psFind.setInt(1, auctionId);
                try (ResultSet rs = psFind.executeQuery()) {
                    if (rs.next()) {
                        itemId = rs.getInt("ITEM_ID");
                    }
                }
            }

            try (PreparedStatement psBids = con.prepareStatement(deleteBidsSql)) {
                psBids.setInt(1, auctionId);
                psBids.executeUpdate();
            }

            try (PreparedStatement psAuc = con.prepareStatement(deleteAuctionSql)) {
                psAuc.setInt(1, auctionId);
                psAuc.executeUpdate();
            }

            if (itemId != -1) {
                try (PreparedStatement psItem = con.prepareStatement(deleteItemSql)) {
                    psItem.setInt(1, itemId);
                    psItem.executeUpdate();
                }
            }

            con.commit();
            return true;
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }

    private AuctionForm mapAuction(ResultSet rs) throws SQLException {
        AuctionForm auction = new AuctionForm();
        auction.setAuctionId(rs.getInt("AUCTION_ID"));
        auction.setItemId(rs.getInt("ITEM_ID"));
        auction.setStartingBid(rs.getDouble("STARTING_BID"));
        auction.setHighestBid(rs.getDouble("HIGHEST_BID"));
        auction.setStartTime(rs.getTimestamp("START_TIME"));
        Timestamp endTime = rs.getTimestamp("END_TIME");
        auction.setEndTime(endTime);

        String st = rs.getString("STATUS");
        long now = System.currentTimeMillis();
        if (endTime != null && now >= endTime.getTime() && !"REJECTED".equalsIgnoreCase(st) && !"PENDING".equalsIgnoreCase(st)) {
            auction.setStatus("COMPLETED");
        } else {
            auction.setStatus(st != null ? st : "PENDING");
        }

        auction.setSellerId(rs.getInt("SELLER_ID"));
        auction.setName(rs.getString("NAME"));
        auction.setDescription(rs.getString("DESCRIPTION"));
        auction.setCategory(rs.getString("CATEGORY"));
        auction.setImageUrl(rs.getString("IMAGE_URL"));
        auction.setSellerName(rs.getString("SELLER_NAME"));

        try {
            auction.setBidCount(rs.getInt("BID_COUNT"));
        } catch (SQLException ignored) {
        }

        return auction;
    }
}
