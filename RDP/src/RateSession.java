import java.awt.Container;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;

public class RateSession extends JFrame {
	private Container c;
	private JLabel comLabel; // commentLabel
	private JLabel rateLabel;
	private JTextArea comTextArea;
	private JTextField rateTextField;
	private JButton regButton;
	
	public RateSession(String cName, int courseCode, String usrId) {
		setTitle(cName + "강좌 강의평 세션");
		setSize(300,300);
		
		c = getContentPane();
		c.setLayout(new BoxLayout(c, BoxLayout.Y_AXIS));
		
		comLabel = new JLabel("강의평");
		rateLabel = new JLabel("평점");
		comTextArea = new JTextArea(5,20);
		rateTextField = new JTextField(3);
		regButton = new JButton("등록");
		comTextArea.setLineWrap(true);
		
		comLabel.setAlignmentX(c.LEFT_ALIGNMENT);
		rateLabel.setAlignmentX(c.LEFT_ALIGNMENT);
		comTextArea.setAlignmentX(c.LEFT_ALIGNMENT);
		rateTextField.setAlignmentX(c.LEFT_ALIGNMENT);
		regButton.setAlignmentX(c.LEFT_ALIGNMENT);
		
		
		add(comLabel);
		add(comTextArea);
		add(rateLabel);
		add(rateTextField);
		add(regButton);
		
		regButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				System.out.println("RateSession Button Event");
				// 예외처리
				String comment = comTextArea.getText();
				int rateNum;
				// 평이 너무 짧다면 예외처리
				if(comment.length() < 20) {
					JOptionPane.showMessageDialog(null, "평이 너무 짧습니다.", "등록 실패", JOptionPane.ERROR_MESSAGE );
					return;
				}
				// 평점이 숫자가 아니고 0~5가 아니면 예외처리
				rateNum = convertInt(rateTextField.getText());
				if(rateNum == -1) {
					JOptionPane.showMessageDialog(null, "평점이 잘못된 형식입니다.", "등록 실패", JOptionPane.ERROR_MESSAGE);
					return;
				}
				
				try {
					// 이 세션을 연 주체가 Update 이벤트인지 Insert 이벤트인지 판별
					String query = "SELECT * FROM 수강평가게시판 WHERE 사용자ID='"+usrId+"' AND 강좌코드="+Integer.toString(courseCode);
					Statement stmt = MainRdp.getInstance().getDbc().con.createStatement();
					ResultSet rs = stmt.executeQuery(query);
					
					
					
					if(rs.next()) {// update
						PreparedStatement pstmt = MainRdp.getInstance().getDbc().con.prepareStatement
								("UPDATE 수강평가게시판 SET 댓글=?, 평점=? WHERE 강좌코드=? AND 사용자ID=?");
						pstmt.setString(1, comment);
						pstmt.setInt(2, rateNum);
						pstmt.setInt(3, courseCode);
						pstmt.setString(4, usrId);
						ResultSet rs2 = pstmt.executeQuery();
						pstmt.close(); rs2.close();
					} else { // insert
						PreparedStatement pstmt = MainRdp.getInstance().getDbc().con.prepareStatement
								("INSERT INTO 수강평가게시판 VALUES (SEQ_POST.NEXTVAL,?,?,?,?)");
						
							pstmt.setInt(1, courseCode);				
							pstmt.setInt(2, rateNum);
							pstmt.setString(3, usrId);
							pstmt.setString(4, comment);
							ResultSet rs2 = pstmt.executeQuery();
							pstmt.close(); rs2.close();
					}
					stmt.close(); rs.close();
					dispose();
				} catch(SQLException e2) {e2.printStackTrace();}
			}
		});
		setVisible(true);
	}
	
	public int convertInt(String s) {
		if(s.length()!=1) return -1;
		char c = s.charAt(0);
		if (c < '0' || c > '5')
			return -1;
		
		return c-'0';
	}

}
