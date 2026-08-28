
package com.eauction.dao;

import com.eauction.form.AuctionForm;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
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
}
