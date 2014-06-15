package com.googlecode.testData.idref
{
    [XmlClass(alias="node", idField="id")]
    public class Node
    {
        [XmlAttribute]
        public var id:String;

        [XmlAttribute]
        public var name:String;

        public function Node()
        {
        }
    }
}