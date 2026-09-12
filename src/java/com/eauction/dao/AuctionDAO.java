
package com.eauction.dao;

import com.eauction.form.AuctionForm;
import com.eauction.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AuctionDAO {
    public boolean createAuction(AuctionForm auction, Connection con) {
        String sql = """
                   INSERT INTO AUCTIONS
                   (ITEM_ID, STARTING_BID, START_TIME, END_TIME)
                   VALUES (?,?,?,?)""";
        try (
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, auction.getItemId());
            ps.setDouble(2, auction.getStartingBid());
            ps.setTimestamp(3, auction.getStartTime());
            ps.setTimestamp(4, auction.getEndTime());

            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<AuctionForm> getAllAuctions() {
        List<AuctionForm> auctions = new ArrayList<>();
        String sql = """
            SELECT a.AUCTION_ID, a.ITEM_ID, a.STARTING_BID, a.HIGHEST_BID,
                   a.START_TIME, a.END_TIME, a.STATUS,
                   i.SELLER_ID, i.NAME, i.DESCRIPTION, i.CATEGORY, i.IMAGE_URL,
                   u.NAME AS SELLER_NAME
            FROM AUCTIONS a
            JOIN ITEMS i ON a.ITEM_ID = i.ITEM_ID
            LEFT JOIN USERS u ON i.SELLER_ID = u.USER_ID
            ORDER BY a.AUCTION_ID DESC
            """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AuctionForm auction = new AuctionForm();
                auction.setAuctionId(rs.getInt("AUCTION_ID"));
                auction.setItemId(rs.getInt("ITEM_ID"));
                auction.setStartingBid(rs.getDouble("STARTING_BID"));
                auction.setHighestBid(rs.getDouble("HIGHEST_BID"));
                auction.setStartTime(rs.getTimestamp("START_TIME"));
                auction.setEndTime(rs.getTimestamp("END_TIME"));
                auction.setStatus(rs.getString("STATUS"));

                auction.setSellerId(rs.getInt("SELLER_ID"));
                auction.setName(rs.getString("NAME"));
                auction.setDescription(rs.getString("DESCRIPTION"));
                auction.setCategory(rs.getString("CATEGORY"));
                auction.setImageUrl(rs.getString("IMAGE_URL"));
                auction.setSellerName(rs.getString("SELLER_NAME"));

                auctions.add(auction);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return auctions;
    }

    public AuctionForm getAuctionById(int auctionId) {
        String sql = """
            SELECT a.AUCTION_ID, a.ITEM_ID, a.STARTING_BID, a.HIGHEST_BID,
                   a.START_TIME, a.END_TIME, a.STATUS,
                   i.SELLER_ID, i.NAME, i.DESCRIPTION, i.CATEGORY, i.IMAGE_URL,
                   u.NAME AS SELLER_NAME
            FROM AUCTIONS a
            JOIN ITEMS i ON a.ITEM_ID = i.ITEM_ID
            LEFT JOIN USERS u ON i.SELLER_ID = u.USER_ID
            WHERE a.AUCTION_ID = ?
            """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, auctionId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AuctionForm auction = new AuctionForm();
                    auction.setAuctionId(rs.getInt("AUCTION_ID"));
                    auction.setItemId(rs.getInt("ITEM_ID"));
                    auction.setStartingBid(rs.getDouble("STARTING_BID"));
                    auction.setHighestBid(rs.getDouble("HIGHEST_BID"));
                    auction.setStartTime(rs.getTimestamp("START_TIME"));
                    auction.setEndTime(rs.getTimestamp("END_TIME"));
                    auction.setStatus(rs.getString("STATUS"));

                    auction.setSellerId(rs.getInt("SELLER_ID"));
                    auction.setName(rs.getString("NAME"));
                    auction.setDescription(rs.getString("DESCRIPTION"));
                    auction.setCategory(rs.getString("CATEGORY"));
                    auction.setImageUrl(rs.getString("IMAGE_URL"));
                    auction.setSellerName(rs.getString("SELLER_NAME"));
                    return auction;
                }
            }

        } catch (SQLException e) {
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
                    AuctionForm auction = new AuctionForm();
                    auction.setAuctionId(rs.getInt("AUCTION_ID"));
                    auction.setItemId(rs.getInt("ITEM_ID"));
                    auction.setStartingBid(rs.getDouble("STARTING_BID"));
                    auction.setHighestBid(rs.getDouble("HIGHEST_BID"));
                    auction.setStartTime(rs.getTimestamp("START_TIME"));
                    auction.setEndTime(rs.getTimestamp("END_TIME"));
                    auction.setStatus(rs.getString("STATUS"));

                    auction.setSellerId(rs.getInt("SELLER_ID"));
                    auction.setName(rs.getString("NAME"));
                    auction.setDescription(rs.getString("DESCRIPTION"));
                    auction.setCategory(rs.getString("CATEGORY"));
                    auction.setImageUrl(rs.getString("IMAGE_URL"));
                    auction.setSellerName(rs.getString("SELLER_NAME"));
                    auction.setBidCount(rs.getInt("BID_COUNT"));

                    list.add(auction);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
