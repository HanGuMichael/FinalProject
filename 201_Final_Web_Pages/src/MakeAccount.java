

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class MakeAccount
 */
@WebServlet("/MakeAccount")
public class MakeAccount extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
	
	 //SQL Stuff
    Connection conn;
	Statement st;
	ResultSet rs;
	
	ResultSet searchResults;
	
    public MakeAccount() {
        super();
        
        conn = null;
        st = null;
        rs = null;
        
        try {
        	
        	Class.forName("com.mysql.jdbc.Driver");
        	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/tanksdb?user=root&password=root&useSSL=false");
            st = conn.createStatement();
            
            }
            
            catch(SQLException sqle)
            {
            	
            }
            
            catch(ClassNotFoundException cnfe)
            {
            	
            }
            
            finally {
    			try {
    				if (rs != null) {
    					rs.close();
    				}
    			} catch (SQLException sqle) {
    				System.out.println("sqle: " + sqle.getMessage());
    			}
    		}
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String email = request.getParameter("email");
		
		if(username != null)
		{
			try
			{
				st.executeUpdate("INSERT INTO users " + "VALUES (\""+username+"\", \""+password+"\", \""+email+"\", 0)");
			}
			
			catch(SQLException sqle)
			{
				
			}
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
