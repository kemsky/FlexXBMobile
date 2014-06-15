package com.googlecode.testData
{
    [XmlClass(alias="theDates")]
    public class ManyDates
    {
        [XmlArray(memberName="dateItem", type="Date")]
        [ArrayElementType("Date")]
        public var dates:Array;

        public function ManyDates()
        {
        }
    }
}