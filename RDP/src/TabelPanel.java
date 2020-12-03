import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

@SuppressWarnings("serial")
class TabelPanel extends JPanel {
		// Table 생성
		private String colName[] = { "강좌명", "학과명", "이수구분", "연도", "학기" };
		private DefaultTableModel model = new DefaultTableModel(colName, 0);
		private JTable table = new JTable(model);
		private JPanel pan = new JPanel();
		
		private String query = "SELECT 강좌.강좌명, 학과.학과명, 강좌.이수구분, 강좌.연도, 강좌.학기 "
				+"FROM 강좌, 학과 "
				+ "WHERE 강좌.학과코드=학과.학과코드";
		
		public TabelPanel() {
			// JDBC로 테이블에 튜플 하나씩 추가해야됨
			// 3번. Statement 사용
			try {
				Statement stmt = MainRdp.getInstance().getDbc().con.createStatement();
				ResultSet rs = stmt.executeQuery(query);
				String row[] = new String[5];
				while(rs.next()) {
					row[0] = rs.getString(1);
					row[1] = rs.getString(2);
					row[2] = rs.getString(3);
					row[3] = Integer.toString(rs.getInt(4));
					row[4] = Integer.toString(rs.getInt(5));
					model.addRow(row);
				}
				pan.add(new JScrollPane(table));
				add(pan);
				
				// 리소스 해제
				stmt.close(); rs.close();
			} catch (SQLException e) { e.printStackTrace();}
		}
	}