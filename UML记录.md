## 类图
[](./imgs/uml/class.png)

- 第一层：填写类名;如果是抽象类，则使用斜体表示
- 第二层：填写属性，格式：`作用范围符号 属性名称:类型=默认值`。属性的作用范围或者叫可见性：+表示public，-表示private，#表示protected
- 第三层：类的方法，格式：`作用范围符号 方法名(参数类型) : 返回类型`。

## 接口图
[](./imgs/uml/interface.png)

- 第一层：接口名（有interface标识）
- 第二层：同上
- 第三层：同上

## 连接关系

### 继承
也叫泛化，描述父子类间关系，父类称为基类或者超类，子类为派生类或者实现类。使用空心三角形实线表示`is-a`的关系。

[](./imgs/uml/extends.png)

### 实现
使用空心三角虚线表示。
[](./imgs/uml/implements.png)

### 依赖
使用`虚线箭头`表示。描述了`use a`关系。
类A中有方法以类B作为入参。

[](./imgs/uml/use.png)

### 关联
使用实线箭头表示。
类A中有属性为类B。

[](./imgs/uml/name.png)

### 聚合
空心菱形 + 实线箭头，描述了`has a`的关系，是一种较强的关联关系，强调整体与部分的关系（可分开）。

[](./imgs/uml/aggregation.png)

### 组合
实心菱形 + 实线箭头，描述了`contains a`的关系，是一种更强的关联关系（不可分开）。

[](./imgs/uml/composition.png)


ref:
- [设计模式 - UML 类图与接口图的表示](https://juejin.cn/post/6844903998080679943#heading-14)