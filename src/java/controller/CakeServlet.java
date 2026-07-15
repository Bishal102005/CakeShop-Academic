package controller;

import model.Cake;
import java.io.InputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/admin")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024
)
public class CakeServlet extends HttpServlet {

    private Connection getConnection() throws Exception {
        return DbUtil.getConnection();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Cake> list = new ArrayList<>();
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM cakes")) {

            while (rs.next()) {
                list.add(new Cake(
                    rs.getInt("id"), rs.getString("number"), rs.getString("code"),
                    rs.getString("name"), rs.getString("description"), rs.getString("tag"),
                    rs.getDouble("rating"), rs.getDouble("price"),
                    rs.getString("image_file"), rs.getString("ingredients")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("cakeMenu", list);
        // Explicitly point to the root index.jsp
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!AuthUtil.requireAdmin(request, response)) {
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        if ("addCake".equals(action)) {
            addCake(request, response);
            return;
        }

        if ("updateCake".equals(action)) {
            updateCake(request, response);
            return;
        }

        if ("deleteCake".equals(action)) {
            deleteCake(request, response);
            return;
        }
        
        response.sendRedirect(request.getContextPath() + "/view-orders");
    }

    private void addCake(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String name = request.getParameter("name");
        String number = request.getParameter("number");
        String code = request.getParameter("code");
        double price = parseDouble(request.getParameter("price"));
        double rating = parseDouble(request.getParameter("rating"));
        String tag = request.getParameter("tag");
        String imageFile;
        try {
            imageFile = saveUploadedImage(request.getPart("image_file"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/view-orders?error=Please+upload+a+valid+cake+image.");
            return;
        }
        String description = request.getParameter("description");
        String ingredients = request.getParameter("ingredients");

        String sql = "INSERT INTO cakes (number, code, name, description, tag, rating, price, image_file, ingredients) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, number);
            ps.setString(2, code != null ? code.toUpperCase() : "");
            ps.setString(3, name);
            ps.setString(4, description);
            ps.setString(5, tag != null ? tag : "");
            ps.setDouble(6, rating);
            ps.setDouble(7, price);
            ps.setString(8, imageFile);
            ps.setString(9, ingredients != null ? ingredients : "");

            ps.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/view-orders?success=Cake+added+successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/view-orders?error=Database+Error:+Could+not+add+cake.");
        }
    }

    private void updateCake(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int id = parseInt(request.getParameter("id"));
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/view-orders?error=Invalid+cake+selected.");
            return;
        }

        String imageFile = request.getParameter("existing_image_file");
        Part imagePart = request.getPart("image_file");
        if (imagePart != null && imagePart.getSize() > 0) {
            try {
                imageFile = saveUploadedImage(imagePart);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/order.jsp?id=" + id + "&error=Please+upload+a+valid+cake+image.");
                return;
            }
        }

        String sql = "UPDATE cakes SET number = ?, code = ?, name = ?, description = ?, tag = ?, rating = ?, price = ?, image_file = ?, ingredients = ? WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, request.getParameter("number"));
            String code = request.getParameter("code");
            ps.setString(2, code != null ? code.toUpperCase() : "");
            ps.setString(3, request.getParameter("name"));
            ps.setString(4, request.getParameter("description"));
            String tag = request.getParameter("tag");
            ps.setString(5, tag != null ? tag : "");
            ps.setDouble(6, parseDouble(request.getParameter("rating")));
            ps.setDouble(7, parseDouble(request.getParameter("price")));
            ps.setString(8, imageFile != null ? imageFile : "");
            ps.setString(9, request.getParameter("ingredients") != null ? request.getParameter("ingredients") : "");
            ps.setInt(10, id);

            int updated = ps.executeUpdate();
            if (updated == 0) {
                response.sendRedirect(request.getContextPath() + "/view-orders?error=Cake+not+found.");
                return;
            }

            response.sendRedirect(request.getContextPath() + "/order.jsp?id=" + id + "&success=Cake+updated+successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/order.jsp?id=" + id + "&error=Database+Error:+Could+not+update+cake.");
        }
    }

    private void deleteCake(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = parseInt(request.getParameter("id"));
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/view-orders?error=Invalid+cake+selected.");
            return;
        }

        String sql = "DELETE FROM cakes WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            int deleted = ps.executeUpdate();
            if (deleted == 0) {
                response.sendRedirect(request.getContextPath() + "/view-orders?error=Cake+not+found.");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/view-orders?success=Cake+deleted+successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/view-orders?error=Database+Error:+Could+not+delete+cake.");
        }
    }

    private double parseDouble(String value) {
        try {
            if (value != null && !value.trim().isEmpty()) {
                return Double.parseDouble(value);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    private int parseInt(String value) {
        try {
            if (value != null && !value.trim().isEmpty()) {
                return Integer.parseInt(value);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private String saveUploadedImage(Part imagePart) throws IOException, ServletException {
        if (imagePart == null || imagePart.getSize() == 0) {
            throw new ServletException("Please choose a cake image.");
        }

        String contentType = imagePart.getContentType();
        if (contentType == null || !contentType.toLowerCase().startsWith("image/")) {
            throw new ServletException("Only image files are allowed.");
        }

        String originalName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
        String safeName = originalName.replaceAll("[^A-Za-z0-9._-]", "_");
        if (safeName.isEmpty()) {
            safeName = "cake-image";
        }

        String fileName = System.currentTimeMillis() + "-" + safeName;
        Path deployedAssets = Paths.get(getServletContext().getRealPath("/assets"));
        Files.createDirectories(deployedAssets);

        Path destination = deployedAssets.resolve(fileName);
        try (InputStream input = imagePart.getInputStream()) {
            Files.copy(input, destination, StandardCopyOption.REPLACE_EXISTING);
        }

        copyToSourceAssetsIfAvailable(deployedAssets, destination, fileName);
        return fileName;
    }

    private void copyToSourceAssetsIfAvailable(Path deployedAssets, Path uploadedFile, String fileName) {
        Path buildWeb = Paths.get("build", "web", "assets").toAbsolutePath().normalize();
        Path normalizedDeployedAssets = deployedAssets.toAbsolutePath().normalize();

        if (!normalizedDeployedAssets.endsWith(buildWeb)) {
            return;
        }

        Path sourceAssets = Paths.get("web", "assets").toAbsolutePath().normalize();
        try {
            Files.createDirectories(sourceAssets);
            Files.copy(uploadedFile, sourceAssets.resolve(fileName), StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException ignored) {
            // The deployed upload already succeeded; source copy is only for local development.
        }
    }
}
