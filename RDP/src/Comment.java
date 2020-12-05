import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

public class Comment extends JPanel {
	private String comment;
	private int rate;
	private String id;
	
	private JButton uButton; // 수정버튼
	private JButton dButton; // 삭제버튼
	public Comment(String comment, int rate, String id, String cName, int courseCode) {
		this.comment = comment;
		this.rate = rate;
		this.id = id;
		
		this.setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));
		
		uButton = new JButton("수정");
		dButton = new JButton("삭제");
		
		add(new JLabel("익명"));
		add(new JLabel("강의평: " + comment));
		add(new JLabel("평점: " + Integer.toString(rate)));
		add(uButton);
		add(dButton);
		
		// 수정버튼
		uButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if(MainRdp.getInstance().getUsrId().equals(id)) {
					new RateSession(cName, courseCode, id);
				} else {
					JOptionPane.showMessageDialog(null, "내가 쓴 강의평만 수정할 수 있습니다.", "수정 실패", JOptionPane.ERROR_MESSAGE);
				}
			}
		});
		
		// 삭제 버튼
		dButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if(MainRdp.getInstance().getUsrId().equals(id)) {
					// 삭제 실행
					try {
						PreparedStatement pstmt = MainRdp.getInstance().getDbc().con.prepareStatement
								("DELETE FROM 수강평가게시판 WHERE 강좌코드=? AND 사용자ID=?");
						
						pstmt.setInt(1, courseCode);
						pstmt.setString(2, id);
						ResultSet rs = pstmt.executeQuery();	
						pstmt.close(); rs.close();		
					} catch (SQLException e2) {e2.printStackTrace();}
				} else {
					JOptionPane.showMessageDialog(null, "내가 쓴 강의평만 삭제할 수 있습니다.", "삭제 실패", JOptionPane.ERROR_MESSAGE);
				}
			}
		});
	}
}
