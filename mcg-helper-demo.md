## 参数定义:extendJson
``` json
{
    "outputsFileName": {
        "entity":"${aria2File.property.className}",
        "dto":"${aria2File.property.className}Dto",
        "query":"${aria2File.property.className}Query",
        "dao":"${aria2File.property.className}Mapper",
        "convert":"${aria2File.property.className}ToDto",
        "service":"${aria2File.property.className}Service",
        "serviceImpl":"${aria2File.property.className}ServiceImpl",
        "controller":"${aria2File.property.className}Controller"
    },
    "outputsPath": {
        "entity":"${path}/model/entity",
        "dto":"${path}/model/dto",
        "query":"${path}/model/query",
        "dao":"${path}/dao",
        "convert":"${path}/model/converter",
        "service":"${path}/service",
        "serviceImpl":"${path}/service/impl",
        "controller":"${path}/controller"
    },
    "outputsPackage": {
        "entity":"${aria2File.property.packageName}.model.entity",
        "dto":"${aria2File.property.packageName}.model.dto",
        "query":"${aria2File.property.packageName}.model.query",
        "dao":"${aria2File.property.packageName}.dao",
        "convert":"${aria2File.property.packageName}.model.converter",
        "service":"${aria2File.property.packageName}.service",
        "serviceImpl":"${aria2File.property.packageName}.service.impl",
        "controller":"${aria2File.property.packageName}.controller"
    }
}
${extendJson.outputsPackage.dto}
```

## entity:aria2File
``` java
package ${aria2File.property.packageName}.model.entity;

import cn.shafish.db.BaseEntity;
import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModelProperty;

import java.util.Date;

/**
* ${aria2File.property.dataDesc}
* @author : ${author}
* @date : 2023-6-9
*/
@TableName("${aria2File.property.tableName}")
public class ${aria2File.property.className} extends BaseEntity<${aria2File.property.className}> {
    <#list aria2File.record! as item> 

    /** ${item.comment!} */
    <#if item.primary>
    @TableId(value = "${item.tableField!}",type = IdType.AUTO)
    <#elseif item.classField == "createdTime">
    @TableField(fill = FieldFill.INSERT)
    <#elseif item.classField == "updatedTime">
    @TableField(fill = FieldFill.INSERT_UPDATE)
    </#if>
    @ApiModelProperty(name = "${item.comment!}",notes = "")
    private ${item.dataType!} ${item.classField!};
    </#list>

    <#list aria2File.record! as item> 
    /** 获取 ${item.comment!} */
    public ${item.dataType!} get${item.classField? cap_first}(){
        return this.${item.classField!};
    }
    /** 设置 ${item.comment!} */
    public void set${item.classField? cap_first}(${item.dataType!} ${item.classField!}){
        this.${item.classField!}=${item.classField!};
    }
    </#list>
}
```

## dto:aria2File
``` java
package ${extendJson.outputsPackage.dto};

import java.util.Date;

/**
 * @author ${author}
 * @description：TODO
 * @date ：${.now}
 */
public class ${extendJson.outputsFileName.dto} {
    <#list aria2File.record! as item> 
    <#if item.param1 == "dto">

    /** ${item.comment!} */
    private ${item.dataType!} ${item.classField!};
    </#if>
    </#list>

    <#list aria2File.record! as item> 

    <#if item.param1 == "dto">
    /** 获取 ${item.comment!} */
    public ${item.dataType!} get${item.classField? cap_first}(){
        return this.${item.classField!};
    }

    /** 设置 ${item.comment!} */
    public void set${item.classField? cap_first}(${item.dataType!} ${item.classField!}){
        this.${item.classField!}=${item.classField!};
    }

    </#if>
    </#list>
}
```

## query:aria2File
``` java
package ${extendJson.outputsPackage.query};

import cn.shafish.http.BaseQuery;

import java.util.Date;

/**
 * @author ${author}
 * @description：TODO
 * @date ：${.now?date}
 */
public class ${extendJson.outputsFileName.query} extends BaseQuery {
    <#list aria2File.record! as item> 
    <#if item.param2 == "query">

    /** ${item.comment!} */
    private ${item.dataType!} ${item.classField!};
    </#if>
    </#list>

    <#list aria2File.record! as item> 
    <#if item.param2 == "query">
    /** 获取 ${item.comment!} */
    public ${item.dataType!} get${item.classField? cap_first}(){
        return this.${item.classField!};
    }

    /** 设置 ${item.comment!} */
    public void set${item.classField? cap_first}(${item.dataType!} ${item.classField!}){
        this.${item.classField!}=${item.classField!};
    }

    </#if>
    </#list>
}
```

