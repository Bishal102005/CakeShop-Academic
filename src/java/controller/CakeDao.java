package controller;

import model.Cake;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public final class CakeDao {

    private CakeDao() {
    }

    public static Cake findById(int id) throws Exception {
        String sql = "SELECT * FROM cakes WHERE id = ?";
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCake(rs);
                }
            }
        }
        return null;
    }

    public static Cake findByName(String name) throws Exception {
        String sql = "SELECT * FROM cakes WHERE name = ?";
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCake(rs);
                }
            }
        }
        return null;
    }

    private static Cake mapCake(ResultSet rs) throws Exception {
        return new Cake(
                rs.getInt("id"),
                rs.getString("number"),
                rs.getString("code"),
                rs.getString("name"),
                rs.getString("description"),
                rs.getString("tag"),
                rs.getDouble("rating"),
                rs.getDouble("price"),
                rs.getString("image_file"),
                rs.getString("ingredients")
        );
    }
}
