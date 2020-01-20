import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.eclipse.jdt.internal.compiler.ast.ArrayQualifiedTypeReference;
import org.junit.Test;
import org.springframework.dao.DeadlockLoserDataAccessException;

import net.sf.json.JSONObject;
import com.cfoco.util.StringUtil;;

public class Testjson {
	
	
	
@Test
public void jsontest() {
	
	List<String> strList=new ArrayList<>();
	strList.add("aaa");strList.add("bbb");
	JSONObject jsonObject=new JSONObject();
	jsonObject.put("str",strList);
	
	System.out.println(jsonObject);
}



@Test
public void jsontestmap() {
	
	Map<String,String> map_title=new HashMap<String,String>();
	map_title.put("create_time","日期");
	map_title.put("typename","流转类型");
	JSONObject jsonObject=new JSONObject();
	
	//jsonObject.put("str",map_title);
	jsonObject.fromObject(map_title);
	
	System.out.println(jsonObject.fromObject(map_title));
	
	System.out.println("20180112in".substring(1,8));
}

public static Date formatString(String str,String format) throws Exception{
	if(StringUtil.isEmpty(str)){
		return null;
	}
	SimpleDateFormat sdf=new SimpleDateFormat(format);
	return sdf.parse(str);
}

@Test
public  void testdate() throws Exception {
	System.out.println(formatString("2019-12-01","yyyy-MM-dd"));
}
}
