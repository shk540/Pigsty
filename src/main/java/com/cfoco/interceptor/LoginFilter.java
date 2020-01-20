package com.cfoco.interceptor;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.util.StringUtils;


public class LoginFilter implements Filter {
	
	 private String excludedPaths; 
	 private String [] excludedPathArray;
	 
    public void doFilter(ServletRequest arg0, ServletResponse arg1, FilterChain arg2)
            throws IOException, ServletException {
        // TODO Auto-generated method stub
        HttpServletRequest request = (HttpServletRequest)arg0;
        HttpServletResponse response = (HttpServletResponse)arg1;
        HttpSession session = request.getSession();
        //ServletContext application=request.getSession().getServletContext();
        
/*        if(session.getAttribute("_CURRENT_USER") != null){
            arg2.doFilter(arg0, arg1);
            return;
        }
        if(request.getRequestURI().indexOf("home.action") != -1 || request.getRequestURI().indexOf("login.action") != -1){
            arg2.doFilter(arg0, arg1);
            return;
        }
        // 没有登录
        response.sendRedirect(request.getContextPath()+"/home.action");*/
        //if(!isFilterExcludeRequest(request)) {
        if(session.getAttribute("currentBreeder")==null && request.getRequestURI().indexOf("/login") == -1)
        {
            // 没有登录
            response.sendRedirect(request.getContextPath()+"/login.jsp");
        }else{
            // 已经登录，继续请求下一级资源（继续访问）
            arg2.doFilter(arg0, arg1);
        }
       // }
    }
    @SuppressWarnings("unused")
	private boolean isFilterExcludeRequest(HttpServletRequest request) {

        if(null != excludedPathArray && excludedPathArray.length > 0) {

            String url = request.getRequestURI();

            for (String ecludedUrl : excludedPathArray) {

                if (ecludedUrl.startsWith("*.")) {

                    // 如果配置的是后缀匹配, 则把前面的*号干掉，然后用endWith来判断

                    if(url.endsWith(ecludedUrl.substring(1))){

                        return true;

                    }

                } else if (ecludedUrl.endsWith("/*")) {

                    if(!ecludedUrl.startsWith("/")) {

                        // 前缀匹配，必须要是/开头

                        ecludedUrl = "/" + ecludedUrl;

                    }

                    // 如果配置是前缀匹配, 则把最后的*号干掉，然后startWith来判断

                    String prffixStr = request.getContextPath() + ecludedUrl.substring(0, ecludedUrl.length() - 1);

                    if(url.startsWith(prffixStr)) {

                        return true;

                    }

                } else {

                    // 如果不是前缀匹配也不是后缀匹配,那就是全路径匹配

                    if(!ecludedUrl.startsWith("/")) {

                        // 全路径匹配，也必须要是/开头

                        ecludedUrl = "/" + ecludedUrl;

                    }

                    String targetUrl = request.getContextPath() + ecludedUrl;

                    if(url.equals(targetUrl)) {

                        return true;

                    }

                }

            }

        }

        return false;

      }
    public void init(FilterConfig filterConfig) throws ServletException {
        // TODO Auto-generated method stub
    	// 初始化时读取web.xml中配置的init-param
    	        excludedPaths = filterConfig.getInitParameter("excludedPaths");
    	        if(!StringUtils.isEmpty(excludedPaths)){
    	            excludedPathArray = excludedPaths.split(",");
    	        }
    }
     
    public void destroy() {
        // TODO Auto-generated method stub
    }
}