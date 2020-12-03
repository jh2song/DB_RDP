import java.awt.Container;
import java.sql.CallableStatement;
import java.sql.SQLException;

import javax.swing.BoxLayout;
import javax.swing.JFrame;
import javax.swing.JLabel;

public class RateSession extends JFrame{
	private Container c;
	
	public RateSession(String cName, String major, String year, String sem) {
		setTitle(cName);
		setSize(500,800);
		
		// 컨테이너 세팅
		c = getContentPane();
		c.setLayout(new BoxLayout(c, BoxLayout.Y_AXIS));
		
		// 화면에 표시할 정보 받기
		try {
			// 5번. CallableStatement 사용
			CallableStatement cstmt = MainRdp.getInstance().getDbc().
					con.prepareCall("{call SP_allRateSession(?,?,?,?,?,?,?)}");
			
			cstmt.setString(1,cName);
			cstmt.setString(2,major);
			cstmt.registerOutParameter(3, java.sql.Types.NVARCHAR);
			cstmt.setInt(4,Integer.parseInt(year));
			cstmt.setInt(5,Integer.parseInt(sem));
			cstmt.registerOutParameter(6, java.sql.Types.NVARCHAR);
			cstmt.registerOutParameter(7, java.sql.Types.DOUBLE);
			cstmt.executeUpdate();
			

			String professor = cstmt.getString(3);
			String bookName = cstmt.getString(6);
			double rating = cstmt.getDouble(7);
			
			
			// Panel 추가
			add(new JLabel("강좌명: " + cName));
			add(new JLabel("학과명: " + major));
			add(new JLabel("교수: " + professor));
			add(new JLabel("연도: " + year));
			add(new JLabel("학기: " + sem));
			add(new JLabel("교재: " + bookName));
			add(new JLabel("전체평점: " + Double.toString(rating)));
		} catch (SQLException e) {e.printStackTrace();}

		
		setVisible(true);
	}
}
