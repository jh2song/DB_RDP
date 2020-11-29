import java.awt.*;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;

@SuppressWarnings("serial")
public class MainRdp extends JFrame{
	
	public MainRdp() {
		setTitle("동의대 수강 평가 시스템");
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);		
		setSize(800,500);		
		
		// 컨테이너 세팅
		Container c = getContentPane();
		c.setLayout(new FlowLayout());
		
		// Panel 추가
		c.add(new LoginPanel());
		c.add(new SelectPanel());
		c.add(new TabelPanel());
		
		
		setVisible(true);
	}
	
	class LoginPanel extends Panel {
		private JLabel idLabel;
		private JTextField idTextField;
		private JLabel pwLabel;
		private JPasswordField pwField;
		private JButton loginButton;
		
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
		}
	}
	
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
			String majors[] = {"컴퓨터 공학과","전기 공학과","건축 공학과",
					"토목 공학과", "전자 공학과", "소프트웨어 공학과"};
			majorCombo = new JComboBox<String>(majors);
			
			add(majorLabel);
			add(majorCombo);
			
			// 이수구분 세팅
			cKindLabel = new JLabel("이수구분");
			String kinds[] = {"전공 필수","전공 핵심","자유 교양","공통 교양","자유 선택"};
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
	
	class TabelPanel extends JPanel {
		// Table 생성
		private String colName[] = {"강좌명","학과명","이수구분","연도","학기"};
		private DefaultTableModel model = new DefaultTableModel(colName, 0);
		private JTable table = new JTable(model);
		private JPanel pan = new JPanel();
		public TabelPanel() {
			// JDBC로 테이블에 튜플 하나씩 추가해야됨
			
			//
			pan.add(new JScrollPane(table));
			add(pan);
		}
	}
	
	public static void main(String[] args) {
		new MainRdp();
	}

}