package com.googlecode.testData
{
    [XmlClass]
    public class VectoredElement
    {
        [XmlElement]
        public var id:String;

        [XmlArray]
        public var list:Vector.<String>;

        public function VectoredElement()
        {
        }
    }
}