## dao:aria2File
``` java
package ${extendJson.outputsPackage.dao};

import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.Constants;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import ${extendJson.outputsPackage.entity}.${extendJson.outputsFileName.entity};

 /**
 * 
 * @author : ${author}
 * @description：TODO
 * @date : ${.now?date}
 */
@Mapper
public interface ${extendJson.outputsFileName.dao} extends BaseMapper<${extendJson.outputsFileName.entity}>{
    /** 
     * 分页查询指定行数据
     *
     * @param page 分页参数
     * @param wrapper 动态查询条件
     * @return 分页对象列表
     */
    IPage<${extendJson.outputsFileName.entity}> selectByPage(IPage<${extendJson.outputsFileName.entity}> page, @Param(Constants.WRAPPER) Wrapper<${extendJson.outputsFileName.entity}> wrapper);
}
```

## converter:aria2File
``` java
package ${extendJson.outputsPackage.convert};

import ${extendJson.outputsPackage.entity}.${extendJson.outputsFileName.entity};
import ${extendJson.outputsPackage.dto}.${extendJson.outputsFileName.dto};
import org.mapstruct.InheritInverseConfiguration;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

/**
 * @author ：${author}
 * @description：TODO
 * @date ：${.now?date}
 */
@Mapper(componentModel = "spring")
public interface ${extendJson.outputsFileName.entity}ToDto {
    ${extendJson.outputsFileName.entity}ToDto INSTANCE = Mappers.getMapper(${extendJson.outputsFileName.entity}ToDto.class);

    ${extendJson.outputsFileName.dto} to${extendJson.outputsFileName.dto}(${extendJson.outputsFileName.entity} ${extendJson.outputsFileName.entity? uncap_first});

    @InheritInverseConfiguration(name = "to${extendJson.outputsFileName.dto}")
    ${extendJson.outputsFileName.entity} toFile(${extendJson.outputsFileName.dto} ${extendJson.outputsFileName.dto? uncap_first});

}
```

## queryConverter:aria2File
``` java
package ${extendJson.package.convertQuery};

import ${extendJson.package.dto}.${extendJson.fileName.dto};
import ${extendJson.package.query}.${extendJson.fileName.query};
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

/**
 * @author : ${author}
 * @description：TODO
 * @date : ${.now?date}
 */
@Mapper(componentModel = "spring")
public interface ${extendJson.fileName.convertQuery} {
    ${extendJson.fileName.convertQuery} INSTANCE = Mappers.getMapper(${extendJson.fileName.convertQuery}.class);

    // @Mapping(source = "title", target = "name")
    ${extendJson.fileName.dto} to${extendJson.fileName.dto}(${extendJson.fileName.query} ${extendJson.fileName.query? uncap_first});

}
```

## service:aria2File
``` java
package ${extendJson.outputsPackage.service};

import cn.shafish.db.BaseService;
import com.baomidou.mybatisplus.core.metadata.IPage;
import ${extendJson.outputsPackage.dto}.${extendJson.outputsFileName.dto};
import ${extendJson.outputsPackage.query}.${extendJson.outputsFileName.query};
import ${extendJson.outputsPackage.entity}.${aria2File.property.className};

import java.util.List;

/**
 * @author : ${author}
 * @description：TODO
 * @date : ${.now?date}
 */
public interface ${extendJson.outputsFileName.service} extends BaseService<${aria2File.property.className}> {

    /**
     * 新增数据
     * @param ${aria2File.property.className? uncap_first}
     * @return
     */
    boolean add(${aria2File.property.className} ${aria2File.property.className? uncap_first});

    /** 
     * 通过ID查询单条数据 
     *
     * @param id 主键
     * @return 实例对象
     */
    ${extendJson.outputsFileName.dto} getById(String id);

    /**
     * 通过指定值查询多条数据
     * @param ${extendJson.outputsFileName.query? uncap_first}
     * @return
     */
    List<${extendJson.outputsFileName.dto}> queryBy(${extendJson.outputsFileName.query} ${extendJson.outputsFileName.query? uncap_first});

    /**
     * 分页查询数据
     * @param ${extendJson.outputsFileName.query? uncap_first}
     * @return
     */
    IPage<${extendJson.outputsFileName.dto}> queryByPage(${extendJson.outputsFileName.query} ${extendJson.outputsFileName.query? uncap_first});

    /** 
     * 更新数据
     *
     * @param ${extendJson.outputsFileName.dto? uncap_first} 实例对象
     * @return 实例对象
     */
    boolean updateBy(${extendJson.outputsFileName.dto} ${extendJson.outputsFileName.dto? uncap_first});

    /** 
     * 通过主键删除数据
     *
     * @param id 主键
     * @return 是否成功
     */
    boolean deleteById(String id);

}
```

