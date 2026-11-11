package com.eauction.dao;

import com.eauction.form.ItemForm;
import com.eauction.util.DBConnection;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {

    public int createItem(ItemForm item, Connection con) {

        // Oracle 12c+ IDENTITY columns: no triggers, internal ISEQ$$_xxxxx sequences
        String sql = "INSERT INTO ITEMS (SELLER_ID, NAME, DESCRIPTION, CATEGORY, IMAGE_URL) VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement ps = con.prepareStatement(sql, new String[]{"ITEM_ID"})) {
            ps.setInt(1, item.getSellerId());
            ps.setString(2, item.getName());
            ps.setString(3, item.getDescription());
            ps.setString(4, item.getCategory());
            ps.setString(5, item.getImageUrl());

            int rows = ps.executeUpdate();
            if (rows == 0) {
                System.err.println("ItemDAO.createItem: executeUpdate returned 0 rows");
                return -1;
            }

            // Strategy 1: getGeneratedKeys (may work with Oracle JDBC 21+ for identity columns)
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs != null && rs.next()) {
                    int id = rs.getInt(1);
                    if (id > 0) {
                        System.out.println("ItemDAO.createItem: ITEM_ID=" + id + " via getGeneratedKeys");
                        return id;
                    }
                }
            } catch (Exception ex) {
                System.err.println("ItemDAO.createItem: getGeneratedKeys: " + ex.getMessage());
            }

            // Strategy 2: Look up the actual Oracle IDENTITY sequence for ITEM_ID via USER_TAB_IDENTITY_COLS
            // This finds the internal ISEQ$$_xxxxx sequence name and queries its CURRVAL
            try (PreparedStatement psMeta = con.prepareStatement(
                    "SELECT SEQUENCE_NAME FROM USER_TAB_IDENTITY_COLS " +
                    "WHERE TABLE_NAME = 'ITEMS' AND COLUMN_NAME = 'ITEM_ID'")) {
                try (ResultSet rsMeta = psMeta.executeQuery()) {
                    if (rsMeta.next()) {
                        String seqName = rsMeta.getString(1);
                        if (seqName != null && !seqName.isEmpty()) {
                            System.out.println("ItemDAO.createItem: identity sequence = " + seqName);
                            try (java.sql.Statement stCurr = con.createStatement();
                                 ResultSet rsCurr = stCurr.executeQuery("SELECT \"" + seqName + "\".CURRVAL FROM DUAL")) {
                                if (rsCurr.next()) {
                                    int id = rsCurr.getInt(1);
                                    if (id > 0) {
                                        System.out.println("ItemDAO.createItem: ITEM_ID=" + id + " via " + seqName + ".CURRVAL");
                                        return id;
                                    }
                                }
                            }
                        }
                    }
                }
            } catch (Exception ex) {
                System.err.println("ItemDAO.createItem: identity seq lookup failed: " + ex.getMessage());
            }

            // Strategy 3: MAX(ITEM_ID) for this seller + name on the same connection
            // Works in Oracle because same-session uncommitted rows are visible
            try (PreparedStatement psMax = con.prepareStatement(
                    "SELECT MAX(ITEM_ID) FROM ITEMS WHERE SELLER_ID = ? AND NAME = ?")) {
                psMax.setInt(1, item.getSellerId());
                psMax.setString(2, item.getName());
                try (ResultSet rsMax = psMax.executeQuery()) {
                    if (rsMax.next()) {
                        int id = rsMax.getInt(1);
                        if (id > 0) {
                            System.out.println("ItemDAO.createItem: ITEM_ID=" + id + " via MAX(ITEM_ID) fallback");
                            return id;
                        }
                    }
                }
            } catch (Exception ex2) {
                System.err.println("ItemDAO.createItem: MAX fallback failed: " + ex2.getMessage());
            }

            System.err.println("ItemDAO.createItem: INSERT succeeded but could not retrieve ITEM_ID!");
            return -1;

        } catch (SQLException e) {
            System.err.println("ItemDAO.createItem SQL ERROR: " + e.getMessage());
            e.printStackTrace();
            return -1;
        }
    }

    public boolean createItem(ItemForm item) {
        try (Connection con = DBConnection.getConnection()) {
            int itemId = createItem(item, con);
            return itemId != -1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<ItemForm> getAllItems() {
        List<ItemForm> items = new ArrayList<>();
        String sql = """
            SELECT ITEM_ID, SELLER_ID, NAME,
                   DESCRIPTION, CATEGORY, IMAGE_URL
            FROM ITEMS
            ORDER BY ITEM_ID DESC
            """;
        try (
                Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                ItemForm item = new ItemForm();

                item.setItemId(rs.getInt("ITEM_ID"));
                item.setSellerId(rs.getInt("SELLER_ID"));
                item.setName(rs.getString("NAME"));
                item.setDescription(rs.getString("DESCRIPTION"));
                item.setCategory(rs.getString("CATEGORY"));
                item.setImageUrl(rs.getString("IMAGE_URL"));

                items.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return items;
    }
}
