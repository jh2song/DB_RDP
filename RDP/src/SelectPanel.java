import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

@SuppressWarnings("serial")
class SelectPanel extends JPanel {
		// 학과명
		private JLabel majorLabel;
		private JComboBox<String> majorCombo;
		// 이수 구분
		private JLabel cKindLabel;
		private JComboBox<String> cKindCombo;
		// 강좌명
		private JLabel cName;
		private JTextField cTextField;
		// 검색 버튼
		private JButton sButton;

		public SelectPanel() {
			// 학과명 세팅
			majorLabel = new JLabel("학과명");
			String majors[] = { "선택", "컴퓨터공학과", "전기공학과", "건축공학과", "토목공학과", "전자공학과", "소프트웨어공학과" };
			majorCombo = new JComboBox<String>(majors);

			// 이수구분 세팅
			cKindLabel = new JLabel("이수구분");
			String kinds[] = { "선택", "전공필수", "전공선택", "자유교양", "공통교양"};
			cKindCombo = new JComboBox<String>(kinds);

			// 강좌명 세팅
			cName = new JLabel("강좌명");
			cTextField = new JTextField(10);

			// 검색버튼 세팅
			sButton = new JButton("검색");
			
			add(majorLabel);
			add(majorCombo);
			add(cKindLabel);
			add(cKindCombo);
			add(cName);
			add(cTextField);
			add(sButton);
			
			// 3번. Statement 사용
			sButton.addActionListener(new ActionListener() {
				@Override
				public void actionPerformed(ActionEvent e) {
					String query = "SELECT 강좌.강좌명, 학과.학과명, 강좌.이수구분, 강좌.연도, 강좌.학기 "
							+ "FROM 강좌, 학과 "
							+ "WHERE 강좌.학과코드=학과.학과코드 ";
						
					String c1 = (String)majorCombo.getSelectedItem();
					System.out.println(c1);
					String c2 = (String)cKindCombo.getSelectedItem();
					System.out.println(c2);
					String c3 = cTextField.getText();
						
					if(!c1.equals("선택")) {
						query += "AND 학과.학과명='" + c1 + "' ";
					}
					if(!c2.equals("선택")) {
						query += "AND 강좌.이수구분='" + c2 + "' ";
					}
					if(!c3.equals("")) {
						query += "AND 강좌.강좌명='" + c3 +"'";
					}
					System.out.println(query);
					TablePanel.getInstance().tableUpdate(query);	
				}
			});
		}
	}