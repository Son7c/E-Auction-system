package com.eauction.dao;

import com.eauction.form.UserForm;
import com.eauction.util.DBConnection;
import com.eauction.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class UserDAO {

    public boolean registerUser(UserForm user) {
        String passwordHash =PasswordUtil.hash(user.getPassword());

        String securityAnswerHash = PasswordUtil.hash(user.getSecurityAnswer());

        String sql = """
                INSERT INTO USERS
                (EMAIL, NAME, PASSWORD_HASH, PHONE_NO,
                 ADDRESS, SECURITY_QUESTION, SECURITY_ANSWER_HASH)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, user.getEmail());
            ps.setString(2, user.getName());
            ps.setString(3, passwordHash);
            ps.setString(4, user.getPhoneNo());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getSecurityQuestion());
            ps.setString(7, securityAnswerHash);

            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}