import java.awt.Container;

import javax.swing.BoxLayout;
import javax.swing.JFrame;

@SuppressWarnings("serial")
public class MainRdp extends JFrame{
    static private MainRdp instance;
    
    private Container c;
	private DB_Conn_Query dbc;
	private String usrId;
	private String usrName;
	
    public static MainRdp getInstance() {
    	if (instance == null)
            instance = new MainRdp();
        
        return instance;
    }
	
	public MainRdp() {
		instance = this;
		
		dbc = new DB_Conn_Query();
		if (dbc.con == null) return;
		else System.out.println("Main db 연결");
		
		setTitle("동의대 수강 평가 시스템");
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setSize(800, 500);

		// 컨테이너 세팅
		c = getContentPane();
		c.setLayout(new BoxLayout(c, BoxLayout.Y_AXIS));
		
		// Panel 추가
		c.add(new LoginPanel());
		c.add(new SelectPanel());
		c.add(TablePanel.getInstance());

		setVisible(true);
	}

	public void setUsrId(String usrId) {this.usrId = usrId;}
	public void setUsrName(String usrName) {this.usrName = usrName;}
	public DB_Conn_Query getDbc() {return dbc;}
	public Container getContainer() {return c;}
	public static void main(String[] args) {
		new MainRdp();
	}
}