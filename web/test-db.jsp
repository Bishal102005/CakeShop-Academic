<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, controller.DbUtil"%>
<!DOCTYPE html>
<html>
<head>
    <title>Database Diagnostic Tool</title>
</head>
<body style="font-family:sans-serif; padding: 20px; background: #fafafa;">
    <div style="max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); border: 1px solid #e5e7eb;">
        <h2 style="margin-top:0; color:#1f2937;">Database Connection Diagnostic</h2>
        <%
            Connection conn = null;
            try {
                conn = DbUtil.getConnection();
                out.println("<div style='background:#d1fae5; color:#065f46; padding:12px; border-radius:6px; margin-bottom:15px; font-weight:bold;'>✓ Successfully connected to the database!</div>");
                
                DatabaseMetaData meta = conn.getMetaData();
                out.println("<p><b>Database Product:</b> " + meta.getDatabaseProductName() + " " + meta.getDatabaseProductVersion() + "</p>");
                out.println("<p><b>JDBC Driver:</b> " + meta.getDriverName() + " " + meta.getDriverVersion() + "</p>");
                
                // Check if tables exist
                String[] tableTypes = {"TABLE"};
                ResultSet rs = meta.getTables(null, null, "%", tableTypes);
                out.println("<h3>Tables Found in Database:</h3>");
                out.println("<ul>");
                boolean foundTables = false;
                while (rs.next()) {
                    foundTables = true;
                    String tableName = rs.getString("TABLE_NAME");
                    out.println("<li>" + tableName + "</li>");
                }
                if (!foundTables) {
                    out.println("<li><i>No tables found in this schema/database.</i></li>");
                }
                out.println("</ul>");
                
            } catch (Exception e) {
                out.println("<div style='background:#fee2e2; color:#991b1b; padding:12px; border-radius:6px; margin-bottom:15px; font-weight:bold;'>✗ Connection Failed!</div>");
                out.println("<h3 style='color:#b91c1c;'>Error Message:</h3>");
                out.println("<pre style='background:#fee2e2; color:#991b1b; padding:15px; border-radius:6px; overflow-x:auto; font-family:monospace;'>" + e.toString() + "</pre>");
                
                out.println("<h3 style='color:#374151;'>Stack Trace:</h3>");
                out.println("<pre style='background:#f3f4f6; color:#1f2937; padding:15px; border-radius:6px; overflow-x:auto; font-family:monospace;'>");
                java.io.StringWriter sw = new java.io.StringWriter();
                java.io.PrintWriter pw = new java.io.PrintWriter(sw);
                e.printStackTrace(pw);
                out.print(sw.toString());
                out.println("</pre>");
            } finally {
                if (conn != null) {
                    try { conn.close(); } catch(Exception ignored) {}
                }
            }
        %>
        <div style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #eee; font-size: 13px; color: #6b7280;">
            Sweet Crumbs Bakery · Diagnostic Tool
        </div>
    </div>
</body>
</html>
