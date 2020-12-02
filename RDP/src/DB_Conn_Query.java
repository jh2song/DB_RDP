import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

class DB_Conn_Query {
	Connection con = null;
	public DB_Conn_Query() {
		String url = "jdbc:oracle:thin:@localhost:1521:XE";
		String id = "rdp";
		String password = "1234";
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			System.out.println("드라이버 적재 성공");
			con = DriverManager.getConnection(url, id, password);
			System.out.println("DB 연결 성공");
		} catch (ClassNotFoundException e) {
			System.out.println("No Driver.");
		} catch (SQLException e) {
			System.out.println("Connection Fail");
		}
	}
	/*
	public void finalize() {
		con.close();
	}
	*/
}
