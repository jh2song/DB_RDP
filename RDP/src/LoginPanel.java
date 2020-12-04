import java.awt.Panel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPasswordField;
import javax.swing.JTextField;

@SuppressWarnings("serial")
class LoginPanel extends Panel {
		private JLabel idLabel;
		private JTextField idTextField;
		private JLabel pwLabel;
		private JPasswordField pwField;
		private JButton loginButton;
		//private boolean isLogin = false;
		
		public LoginPanel() {
			
			// ID 세팅
			idLabel = new JLabel("ID : ");
			idTextField = new JTextField(8);
			// PW 세팅
			pwLabel = new JLabel("PASSWORD : ");
			pwField = new JPasswordField(10);
			// 로그인 버튼 세팅
			loginButton = new JButton("Login");
	
			add(idLabel);
			add(idTextField);
			add(pwLabel);
			add(pwField);
			add(loginButton);
			
			LoginPanel myJPanel = this;
			// 4번. PreparedStatement 사용 
			// (SQL Injection을 막기 위함)
			loginButton.addActionListener(new ActionListener() {
				@Override
				public void actionPerformed(ActionEvent e) {
					try {
						String idS = idTextField.getText();
						String pwS = new String(pwField.getPassword());
						
						PreparedStatement pstmt = MainRdp.getInstance().getDbc().con.prepareStatement
								("SELECT * "
								+ "FROM 사용자 "
								+ "WHERE 사용자ID=? AND 비밀번호=?");
						pstmt.setString(1, idS);
						pstmt.setString(2, pwS);
						
						ResultSet rs = pstmt.executeQuery();
						
						if(rs.next()) { // 로그인 성공
							myJPanel.removeAll();
								
							myJPanel.add(new JLabel(rs.getString("닉네임")+"님 환영합니다!!"));
								
							myJPanel.revalidate();
							myJPanel.repaint();
								
							MainRdp.getInstance().setUsrId(idS);
							MainRdp.getInstance().setUsrName(rs.getString("닉네임"));
							System.out.println("로그인 성공");
						} else { // 로그인 실패
							JOptionPane.showMessageDialog(null, "로그인 실패.", "로그인 실패.", JOptionPane.ERROR_MESSAGE);;
							System.out.println("로그인 실패");
						}
						
						
						pstmt.close();
					} catch(SQLException e2) { e2.printStackTrace();}
				}
			});
		}
	}