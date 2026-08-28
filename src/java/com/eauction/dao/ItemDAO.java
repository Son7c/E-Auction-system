package com.eauction.dao;

import com.eauction.form.ItemForm;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

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
}
