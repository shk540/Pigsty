package com.cfoco.entity;

import java.util.Date;

public class Pigstyflow {
	
	private String flowid;
	private String psno;
	private Date create_time;
	private String typeno;
	private String flowdirect;
	private String batno;
	private Integer days;	
	private Integer amount;
	private Integer stock;
	private String username;
	private String if_check;//Y 已审核 N 未审核
	private Integer is_bat;//0 非批量 1 批量
	
	//关联表字段
	private String psname;
	private String typename;
	private String brename;
	private String tuname ;
	private String tuno;
	
	//标志位，是否需要更新
	private Integer if_update;
	
	public String getTuno() {
		return tuno;
	}
	public void setTuno(String tuno) {
		this.tuno = tuno;
	}
	private Integer inamount;
	public String getTuname() {
		return tuname;
	}
	public void setTuname(String tuname) {
		this.tuname = tuname;
	}
	public Integer getInamount() {
		return inamount;
	}
	public void setInamount(Integer inamount) {
		this.inamount = inamount;
	}
	public Integer getOutamount() {
		return outamount;
	}
	public void setOutamount(Integer outamount) {
		this.outamount = outamount;
	}
	private Integer outamount;
	
	public String getPsname() {
		return psname;
	}
	public void setPsname(String psname) {
		this.psname = psname;
	}
	public String getTypename() {
		return typename;
	}
	public void setTypename(String typename) {
		this.typename = typename;
	}
	public String getBrename() {
		return brename;
	}
	public void setBrename(String brename) {
		this.brename = brename;
	}
	
	public String getFlowid() {
		return flowid;
	}
	public void setFlowid(String flowid) {
		this.flowid = flowid;
	}
	public String getPsno() {
		return psno;
	}
	public void setPsno(String psno) {
		this.psno = psno;
	}
	public Date getCreate_time() {
		return create_time;
	}
	public void setCreate_time(Date create_time) {
		this.create_time = create_time;
	}
	public String getTypeno() {
		return typeno;
	}
	public void setTypeno(String typeno) {
		this.typeno = typeno;
	}
	public String getFlowdirect() {
		return flowdirect;
	}
	public void setFlowdirect(String flowdirect) {
		this.flowdirect = flowdirect;
	}
	public Integer getAmount() {
		return amount;
	}
	public void setAmount(Integer amount) {
		this.amount = amount;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getIf_check() {
		return if_check;
	}
	public void setIf_check(String if_check) {
		this.if_check = if_check;
	}
	public Integer getIs_bat() {
		return is_bat;
	}
	public void setIs_bat(Integer is_bat) {
		this.is_bat = is_bat;
	}
	public Integer getStock() {
		return stock;
	}
	public void setStock(Integer stock) {
		this.stock = stock;
	}	
	
	public String getBatno() {
		return batno;
	}
	public void setBatno(String batno) {
		this.batno = batno;
	}
	public Integer getDays() {
		return days;
	}
	public void setDays(Integer days) {
		this.days = days;
	}
	public Integer getIf_update() {
		return if_update;
	}
	public void setIf_update(Integer if_update) {
		this.if_update = if_update;
	}
}