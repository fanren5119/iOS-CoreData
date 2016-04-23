# iOS-CoreData
    CoreData是Cocoa中处理数据，绑定数据的关键特性，其重要性不言而喻，但比较
复杂。
##一、框架
###1.CoreData的五个相关模块
        ① Managed Object Model：描述应用程序的数据模型，这个模型包含实体(Entity)、
    特性(Property)、读取请求(Fetch Request)等；
        ② Managed Object Context：参与对数据对象进行各种操作的全过程，并检测数据
    对象的变化，已提供对undo/redo的支持以及更新绑定到数据的UI。
        ③ Persistent Store Coordinator：相当于数据文件管理器，处理底层的对数据文
    件的读取与写入，一般我们无需使用；
        ④ Managed Object：数据对象，与Managed Object Context相关联；
        ⑤ Controller：Array Controller，Object Controller，Tree Controller这些控
    制器，一般都是通过control + drag将Managed Object Context绑定到它们，这样我们
    就可以在nib中可视化操作数据。
