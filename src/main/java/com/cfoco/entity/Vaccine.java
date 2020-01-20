package com.cfoco.entity;

import java.util.Date;

public class Vaccine {
	
	private Integer id;
	private String vacname;
	private String psno;
	private Integer planage;
	private Date plandate;
	private Date realdate;
	private String username;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getVacname() {
		return vacname;
	}
	public void setVacname(String vacname) {
		this.vacname = vacname;
	}
	public String getPsno() {
		return psno;
	}
	public void setPsno(String psno) {
		this.psno = psno;
	}
	public Integer getPlanage() {
		return planage;
	}
	public void setPlanage(Integer planage) {
		this.planage = planage;
	}
	public Date getPlandate() {
		return plandate;
	}
	public void setPlandate(Date plandate) {
		this.plandate = plandate;
	}
	public Date getRealdate() {
		return realdate;
	}
	public void setRealdate(Date realdate) {
		this.realdate = realdate;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	
	

}
