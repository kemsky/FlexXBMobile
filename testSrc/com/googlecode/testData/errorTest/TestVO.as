package com.googlecode.testData.errorTest
{
    [XmlClass(alias="TestVO")]
    public class TestVO
    {
        [XmlElement(alias="intTest/*", getRuntimeType="true")]
        public var intTest:ITest;


        [XmlElement(alias="intTest1/*", getRuntimeType="true")]
        public var intTest1:ITest;


        public function TestVO()
        {


        }
    }
}