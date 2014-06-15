package com.googlecode.testData
{
    import mx.collections.ArrayCollection;

    [Namespace(prefix="mgm", uri="http://www.mgm.com/app")]
    [XmlClass(alias="Response", prefix="mgm")]
    public class MGM
    {

        public function MGM()
        {
        }

        [XmlElement(alias="id", namespace="mgm")]
        public var id:String;

        [XmlArray(alias="fields", namespace="")]
        public var fields:ArrayCollection;
    }

}