package com.lostfound.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class for obtaining a JDBC connection to the MySQL database.
 *
 * ⚠️  Update DB_URL, DB_USER, and DB_PASSWORD to match your environment
 *     before deploying the application.
 */
public class DBConnection {

    // ── Database Configuration ────────────────────────────────────────────────
    private static final String DB_URL      = "jdbc:mysql://localhost:3306/college_lost_found"
                                            + "?useSSL=false"
                                            + "&serverTimezone=Asia/Kolkata"
                                            + "&allowPublicKeyRetrieval=true"
                                            + "&characterEncoding=UTF-8";
    private static final String DB_USER     = "root";        // ← change me
    private static final String DB_PASSWORD = "root";        // ← change me

    // Load the MySQL driver once when the class is initialized
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError(
                    "MySQL JDBC Driver not found. Add mysql-connector-java to your classpath.\n" + e);
        }
    }

    /**
     * Returns a new JDBC {@link Connection} to the database.
     *
     * @return an open Connection
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    /**
     * Safely closes a connection, ignoring any exception.
     *
     * @param conn the connection to close (may be null)
     */
    public static void close(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException ignored) {}
        }
    }
}
