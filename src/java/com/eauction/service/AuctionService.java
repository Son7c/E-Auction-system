
package com.eauction.service;

import com.eauction.dao.AuctionDAO;
import com.eauction.dao.ItemDAO;
import com.eauction.form.AuctionForm;
import com.eauction.form.ItemForm;
import com.eauction.util.DBConnection;

import java.sql.Connection;
import java.sql.SQLException;

public class AuctionService {
    public boolean createItemWithAuction(
            ItemForm item,AuctionForm auction
    ){
        Connection con = null;
        try{
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            
            ItemDAO itemDAO = new ItemDAO();
            int itemId = itemDAO.createItem(item, con);
            if (itemId == -1) {
                con.rollback();
                return false;
            }
            
            auction.setItemId(itemId);
            
            AuctionDAO auctionDAO = new AuctionDAO();
            
            boolean auctionCreated =
                    auctionDAO.createAuction(auction, con);
            
            if (!auctionCreated) {
                con.rollback();
                return false;
            }
            
            con.commit();
            return true;
        }catch (SQLException e) {

            e.printStackTrace();

            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (SQLException rollbackException) {
                rollbackException.printStackTrace();
            }

            return false;

        } finally {

            try {
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
