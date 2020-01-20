package com.cfoco.entity;

import java.util.Date;

/**
 * 饲养员实体
 * @author Administrator
 *
 */
public class Breeder {
	
	private Integer breid;
	private String  brename;
	private Integer sex;
	private String cardno;
	private String phone;
	private String username;
	private String password;
	private Integer is_manager;
	private Integer if_valid;	
	private Date create_time;
    
	public Date getCreate_time() {
		return create_time;
	}
	public void setCreate_time(Date create_time) {
		this.create_time = create_time;
	}
	public Integer getBreid() {
		return breid;
	}
	public void setBreid(Integer breid) {
		this.breid = breid;
	}
	public String getBrename() {
		return brename;
	}
	public void setBrename(String brename) {
		this.brename = brename;
	}
	public Integer getSex() {
		return sex;
	}
	public void setSex(Integer sex) {
		this.sex = sex;
	}
	public String getCardno() {
		return cardno;
	}
	public void setCardno(String cardno) {
		this.cardno = cardno;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public Integer getIs_manager() {
		return is_manager;
	}
	public void setIs_manager(Integer is_manager) {
		this.is_manager = is_manager;
	}
	public Integer getIf_valid() {
		return if_valid;
	}
	public void setIf_valid(Integer if_valid) {
		this.if_valid = if_valid;
	}
}