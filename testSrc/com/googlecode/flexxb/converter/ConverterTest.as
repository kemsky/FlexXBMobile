package com.googlecode.flexxb.converter
{
    import com.googlecode.flexxb.core.FxBEngine;
    import com.googlecode.flexxb.core.IFlexXB;
    import com.googlecode.testData.ManyDates;

    import org.flexunit.assertThat;
    import org.hamcrest.object.equalTo;

    public class ConverterTest
    {
        public function ConverterTest()
        {
        }

        [Test]
        public function testArrayElementsConversion():void
        {
            var engine:IFlexXB = new FxBEngine().getXmlSerializer();
            engine.context.registerSimpleTypeConverter(new W3CDateConverter(), true);
            var data:ManyDates = new ManyDates();
            data.dates = [new Date(2000, 1, 1, 12, 12, 12, 12), new Date(2012, 12, 21, 21, 12, 21, 12)];
            var xml:XML = engine.serialize(data) as XML;
            assertThat(xml.dates.dateItem[0].text(), equalTo(new W3CDateConverter().toString(data.dates[0])));
            assertThat(xml.dates.dateItem[1].text(), equalTo(new W3CDateConverter().toString(data.dates[1])));
        }
    }
}