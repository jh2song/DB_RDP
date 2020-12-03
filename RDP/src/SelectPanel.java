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
			String majors[] = { "컴퓨터 공학과", "전기 공학과", "건축 공학과", "토목 공학과", "전자 공학과", "소프트웨어 공학과" };
			majorCombo = new JComboBox<String>(majors);

			add(majorLabel);
			add(majorCombo);

			// 이수구분 세팅
			cKindLabel = new JLabel("이수구분");
			String kinds[] = { "전공 필수", "전공 핵심", "자유 교양", "공통 교양", "자유 선택" };
			cKindCombo = new JComboBox<String>(kinds);

			add(cKindLabel);
			add(cKindCombo);

			// 강좌명 세팅
			cName = new JLabel("강좌명");
			cTextField = new JTextField(10);

			add(cName);
			add(cTextField);

			// 검색버튼 세팅
			sButton = new JButton("검색");
			add(sButton);
		}
	}