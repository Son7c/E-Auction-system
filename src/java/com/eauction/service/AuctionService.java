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

    public List<AuctionForm> getApprovedAuctions() {
        AuctionDAO auctionDAO = new AuctionDAO();
        return auctionDAO.getApprovedAuctions();
    }

    public List<AuctionForm> getAuctionsByStatus(String status) {
        AuctionDAO auctionDAO = new AuctionDAO();
        return auctionDAO.getAuctionsByStatus(status);
    }

    public boolean updateAuctionStatus(int auctionId, String status) {
        AuctionDAO auctionDAO = new AuctionDAO();
        return auctionDAO.updateAuctionStatus(auctionId, status);
    }

    public String updateAuctionStatusWithDetail(int auctionId, String status) {
        AuctionDAO auctionDAO = new AuctionDAO();
        return auctionDAO.updateAuctionStatusWithDetail(auctionId, status);
    }

    public boolean deleteAuction(int auctionId) {
        AuctionDAO auctionDAO = new AuctionDAO();
        return auctionDAO.deleteAuction(auctionId);
    }

    public AuctionForm getAuctionById(int auctionId) {
        AuctionDAO auctionDAO = new AuctionDAO();
        return auctionDAO.getAuctionById(auctionId);
    }

    public List<ItemForm> getAllItems() {
        ItemDAO itemDAO = new ItemDAO();
        return itemDAO.getAllItems();
    }

    public boolean createItemWithAuction(ItemForm item, AuctionForm auction) {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            System.out.println("createItemWithAuction: sellerId=" + item.getSellerId()
                    + " name=" + item.getName() + " status=" + auction.getStatus());

            ItemDAO itemDAO = new ItemDAO();
            int itemId = itemDAO.createItem(item, con);
            System.out.println("createItemWithAuction: itemDAO.createItem returned itemId=" + itemId);

            if (itemId <= 0) {
                System.err.println("createItemWithAuction: itemId is invalid (" + itemId + "), rolling back");
                con.rollback();
                return false;
            }

            auction.setItemId(itemId);

            AuctionDAO auctionDAO = new AuctionDAO();
            boolean auctionCreated = auctionDAO.createAuction(auction, con);
            System.out.println("createItemWithAuction: auctionCreated=" + auctionCreated);

            if (!auctionCreated) {
                System.err.println("createItemWithAuction: auctionDAO.createAuction returned false, rolling back");
                con.rollback();
                return false;
            }

            con.commit();
            System.out.println("createItemWithAuction: committed successfully, itemId=" + itemId);
            return true;
        } catch (SQLException e) {
            System.err.println("createItemWithAuction EXCEPTION: " + e.getMessage());
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