## serviceImpl:aria2File
``` java
package ${extendJson.package.serviceImpl};

import cn.shafish.db.BaseServiceImpl;
import cn.shafish.db.MyDbPage;
import com.baomidou.mybatisplus.core.toolkit.ObjectUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.core.metadata.IPage;
import ${extendJson.package.convert}.${extendJson.fileName.convert};
import ${extendJson.package.dto}.${extendJson.fileName.dto};
import ${extendJson.package.query}.${extendJson.fileName.query};
import ${extendJson.package.entity}.${extendJson.fileName.entity};
import ${extendJson.package.dao}.${extendJson.fileName.dao};
import ${extendJson.package.service}.${extendJson.fileName.service};

import java.util.List;
import java.util.stream.Collectors;

/**
 * @author : ${author}
 * @description：TODO
 * @date : ${.now?date}
 */
@Service
public class ${extendJson.fileName.serviceImpl} extends BaseServiceImpl<${extendJson.fileName.dao}, ${extendJson.fileName.entity}> implements ${extendJson.fileName.service} {

    @Autowired
    private ${extendJson.fileName.dao} ${extendJson.fileName.dao? uncap_first};

    /**
     * 通过ID查询单条数据 
     *
     * @param id 主键
     * @return 实例对象
     */
    @Override
    public ${extendJson.fileName.dto} getById(String id) {
        ${extendJson.fileName.entity} ${extendJson.fileName.entity? uncap_first} = this.lambdaGet(a -> a.eq(${extendJson.fileName.entity}::getId, id));

        ${extendJson.fileName.dto} ${extendJson.fileName.dto? uncap_first} = ${extendJson.fileName.convert}.INSTANCE.to${extendJson.fileName.dto}(${extendJson.fileName.entity? uncap_first});

        return ${extendJson.fileName.dto? uncap_first};
    }

    /**
     * 通过指定值查询多条数据
     * @param ${extendJson.fileName.query? uncap_first}
     * @return
     */
    @Override
    public List<${extendJson.fileName.dto}> queryBy(${extendJson.fileName.query} ${extendJson.fileName.query? uncap_first}) {
        List<${extendJson.fileName.entity}> ${extendJson.fileName.entity? uncap_first}s = this.lambdaList(a -> a.eq(${extendJson.fileName.entity}::getId, ${extendJson.fileName.query? uncap_first}.getId()));
        if (ObjectUtils.isNotNull(${extendJson.fileName.entity? uncap_first}s)) {
            return ${extendJson.fileName.entity? uncap_first}s.stream().map(item -> ${extendJson.fileName.convert}.INSTANCE.to${extendJson.fileName.dto}(item)).collect(Collectors.toList());
        }
        return null;
    }

    /**
     * 分页查询数据
     * @param ${extendJson.fileName.query? uncap_first}
     * @return
     */
    @Override
    public IPage<${extendJson.fileName.dto}> queryByPage(${extendJson.fileName.query} ${extendJson.fileName.query? uncap_first}) {
        IPage<${extendJson.fileName.entity}> ${extendJson.fileName.entity? uncap_first}IPage = this.lambdaPage(${extendJson.fileName.query? uncap_first}, a -> a.eq(${extendJson.fileName.entity}::getId, ${extendJson.fileName.query? uncap_first}.getId()));

        return new MyDbPage<>(${extendJson.fileName.entity? uncap_first}IPage, list ->
                list.stream().map(item -> ${extendJson.fileName.convert}.INSTANCE.to${extendJson.fileName.dto}(item)).collect(Collectors.toList()));

    }
    
    /** 
     * 新增数据
     *
     * @param ${extendJson.fileName.entity? uncap_first} 实例对象
     * @return 实例对象
     */
    public boolean add(${extendJson.fileName.entity} ${extendJson.fileName.entity? uncap_first}) {
        return super.add(${extendJson.fileName.entity? uncap_first});
    }
    
    /** 
     * 更新数据
     *
     * @param ${extendJson.fileName.dto? uncap_first} 实例对象
     * @return 实例对象
     */
    public boolean updateBy(${extendJson.fileName.dto} ${extendJson.fileName.dto? uncap_first}) {

        ${extendJson.fileName.entity} ${extendJson.fileName.entity? uncap_first} = ${extendJson.fileName.convert}.INSTANCE.toFile(${extendJson.fileName.dto? uncap_first});

        return lambdaUpdateBy(a -> a
                .eq(${extendJson.fileName.entity}::getId, ${extendJson.fileName.entity? uncap_first}.getId())
                .set(${extendJson.fileName.entity}::getName, ${extendJson.fileName.entity? uncap_first}.getName()), ${extendJson.fileName.entity? uncap_first});
    }
    
    /** 
     * 通过主键删除数据
     *
     * @param id 主键
     * @return 是否成功
     */
    public boolean deleteById(String id) {
        return deleteBy(a -> a.eq(${extendJson.fileName.entity}::getId, id));
    }

}
```

