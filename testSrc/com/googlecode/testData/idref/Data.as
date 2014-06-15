package com.googlecode.testData.idref
{
    import mx.collections.ArrayCollection;

    [XmlClass(alias="data")]
    public class Data
    {
        [XmlElement]
        public var node:Node;


        [XmlAttribute(alias="referenceAtt/id", getFromCache="true", idref="true", serializePartialElement="true")]
        public var referenceAtt:Node;


        [XmlElement(alias="referenceElement", getFromCache="true", idref="true", serializePartialElement="true")]
        public var referenceElement:Node;

        [XmlArray(alias="referenceArray", memberName="node", type="com.googlecode.testData.idref.Node", getFromCache="true", idref="true", serializePartialElement="true")]
        public var referenceArray:ArrayCollection;


        public function Data()
        {
        }
    }
}