package com.cfoco.entity;

import java.util.Date;

public class Pigsbre {
	
	private Integer id;
	private Pigsty pigsty;
	private Breeder breeder;
	private Date begin_date;
	private Date end_date;
	private Date update_time;
	
	private String psno;
	private String psname;
	private String username;
	private String brename;		
	private Integer pscn;
	private Integer usercn;
	private Integer psstock;
	
	private Integer if_valid;
	private Integer days;//分配天数
	
	public Integer getDays() {
		return days;
	}
	public void setDays(Integer days) {
		this.days = days;
	}
	public Integer getIf_valid() {
		return if_valid;
	}
	public void setIf_valid(Integer if_valid) {
		this.if_valid = if_valid;
	}
	public String getPsno() {
		return psno;
	}
	public Integer getPscn() {
		return pscn;
	}
	public void setPscn(Integer pscn) {
		this.pscn = pscn;
	}
	public Integer getUsercn() {
		return usercn;
	}
	public void setUsercn(Integer usercn) {
		this.usercn = usercn;
	}
	public void setPsno(String psno) {
		this.psno = psno;
	}
	public String getPsname() {
		return psname;
	}
	public void setPsname(String psname) {
		this.psname = psname;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getBrename() {
		return brename;
	}
	public void setBrename(String brename) {
		this.brename = brename;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Pigsty getPigsty() {
		return pigsty;
	}
	public void setPigsty(Pigsty pigsty) {
		this.pigsty = pigsty;
	}
	public Breeder getBreeder() {
		return breeder;
	}
	public void setBreeder(Breeder breeder) {
		this.breeder = breeder;
	}
	public Date getBegin_date() {
		return begin_date;
	}
	public void setBegin_date(Date begin_date) {
		this.begin_date = begin_date;
	}
	public Date getEnd_date() {
		return end_date;
	}
	public void setEnd_date(Date end_date) {
		this.end_date = end_date;
	}
	public Date getUpdate_time() {
		return update_time;
	}
	public void setUpdate_time(Date update_time) {
		this.update_time = update_time;
	}
	public Integer getPsstock() {
		return psstock;
	}
	public void setPsstock(Integer psstock) {
		this.psstock = psstock;
	}	
}
