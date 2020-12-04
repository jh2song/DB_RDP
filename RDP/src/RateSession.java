import java.awt.Container;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
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
		
		add(comLabel);
		add(comTextArea);
		add(rateLabel);
		add(rateTextField);
		add(regButton);
		
		
		setVisible(true);
	}
}
