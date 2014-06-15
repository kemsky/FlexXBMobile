package com.googlecode.testData.arrayIssue
{
    import mx.collections.ArrayCollection;

    [XmlClass(alias="data", prefix="xs")]
    [Namespace(prefix="xs", uri="http://www.example.com")]
    public class IData
    {

        [ArrayElementType("com.googlecode.testData.arrayIssue.Item")]
        [XmlArray(alias="*", type="com.googlecode.testData.arrayIssue.Item", namespace="xs")]
        public var localItems:ArrayCollection = new ArrayCollection();

        [ArrayElementType("com.googlecode.testData.arrayIssue.Item")]
        [XmlArray(alias="nested", type="com.googlecode.testData.arrayIssue.Item", namespace="xs")]
        public var nestedItems:ArrayCollection = new ArrayCollection();

        public function IData()
        {
        }
    }
}