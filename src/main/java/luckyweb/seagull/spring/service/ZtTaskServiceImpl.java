package luckyweb.seagull.spring.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import luckyweb.seagull.spring.dao.ZtTaskDao;
import luckyweb.seagull.spring.entity.ZtTask;



@Service("zttaskService")
public class ZtTaskServiceImpl implements ZtTaskService{
	
	private ZtTaskDao zttaskdao;
	
	private static String  orderBy=" order by versionid desc,id desc ";
	
	public ZtTaskDao getZtTaskDao() {
		return zttaskdao;
	}

	@Resource(name = "zttaskDao")
	public void setZtTaskDao(ZtTaskDao zttaskdao) {
		this.zttaskdao = zttaskdao;
	}
	
	@Override
	public ZtTask load(int id) throws Exception {
		// TODO Auto-generated method stub		
		return this.zttaskdao.load(id);
	}
	
	@Override
	public int add(ZtTask zt) throws Exception {
		// TODO Auto-generated method stub		
		return this.zttaskdao.add(zt);
	}

	@Override
	public void delete(int versionid) throws Exception {
		String sql="delete from QA_ZTTASK where versionid="+versionid;
		this.zttaskdao.delete(sql);
	}
	
	@Override
	public List findByPage(Object value, int offset, int pageSize) {
		String	hql=" from ZtTask  "+where((ZtTask)value)+orderBy;
		List list= zttaskdao.findByPage(hql, value, offset, pageSize);
		return list;
	}
	
	@Override
	public int findRows(ZtTask zt) {
		String hql="select count(*) from ZtTask "+where(zt);
		return zttaskdao.findRows(zt, hql);
	}
	
	private String where(ZtTask zt) {
		String where = " where ";
		if (zt.getVersionid()!=0) {
			where += " versionid=:versionid  and ";
		}	
		if (zt.getDelaystatus()!=0&&!"".equals(zt.getDelaystatus())) {
			where += " delaystatus=:delaystatus  and ";
		}
		if (zt.getVersionname()!=null&&!"".equals(zt.getVersionname())) {
			where += " versionname like :versionname  and ";
		}
		if (zt.getFinishedname()!=null&&!"".equals(zt.getFinishedname())) {
			where += " finishedname like :finishedname  and ";
		}
		if (zt.getAssstartDate()!=null&&!"".equals(zt.getAssstartDate())) {
			where += " assignedDate>=:assstartDate  and ";
		}
		if (zt.getAssendDate()!=null&&!"".equals(zt.getAssendDate())) {
			where += " assignedDate<=:assendDate  and ";
		}
		if (where.length() == 7) {
			where = "";
		} 
		else{
			where = where.substring(0, where.length() - 5);
		}
		return where;
	}
	
	public List findByPagereport(int offset, int pageSize,String startdate,String enddate,int type) throws Exception {
		String hql="";
		if(type==1){
			hql = "select finishedname,sum(t.estimate),sum(t.consumed),COUNT (CASE WHEN t.delaystatus=1 THEN 1 ELSE NULL  END) 未延迟任务,"
					+ "COUNT (CASE WHEN t.delaystatus=2 THEN 1 ELSE NULL  END) 延迟任务,finishedname as pertask,finishedname as pertime  from QA_ZTTASK t where t.assigneddate>= '"+startdate+" 00:00:00.0' "
					+ "and t.assigneddate<='"+enddate+" 24:59:59.59' group by t.finishedname";
		}else{
			hql = "select versionname,sum(t.estimate),sum(t.consumed),COUNT (CASE WHEN t.delaystatus=1 THEN 1 ELSE NULL  END) 未延迟任务,"
					+ "COUNT (CASE WHEN t.delaystatus=2 THEN 1 ELSE NULL  END) 延迟任务,versionname as pertask,versionname as pertime  from QA_ZTTASK t where t.assigneddate>= '"+startdate+" 00:00:00.0' "
					+ "and t.assigneddate<='"+enddate+" 24:59:59.59' group by t.versionname";
		}		
		return this.zttaskdao.findByPagereport(hql, offset, pageSize);
	}
	
	public int findRowsreport(String startdate,String enddate,int type) {
		String hql="";
		if(type==1){
			hql = "select finishedname from QA_ZTTASK t where t.assigneddate>= '"+startdate+" 00:00:00.0' "
					+ "and t.assigneddate<='"+enddate+" 24:59:59.59' group by t.finishedname";
		}else{
			hql = "select versionname from QA_ZTTASK t where t.assigneddate>= '"+startdate+" 00:00:00.0' "
					+ "and t.assigneddate<='"+enddate+" 24:59:59.59' group by t.versionname";
		}
		return this.zttaskdao.findRowsreport(hql);
	}
}
