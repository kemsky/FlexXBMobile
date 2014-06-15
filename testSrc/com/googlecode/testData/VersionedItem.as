package com.googlecode.testData
{
    [XmlClass(alias="item", uri="http://www.me.com/me/de")]
    [XmlClass(version="v2")]
    public class VersionedItem
    {
        [XmlAttribute()]
        [XmlElement(version="v2")]
        public var id:String;

        [XmlAttribute(alias="pName")]
        [XmlAttribute(alias="itemName", version="v2")]
        public var name:String;

        [XmlElement(alias="mock", version="v2")]
        public var value:Mock;

        [XmlElement(alias="test", serializePartialElement="true")]
        public var mock2:Mock2;

        public function VersionedItem()
        {
        }
    }
}