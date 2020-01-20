package com.cfoco.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

public class LoginInterceptor implements HandlerInterceptor{

	@Override
	public boolean preHandle(HttpServletRequest request,HttpServletResponse response, Object handler) throws Exception {
		System.out.println("prehandle...");
		// 在拦截点执行前拦截，如果返回true则不执行拦截点后的操作（拦截成功）
		// 返回false则不执行拦截
		HttpSession session = request.getSession();
		String uri = request.getRequestURI(); // 获取登录的uri，这个是不进行拦截的
		
		if(session.getAttribute("currentBreeder")==null && uri.indexOf("/login")==-1) {//login表示登录请求
			response.sendRedirect(request.getContextPath()+"/login.jsp");//重定向---服务端将请求的资源位置返回客户端，客户端得到后再一次请求
			return false;
		}else {
			//而请求转发是利用request.getServletDispatcher(),直接将资源的内容发送给客户端
			return true;
		}

		
	}
	@Override
	public void postHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		System.out.println("postHandle...");
		
	}
	@Override
	public void afterCompletion(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		System.out.println("afterCompletion...");
		
	}
}