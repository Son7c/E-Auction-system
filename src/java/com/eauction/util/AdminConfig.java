package com.eauction.util;

import com.eauction.form.UserForm;
import java.io.InputStream;
import java.util.Properties;

/**
 * Configuration and authorization utility for Admin mode.
 * Admin mode is activated when a user's email and address match
 * the designated admin credentials.
 */
public class AdminConfig {

    private static String adminEmail = "admin@eauction.com";
    private static String adminAddress = "Admin HQ";

    static {
        loadConfig();
    }

    private static void loadConfig() {
        try (InputStream is = AdminConfig.class.getClassLoader().getResourceAsStream("config/db.properties")) {
            if (is != null) {
                Properties props = new Properties();
                props.load(is);
                String emailProp = props.getProperty("admin.email");
                String addressProp = props.getProperty("admin.address");
                if (emailProp != null && !emailProp.trim().isEmpty()) {
                    adminEmail = emailProp.trim();
                }
                if (addressProp != null && !addressProp.trim().isEmpty()) {
                    adminAddress = addressProp.trim();
                }
            }
        } catch (Exception e) {
            // Keep default values if file is absent
        }
    }

    public static String getAdminEmail() {
        return adminEmail;
    }

    public static String getAdminAddress() {
        return adminAddress;
    }

    /**
     * Checks if the given user matches the designated admin email and address.
     * Both comparisons are case-insensitive and trimmed.
     */
    public static boolean isAdmin(UserForm user) {
        if (user == null) {
            return false;
        }
        String email = user.getEmail();
        String address = user.getAddress();
        if (email == null || address == null) {
            return false;
        }
        return adminEmail.equalsIgnoreCase(email.trim())
                && adminAddress.equalsIgnoreCase(address.trim());
    }
}

