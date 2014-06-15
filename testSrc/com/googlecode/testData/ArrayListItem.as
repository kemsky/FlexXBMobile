package com.googlecode.testData
{
    import mx.collections.ArrayList;

    [XmlClass]
    public class ArrayListItem
    {
        [XmlAttribute()]
        public var id:String;

        [XmlArray(alias="arrayList", memberName="item", type="String")]
        public var list:ArrayList;

        public function ArrayListItem()
        {
        }
    }
}