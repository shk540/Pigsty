package com.cfoco.entity;

public class Pigsty {
	
	private Integer psid;
	private String psno;
	private String psname;
	private Integer psstock;
	private String tuno;
	private String tuname;
	private String remark;
		
	public String getTuno() {
		return tuno;
	}
	public void setTuno(String tuno) {
		this.tuno = tuno;
	}
	public String getTuname() {
		return tuname;
	}
	public void setTuname(String tuname) {
		this.tuname = tuname;
	}
	public Integer getPsid() {
		return psid;
	}
	public void setPsid(Integer psid) {
		this.psid = psid;
	}
	public String getPsname() {
		return psname;
	}
	public void setPsname(String psname) {
		this.psname = psname;
	}
	public Integer getPsstock() {
		return psstock;
	}
	public void setPsstock(Integer psstock) {
		this.psstock = psstock;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getPsno() {
		return psno;
	}
	public void setPsno(String psno) {
		this.psno = psno;
	}
}