## controller:aria2File
``` java
package ${extendJson.package.controller};

import ${extendJson.package.convertQuery}.${extendJson.fileName.convertQuery};
import ${extendJson.package.entity}.${extendJson.fileName.entity};
import ${extendJson.package.dto}.${extendJson.fileName.dto};
import ${extendJson.package.query}.${extendJson.fileName.query};
import ${extendJson.package.service}.${extendJson.fileName.service};
import cn.shafish.http.RestResult;
import com.baomidou.mybatisplus.core.metadata.IPage;
import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

/**
 * ${extendJson.fileName.entity} 控制层
 * @author : ${author}
 * @date : ${.now?date}
 */
@Api(tags = "文件下载列表功能接口")
@RestController
@RequestMapping("/${extendJson.fileName.entity? uncap_first}")
public class ${extendJson.fileName.controller}{
    @Autowired
    private ${extendJson.fileName.service} ${extendJson.fileName.service? uncap_first};

    @PostMapping("/add")
    public RestResult<Object> add(@RequestBody ${extendJson.fileName.entity} ${extendJson.fileName.entity? uncap_first}) {
        boolean add = ${extendJson.fileName.service? uncap_first}.add(${extendJson.fileName.entity? uncap_first});
        return new RestResult(add, "");
    }

    @GetMapping("/getById")
    public RestResult<Object> getById(${extendJson.fileName.query} ${extendJson.fileName.query? uncap_first}) {
        ${extendJson.fileName.dto} byId = ${extendJson.fileName.service? uncap_first}.getById(${extendJson.fileName.query? uncap_first}.getId());
        return new RestResult(true, byId);
    }

    @GetMapping("/queryBy")
    public RestResult<Object> getBy(@RequestBody ${extendJson.fileName.query} ${extendJson.fileName.query? uncap_first}) {
        List<${extendJson.fileName.dto}> ${extendJson.fileName.dto? uncap_first}s = ${extendJson.fileName.service? uncap_first}.queryBy(${extendJson.fileName.query? uncap_first});
        return new RestResult(true, ${extendJson.fileName.dto? uncap_first}s);
    }

    @GetMapping("/queryByPage")
    public RestResult<Object> queryByPage(@RequestBody ${extendJson.fileName.query} ${extendJson.fileName.query? uncap_first}) {
        IPage<${extendJson.fileName.dto}> ${extendJson.fileName.dto? uncap_first}IPage = ${extendJson.fileName.service? uncap_first}.queryByPage(${extendJson.fileName.query? uncap_first});
        return new RestResult(true, ${extendJson.fileName.dto? uncap_first}IPage);
    }

    @PostMapping("/updateBy")
    public RestResult<Object> updateBy(@RequestBody ${extendJson.fileName.query} ${extendJson.fileName.query? uncap_first}) {
        ${extendJson.fileName.dto} ${extendJson.fileName.dto? uncap_first} = ${extendJson.fileName.convertQuery}.INSTANCE.to${extendJson.fileName.dto}(${extendJson.fileName.query? uncap_first});
        boolean flag = ${extendJson.fileName.service? uncap_first}.updateBy(${extendJson.fileName.dto? uncap_first});
        return new RestResult(flag, "");
    }

    @PostMapping("/deleteById")
    public RestResult<Object> deleteById(@RequestBody ${extendJson.fileName.query} ${extendJson.fileName.query? uncap_first}) {
        boolean flag = ${extendJson.fileName.service? uncap_first}.deleteById(${extendJson.fileName.query? uncap_first}.getId());
        return new RestResult(flag, "");
    }

}
```

