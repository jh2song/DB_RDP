import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

@SuppressWarnings("serial")
class TablePanel extends JPanel {
	private static TablePanel instance;
	// Table 생성
	private String colName[] = { "강좌명", "학과명", "이수구분", "연도", "학기" };
	private DefaultTableModel model;
	private JTable table;
		
	private String query = "SELECT 강좌.강좌명, 학과.학과명, 강좌.이수구분, 강좌.연도, 강좌.학기 "
			+"FROM 강좌, 학과 "
			+ "WHERE 강좌.학과코드=학과.학과코드";
	
	public static TablePanel getInstance() {
		if (instance == null)
			instance = new TablePanel();
		
		return instance;
	}
	
	public TablePanel() {
		// 셀 수정 안되게
		model = new DefaultTableModel(colName, 0) {
			@Override
			public boolean isCellEditable(int row, int column) {
				return false;
			}
		};
		table = new JTable(model);
		//
		
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
			
			table.addMouseListener(new java.awt.event.MouseAdapter() {
				@Override
				public void mouseClicked(java.awt.event.MouseEvent evt) {
					int row = table.getSelectedRow();
					// 보조 키
					String cName = (String)table.getValueAt(row, 0); // 강좌명
					String major = (String)table.getValueAt(row, 1); // 학과명
					String year = (String)table.getValueAt(row, 3); // 연도
					String sem = (String)table.getValueAt(row,4); // 학기
					
					new RateBoard(cName, major, year, sem);
				}
				
			});
			
			add(new JScrollPane(table));
			// 리소스 해제
			stmt.close(); rs.close();
		} catch (SQLException e) { e.printStackTrace();}
	}
	
	public void tableUpdate(String query) {
		model = (DefaultTableModel)table.getModel();
		model.setNumRows(0);
		
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
			
			removeAll();
			add(new JScrollPane(table));
			revalidate();
			repaint();
			// 리소스 해제
			stmt.close(); rs.close();
		} catch (SQLException e) { e.printStackTrace();}
	}

}