package com.googlecode.testData
{
    [XmlClass(alias="data")]
    public class RequiredMembersData
    {
        [XmlAttribute(required="true")]
        public var requiredAttr:String;

        [XmlAttribute(required="false")]
        public var optionalAttr:String;

        [XmlElement(required="true")]
        public var requiredElement:String;

        [XmlElement(required="false")]
        public var optionalElement:String;

        [XmlArray(required="true", memberName="item")]
        public var requiredArray:Array;

        [XmlArray(required="false", memberName="item")]
        public var optionalArray:Array;

        [XmlAttribute(alias="nested/requiredAttr", required="true")]
        public var requiredNestedAttr:String;

        [XmlAttribute(alias="nested/optionalAttr", required="false")]
        public var optionalNestedAttr:String;

        [XmlElement(alias="nested/requiredElement", required="true")]
        public var requiredNestedElement:String;

        [XmlElement(alias="nested/optionalElement", required="false")]
        public var optionalNestedElement:String;

        [XmlArray(alias="nested/requiredArray", required="true", memberName="item")]
        public var requiredNestedArray:Array;

        [XmlArray(alias="nested/optionalArray", required="false", memberName="item")]
        public var optionalNestedArray:Array;

        public function RequiredMembersData()
        {
        }
    }
}