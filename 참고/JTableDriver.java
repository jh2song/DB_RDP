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
   // Table ����
    private String colName[] = { "�̸�", "����", "����" };
    private DefaultTableModel model = new DefaultTableModel(colName, 0);
   // Table�� �� ������ ��ϵ� (�������, �߰� �� row ����)
    private JTable table = new JTable(model);
    private JScrollPane jsp = new JScrollPane(table, 
    			JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED, 									
    			JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
    public JTableExample() {
     //== �⺻ ����(title, size��)�� �߰��ؾ� ��==
     // JTable�� ���Ե� ������ ����. while(rs.next()) {       } �� ����
    	this.setSize(500, 200);
    	String row1[] = new String[3];
    	row1[0] = "����";
     	row1[1] = "26";
     	row1[2] = "���α׷���"; model.addRow(row1); 
     	//String row2[] = new String[3];
     	row1[0] = "�̰�";
     	row1[1] = "26";
     	row1[2] = "���";  	  model.addRow(row1);
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
	        System.out.println("����̹� ���� ����");
	        con = DriverManager.getConnection(url, id, password);
	        System.out.println("DB ���� ����");
	     } catch (ClassNotFoundException e) {         System.out.println("No Driver.");    }
	       catch (SQLException e) {         System.out.println("Connection Fail");      }
	   }
	   public void sqlrun(DefaultTableModel model)
	   {
		   String query = "select �����̵�, ���̸�, ������ from ��";
		   try {
			   Statement stmt = con.createStatement();
			   ResultSet rs = stmt.executeQuery(query);
			   String row[] = new String[3];
			   while (rs.next()) {
				   row[0] = rs.getString("�����̵�");
				   row[1] = rs.getString(2);
				   row[2] = Integer.toString(rs.getInt(3));
				   model.addRow(row);
			   }
               stmt.close();    rs.close();     con.close();
		   }catch (SQLException e) { e.printStackTrace(); }
	   }
}

class JTableExample extends JFrame {
	   // Table ����
	    private String colName[] = { "��ID", "�̸�", "������" };
	    public DefaultTableModel model = new DefaultTableModel(colName, 0);
	   // Table�� �� ������ ��ϵ� (�������, �߰� �� row ����)
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
