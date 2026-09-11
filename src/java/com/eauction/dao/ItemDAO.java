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

        String sql = """
            INSERT INTO ITEMS
            (SELLER_ID, NAME, DESCRIPTION, CATEGORY, IMAGE_URL)
            VALUES (?, ?, ?, ?, ?)
            """;

        try (
                PreparedStatement ps = con.prepareStatement(
                        sql,
                        new String[]{"ITEM_ID"})) {

            ps.setInt(1, item.getSellerId());
            ps.setString(2, item.getName());
            ps.setString(3, item.getDescription());
            ps.setString(4, item.getCategory());
            ps.setString(5, item.getImageUrl());

            int rows = ps.executeUpdate();

            if (rows == 0) {
                return -1;
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {

                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
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