``` json
{
    "info" : {
        "author" : "mcg-helper",
        "description" : {
            "entity" : "业务表基本信息",
            "dao" : "业务接口方法定义"
        }
    },
    "outputs" : {
        "entity" : "${path}/src/main/java/com/jeecg/${modelData.property.className?lower_case }/entity", 
        "dao" : "${path}/src/main/java/com/jeecg/${modelData.property.className?lower_case }/dao",
        "sql" : "${path}/src/main/java/com/jeecg/${modelData.property.className?lower_case }/sql",
        "service" : "${path}/src/main/java/com/jeecg/${modelData.property.className?lower_case }/service",
        "impl" : "${path}/src/main/java/com/jeecg/${modelData.property.className?lower_case }/service/impl",
        "controller" : "${path}/src/main/java/com/jeecg/${modelData.property.className?lower_case }/web",
        "page" : "${path}/src/main/resources/content/demo/${modelData.property.className?lower_case }"
    },
    "fileNames" : {
        "entity" : "${modelData.property.className }Entity.java", 
        "dao" : "${modelData.property.className }Dao.java",
        "service" : "${modelData.property.className }Service.java",
        "impl" : "${modelData.property.className }ServiceImpl.java",
        "controller" : "${modelData.property.className }Controller.java",
        "listPage" : "${modelData.property.className?lower_case }-list.vm",
        "addPage" : "${modelData.property.className?lower_case }-add.vm",
        "detailPage" : "${modelData.property.className?lower_case }-detail.vm",
        "editPage" : "${modelData.property.className?lower_case }-edit.vm",
		"conditionSql" : "${modelData.property.className }Dao_condition.sql",
		"getAllSql" : "${modelData.property.className }Dao_getAll.sql",
		"insertSql" : "${modelData.property.className }Dao_insert.sql",
		"updateSql" : "${modelData.property.className }Dao_update.sql"         
    },
    "classNames" :  {
        "entity" : "${modelData.property.className }Entity",
        "dao" : "${modelData.property.className }Dao",
        "service" : "${modelData.property.className }Service",
        "impl" : "${modelData.property.className }ServiceImpl",
        "controller" : "${modelData.property.className }Controller"
    },
    "packages" : {
        "entity" : "com.jeecg.${modelData.property.className?lower_case }.entity",
        "dao" : "com.jeecg.${modelData.property.className?lower_case }.dao",
        "service" : "com.jeecg.${modelData.property.className?lower_case }.service",
        "impl" : "com.jeecg.${modelData.property.className?lower_case }.service.impl",
        "controller" : "com.jeecg.${modelData.property.className?lower_case }.web"
    },
    "url" : {
        "controller" : "${modelData.property.className?uncap_first }Controller"
    },
    "page" : {
        "query":[                                       /*  列表页面作为查询条件的字段 */
            {"field":"userName", "type":"input"}
        ],
        "show":["userName", "userPwd", "age", "regTime", "updateTime"],   /* 列表页面表格显示的字段 */
        "addField" : ["userName", "userPwd", "age"],   /* 增加页面可以填写的字段 */
        "updateField" : ["age", "regTime"]  /* 修改页面可以填写的字段 */
    }
}
```

``` js
        "entity":"${aria2File.property.className}",
        "dto":"${aria2File.property.className}Dto",
        "query":"${aria2File.property.className}Query",
        "dao":"${aria2File.property.className}Mapper",
        "convert":"${aria2File.property.className}ToDto",
        "convertQuery":"${aria2File.property.className}QueryToDto",
        "service":"${aria2File.property.className}Service",
        "serviceImpl":"${aria2File.property.className}ServiceImpl",
        "controller":"${aria2File.property.className}Controller"
```
``` js
<#if loop??>
<#assign keys=allkey.tables?keys/>
<#assign records=allkey.tables[keys[loop.count-2]].record/>
<#assign property=allkey.tables[keys[loop.count-2]].property/>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="${extendJson.package.dao}.${currentfileName}Mapper">
    <select id="selectByPage" resultType="${extendJson.package.entity}.${currentfileName}">
        select *
        from user 
    </select>
</mapper>
</#if>
```
``` java
<#if loop??>
<#assign keys=allkey.tables?keys/>
<#assign records=allkey.tables[keys[loop.count-2]].record/>
<#assign property=allkey.tables[keys[loop.count-2]].property/>
package ${extendJson.package.convertQuery};

import ${extendJson.package.dto}.${currentfileName}Dto;
import ${extendJson.package.query}.${currentfileName}Query;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

/**
 * @author : ${author}
 * @description：${property.dataDesc}
 * @date : ${.now?date}
 */
@Mapper(componentModel = "spring")
public interface ${currentfileName}QueryToDto {
    ${currentfileName}QueryToDto INSTANCE = Mappers.getMapper(${currentfileName}QueryToDto.class);

    // @Mapping(source = "title", target = "name")
    ${currentfileName}Dto to${currentfileName}Dto(${currentfileName}Query ${currentfileName? uncap_first}Query);

}
</#if>
```