package com.googlecode.testData
{
    public final class DepartmentEmployee
    {
        [XmlAttribute]
        public var name:String;

        [XmlElement]
        public var department:Department;

        public function DepartmentEmployee()
        {
        }
    }
}