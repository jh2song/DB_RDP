import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

/*
class JTableExample extends JFrame {
   // Table 생성
    private String colName[] = { "이름", "나이", "직업" };
    private DefaultTableModel model = new DefaultTableModel(colName, 0);
   // Table에 들어갈 데이터 목록들 (헤더정보, 추가 될 row 개수)
    private JTable table = new JTable(model);
    private JScrollPane jsp = new JScrollPane(table, 
    			JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED, 									
    			JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
    public JTableExample() {
     //== 기본 설정(title, size…)이 추가해야 함==
     // JTable에 삽입될 데이터 생성. while(rs.next()) {       } 도 가능
    	this.setSize(500, 200);
    	String row1[] = new String[3];
    	row1[0] = "오빠";
     	row1[1] = "26";
     	row1[2] = "프로그래머"; model.addRow(row1); 
     	//String row2[] = new String[3];
     	row1[0] = "싱고";
     	row1[1] = "26";
     	row1[2] = "백수";  	  model.addRow(row1);
     	add(jsp);
     	setVisible(true);
     }
}
*/
class DB_Conn_Query {
	   Connection con = null;
	   public DB_Conn_Query( ) {
	     String url = "jdbc:oracle:thin:@localhost:1521:XE";
	     String id = "hmart";      String password = "1234";
	     try {   Class.forName("oracle.jdbc.driver.OracleDriver");
	        System.out.println("드라이버 적재 성공");
	        con = DriverManager.getConnection(url, id, password);
	        System.out.println("DB 연결 성공");
	     } catch (ClassNotFoundException e) {         System.out.println("No Driver.");    }
	       catch (SQLException e) {         System.out.println("Connection Fail");      }
	   }
	   public void sqlrun(DefaultTableModel model)
	   {
		   String query = "select 고객아이디, 고객이름, 적립금 from 고객";
		   try {
			   Statement stmt = con.createStatement();
			   ResultSet rs = stmt.executeQuery(query);
			   String row[] = new String[3];
			   while (rs.next()) {
				   row[0] = rs.getString("고객아이디");
				   row[1] = rs.getString(2);
				   row[2] = Integer.toString(rs.getInt(3));
				   model.addRow(row);
			   }
               stmt.close();    rs.close();     con.close();
		   }catch (SQLException e) { e.printStackTrace(); }
	   }
}

class JTableExample extends JFrame {
	   // Table 생성
	    private String colName[] = { "고객ID", "이름", "적립금" };
	    public DefaultTableModel model = new DefaultTableModel(colName, 0);
	   // Table에 들어갈 데이터 목록들 (헤더정보, 추가 될 row 개수)
	    private JTable table = new JTable(model);
	    private JScrollPane jsp = new JScrollPane(table, 
	    			JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED, 									
	    			JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
	    public JTableExample() {
	    	this.setSize(500, 200);
	    	add(jsp);
	     	setVisible(true);
	     }
	}
public class JTableDriver {

	public static void main(String[] args) {
		DB_Conn_Query dbc = new DB_Conn_Query();
        if (dbc.con == null) return;
     
		JTableExample jt = new JTableExample();
		dbc.sqlrun(jt.model);
	}
}
