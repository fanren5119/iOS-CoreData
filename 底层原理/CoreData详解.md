##1.CoreData四大模块
        ① Managed Object Model：
        是描述应用程序的数据模型，这个模型包含实体（Entity）、特性（Property）、读取请求
    （Fetch Request）等；
        ② Managed Object Context：
        参与对数据对象进行各种操作的全过程，并检测数据对象的变化，以提供undo/redo的支持以
    及更新绑定到数据的UI。
        ③Persistent Store Coordinator
        相当于数据文件管理器，处理底层的对数据文件的读取与写入。一般用不到它；
        ④ Managed Object
        数据对象，与Managed Object Context相关联；
##2.四大模块的运作
        ① 应用程序先创建或读取模型文件（后缀为xcdatamodeld）生成NSManagedObjectModel对象。
        ② 然后生成NSManagedObjectContext和NSPersistentStoreCoordinator对象，前者对用户透
    明地调用，后者对数据进行读写；
        ③ NSPersistentSoreCoordinator负责从数据文件（xml，squlite，二进制文件）中读取数据
    生成Managed Object，或保存Managed Object写入数据文件；
        ④ NSManagedObjectContext参与对数据进行各种操作的整个过程，它持有Managed Object，
    我们通过它来检测Managed Object，检测数据对象有两个作用：支持undo/redo以及数据绑定。
##3.Model Class
        ① NSManagedObjectModel：
        数据模型
        ② NSEntityDescription：
        相当于数据库中一个表，他描述一种抽象数据类型，其对应的类为NSManagedObject或其子类；
    常用的方法：
        A.insertNewObjectForEntityForName：根据指定的entity描述，生成对应的NSManagedObject
    对象，并插入Context中；
        B.managedObjectClassName：返回映射到Entity的NSManagedObject类名；
        C.attributesByName：以名字为key，返回Entity对应的Attributeds；
        D.relationoshipByName：以名字为key，返回Entity对应的Relationships；
        ③ NSPropertyDescription：
        Property为Entity的特性，他相当于数据库表中的一列，或者xml文件中的key-Value对中的key
    。他可以描述实体数据（Attribute）、Entity之间的关系（RelationShip），或者查询属性（Featc
    hed Property）。
        ④ NSAttributeDescription：
        Attribute存储基本数据，如NSString，NSNumber，NSDate等，他既可以有默认值，也可以使用
    正则表达式或其他条件对其进行限定
        ⑤ NSRelationshipDescription：
        RelationShip描述Entity、Property之间的关系，可以是一对一，也可以是一对多的关系
        ⑥ NSFetchedPropertyDescription
        Fetched Property根据查询谓词返回执行Entity的符合条件的数据对象。
        举例如下：
![举例](example.png)

        我们有一个.xcdatamodeld的模型文件，应用程序根据他生成一个NSManagedObjectModel对象，
    这个模型有两个Entity，每个Entity又可包含Attribute、Relationship、Fetched Property三种
    类型的Property。在本例中，StudentEntity包含三个Attribute：name、age、sex，它们对应的
    运行时类均为NSManagedObject，还包含一个Scores的Relationship；没有设置Fetched Property；
    可以使用KVC来访问Property
    NSManagedObject *stu = nil；
    stu = [NSEntityDescription insertNewObjectForEntityForName: @”Student”, 
                                        inManagedObjectContext: context];
    [stu setValue:@”xiaoming” forKey:@”name”];
##4.运行时类与对象
        ① NSManagedObject：
        Managed Object表示数据文件中的一条记录，每个Managed Object在内存中对应Entity的一个
    数据表示，Managed Object的成员被Entity的Property所描述；比如上述的例子中，stu这个
    NSManagedObject，对应名为Student的Entity。
        每一个Managed Object都有一个全局的ID（NSManagedObjectId）。ManagedObject会附加到一
    个NSManagedObjectContext，我们可以通过这个id在NSManagedObjectContext查询对应的
    ManagedObject；
        ② NSManagedObjectContext：
        ManagedObjectContext的作用相当重要，对数据进行的操作都与它有关，当创建一个数据对象
    并插入Content中，Context就开始跟踪这个数据对象的一切变动，并在适合的时候提供对undo/
    redo的支持，或调用Persistent Store Coordinator将变化保存到数据文件中；
        ③ NSPersitentStoreCoordinator：
        使用CoreData，通常会从磁盘上的数据文件中读取或存储数据，这底层的读写就由Persistent 
    Store Coordinator来处理，一般我们无需与它直接打交道，ManagedObjectContext在背后已经为
    我们调用Coordinator做了这份工作.
##5.Fetch Requests
        Fetch Requests相当于一个查询语句，你必须指定要查询的entity，我们通过Fecth Requests
    想ManagedObjectContext查询符合条件的数据对象，以NSArray形式返回查询结果，如果我们没有
    设置任何查询条件，则返回该Entity的所有数据，我们可以使用谓词来设置查询条件，通常将常
    用的Fetch Requests保存到dictionary以重复利用。



