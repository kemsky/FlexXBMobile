package com.googlecode.testData.arrayIssue
{

    [XmlClass(alias="item", prefix="xs")]
    [Namespace(prefix="xs", uri="http://www.example.com")]
    public class Item
    {

        [XmlAttribute]
        public var value:String;

        public function Item()
        {
        }
    }
}