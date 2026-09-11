
package com.eauction.service;

import com.eauction.dao.AuctionDAO;
import com.eauction.dao.ItemDAO;
import com.eauction.form.AuctionForm;
import com.eauction.form.ItemForm;
import com.eauction.util.DBConnection;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class AuctionService {
    public List<AuctionForm> getAllAuctions() {
        AuctionDAO auctionDAO = new AuctionDAO();
        return auctionDAO.getAllAuctions();
    }

    public AuctionForm getAuctionById(int auctionId) {
        AuctionDAO auctionDAO = new AuctionDAO();
        return auctionDAO.getAuctionById(auctionId);
    }

    public List<ItemForm> getAllItems() {
        ItemDAO itemDAO = new ItemDAO();
        return itemDAO.getAllItems();
    }

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

    public List<AuctionForm> getAuctionsBySellerId(int sellerId) {
        AuctionDAO auctionDAO = new AuctionDAO();
        return auctionDAO.getAuctionsBySellerId(sellerId);
    }
}
