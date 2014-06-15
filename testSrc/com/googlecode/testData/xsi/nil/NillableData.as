package com.googlecode.testData.xsi.nil
{
    [XmlClass(alias="data")]
    public class NillableData
    {
        [XmlElement(nillable="true")]
        public var elementNillable:String;

        [XmlElement]
        public var elementNormal:String;

        [XmlElement(required="true")]
        public var elementRequired:String;

        [XmlElement(required="true", nillable="true")]
        public var elementNillableRequired:String;

        [XmlElement(alias="nested/elementNillable", nillable="true")]
        public var nestedElementNillbable:String;

        [XmlElement(alias="nested/elementNormal")]
        public var nestedElementNormal:String;

        [XmlElement(alias="nested/elementRequired", required="true")]
        public var nestedElementRequired:String;

        [XmlElement(alias="nested/elementNillableRequired", nillable="true")]
        public var nestedElementNillableRequired:String;

        public function NillableData()
        {
        }
    }
}