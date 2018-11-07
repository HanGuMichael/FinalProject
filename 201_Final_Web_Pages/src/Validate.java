

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
 * Servlet implementation class Validate
 */
@WebServlet("/Validate")
public class Validate extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
    /**
     * @see HttpServlet#HttpServlet()
     */
	
	 //SQL Stuff
    Connection conn;
	Statement st;
	ResultSet rs;
	
	ResultSet searchResults;
	
    public Validate() {
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
		
		if(username != null)
		{
			try
			{
				rs = st.executeQuery("SELECT * FROM users WHERE username="+username+" AND password="+password);
				
				if(rs.next())
				{
					//login is valid
				}
				
				else
				{
					//login is invalid
				}
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
