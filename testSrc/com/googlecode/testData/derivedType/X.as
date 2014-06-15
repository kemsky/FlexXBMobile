package com.googlecode.testData.derivedType
{
    [XmlClass]
    public class X
    {
        [XmlElement(alias="value/*", getRuntimeType="true")]
        public var a:A;
    }

}