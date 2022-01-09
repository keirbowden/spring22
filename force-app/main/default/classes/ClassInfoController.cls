public with sharing class ClassInfoController implements ClassInfoIF
{
    public String getDescription()
    {
        return 'Controller class for the ClassInfo lightning web ' +       
               'components collection - retrieves information about Apex ' + 
               'Classes that implement the ClassInfoIF interface';
    }

    public String getAuthor() 
    {
        return 'Bob Buzzard';
    }

    @AuraEnabled(cacheable=true)
    public static List<ClassDetail> GetClassDetails()
    {
        List<ClassDetail> classDetails=new List<ClassDetail>();
        List<ApexTypeImplementor> classInfoTypes = 
                [SELECT ApexClassId, ClassName, ClassNamespacePrefix
                FROM ApexTypeImplementor
                WHERE InterfaceName = 'ClassInfoIF' and IsConcrete=true];

        for (ApexTypeImplementor classInfoType : classInfoTypes)
        {
            ClassDetail classDetail=new ClassDetail();
            classDetail.classId=classInfoType.ApexClassId;
            classDetail.fullName='';
            if (null!=classInfoType.ClassNamespacePrefix)
            {
                classDetail.fullName=classInfoType.ClassNamespacePrefix + '.';
            }

            classDetail.fullName+=classInfoType.ClassName;
            ClassInfoIF classInfo = 
                        (ClassInfoIF) Type.forName(classInfoType.ClassNamespacePrefix,
                                                classInfoType.ClassName).newInstance();

            classDetail.description=classInfo.getDescription();
            classDetail.author=classInfo.getAuthor();
            classDetails.add(classDetail);
        }

        return classDetails;
    }

    public class ClassDetail
    {
        @AuraEnabled
        public Id classId {get; set;}
        
        @AuraEnabled
        public String fullName {get; set;}

        @AuraEnabled
        public String description {get; set;}

        @AuraEnabled
        public String author {get; set;}
    }
}
