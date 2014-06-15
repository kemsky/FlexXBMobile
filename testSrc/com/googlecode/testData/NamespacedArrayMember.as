package com.googlecode.testData
{
    [XmlClass(alias="data")]
    [Namespace(prefix="ns", uri="www.example.com/ns")]
    [Namespace(prefix="member", uri="www.example.com/member")]
    public class NamespacedArrayMember
    {
        [XmlArray(type="String", memberName="string", memberNamespace="member")]
        public var listA:Array = new Array();

        [XmlArray(type="int", memberName="int", namespace="ns", memberNamespace="member")]
        public var listB:Array = new Array();

        public function NamespacedArrayMember()
        {
        }
    }
}