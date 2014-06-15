package com.googlecode.testData
{
    public class AnotherVP
    {
        [XmlAttribute()]
        public var id:String = "4";

        [XmlElement(alias="tester")]
        public var path:XmlPathObject;

        public function AnotherVP()
        {
        }
    }
}