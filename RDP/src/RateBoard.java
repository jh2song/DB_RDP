import java.awt.Container;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;

public class RateBoard extends JFrame{
	private Container c;
	private JButton rateButton;
	public RateBoard(String cName, String major, String year, String sem) {
		setTitle(cName);
		setSize(500,800);
		int courseCode;
		String usrId = MainRdp.getInstance().getUsrId();
		// 컨테이너 세팅
		c = getContentPane();
		c.setLayout(new BoxLayout(c, BoxLayout.Y_AXIS));
		// 화면에 표시할 정보 받기
		try {
			// 5번. CallableStatement 사용
			CallableStatement cstmt = MainRdp.getInstance().getDbc().
					con.prepareCall("{call SP_allRateSession(?,?,?,?,?,?,?,?)}");
			
			cstmt.setString(1,cName);
			cstmt.setString(2,major);
			cstmt.registerOutParameter(3, java.sql.Types.NVARCHAR);
			cstmt.setInt(4,Integer.parseInt(year));
			cstmt.setInt(5,Integer.parseInt(sem));
			cstmt.registerOutParameter(6, java.sql.Types.NVARCHAR);
			cstmt.registerOutParameter(7, java.sql.Types.DOUBLE);
			cstmt.registerOutParameter(8, java.sql.Types.INTEGER);
			cstmt.executeUpdate();
			
			
			
			String professor = cstmt.getString(3);
			String bookName = cstmt.getString(6);
			double rating = cstmt.getDouble(7);
			courseCode = cstmt.getInt(8);
			
			// Panel 추가
			add(new JLabel("강좌명: " + cName));
			add(new JLabel("학과명: " + major));
			add(new JLabel("교수: " + professor));
			add(new JLabel("연도: " + year));
			add(new JLabel("학기: " + sem));
			add(new JLabel("교재: " + bookName));
			add(new JLabel("전체평점: " + Double.toString(rating)));
			
			// 수강평가 남기기
			rateButton = new JButton("수강평가 남기기");
			add(rateButton);
			
			// 강의 평 순차적으로 나오기
	
			String query = "SELECT 댓글, 평점, 사용자ID "
					+ "FROM 수강평가게시판 "
					+ "WHERE 강좌코드=";
			Statement stmt = MainRdp.getInstance().getDbc().con.createStatement();
			String nQuery = query + Integer.toString(courseCode);
			ResultSet rs = stmt.executeQuery(nQuery);
			while(rs.next()) {
				String comment = rs.getString(1);
				int rate = rs.getInt(2);
				String id = rs.getString(3);
				add(new Comment(comment, rate, id, cName, courseCode));	
			}
				
			stmt.close(); rs.close();
			
			
			// '수강평가 남기기' 버튼 클릭 이벤트
			rateButton.addActionListener(new ActionListener() {
				@Override
				public void actionPerformed(ActionEvent arg0) {
					try {
						if(usrId == null) {
							JOptionPane.showMessageDialog(null,  "로그인 해야 평가를 할 수 있습니다.", "평가 불가", JOptionPane.ERROR_MESSAGE);
							return;
						}
						
						CallableStatement cstmt2 = MainRdp.getInstance().getDbc().
								con.prepareCall("{call SP_isRated(?,?,?)}");
						
						cstmt2.setInt(1, courseCode);
						cstmt2.setString(2, usrId);
						cstmt2.registerOutParameter(3, java.sql.Types.INTEGER);
						cstmt2.executeUpdate();
						
						int isRated = cstmt2.getInt(3);
						cstmt2.close();
						if(isRated == 1) {
							JOptionPane.showMessageDialog(null, "이미 평가 했습니다.", "평가 불가", JOptionPane.ERROR_MESSAGE);
						} else {
							new RateSession(cName, courseCode, usrId);
						}
						
					} catch (SQLException e2) {e2.printStackTrace();}
					
				}
			});
		
			
			cstmt.close();
		} catch (SQLException e) {e.printStackTrace();}
		setVisible(true);
	}
}
