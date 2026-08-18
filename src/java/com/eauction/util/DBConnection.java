package com.eauction.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL ="jdbc:oracle:thin:@//localhost:1521/XEPDB1";
    private static final String USER = "AUCTION_APP";
    private static final String PASSWORD = "auction123";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
    
    public static void main(String[] args) {

    try {
        Connection connection = getConnection();

        System.out.println("Database connected successfully!");

        connection.close();

    } catch (SQLException e) {
        e.printStackTrace();
    }
}
}