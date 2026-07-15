package controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public final class OrderDao {

    public static final String DEFAULT_STATUS = "Received";

    public static final List<String> VALID_STATUSES = Arrays.asList(
            "Received",
            "Baking",
            "Out for Delivery",
            "Delivered",
            "Cancelled"
    );

    private static final Set<String> VALID_STATUS_SET = new HashSet<>(VALID_STATUSES);

    private OrderDao() {
    }

    public static boolean isValidStatus(String status) {
        return status != null && VALID_STATUS_SET.contains(status.trim());
    }

    public static String normalizeStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            return DEFAULT_STATUS;
        }
        String trimmed = status.trim();
        return VALID_STATUS_SET.contains(trimmed) ? trimmed : DEFAULT_STATUS;
    }

    public static String statusCssClass(String status) {
        switch (normalizeStatus(status)) {
            case "Baking":
                return "status-baking";
            case "Out for Delivery":
                return "status-delivery";
            case "Delivered":
                return "status-delivered";
            case "Cancelled":
                return "status-cancelled";
            default:
                return "status-received";
        }
    }

    public static List<Map<String, Object>> getOrdersForUser(int userId) throws Exception {
        List<Map<String, Object>> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_id DESC";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapOrderRow(rs));
                }
            }
        }
        return orders;
    }

    public static boolean updateOrderStatus(int orderId, String status) throws Exception {
        String sql = "UPDATE orders SET order_status = ? WHERE order_id = ?";
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, normalizeStatus(status));
            ps.setInt(2, orderId);
            return ps.executeUpdate() == 1;
        }
    }

    public static Map<String, Object> mapOrderRow(ResultSet rs) throws Exception {
        Map<String, Object> row = new HashMap<>();
        row.put("id", rs.getInt("order_id"));
        row.put("cakeName", rs.getString("cake_name"));
        row.put("cakePrice", rs.getDouble("cake_price"));
        row.put("deliveryDate", rs.getString("delivery_date"));
        row.put("customerAddress", rs.getString("customer_address"));
        row.put("status", readStatus(rs));

        try {
            row.put("customerName", rs.getString("customer_name"));
            row.put("customerPhone", rs.getString("customer_phone"));
        } catch (Exception ignored) {
        }

        return row;
    }

    private static String readStatus(ResultSet rs) {
        try {
            String status = rs.getString("order_status");
            return normalizeStatus(status);
        } catch (Exception e) {
            return DEFAULT_STATUS;
        }
    }
}
