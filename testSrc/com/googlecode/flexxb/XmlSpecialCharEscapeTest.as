/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2012 Alex Ciobanu
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */
package com.googlecode.flexxb
{
    import com.googlecode.flexxb.core.FxBEngine;
    import com.googlecode.testData.NameOrdered;

    import org.flexunit.Assert;

    /**
     *
     * @author Alexutz
     *
     */
    public class XmlSpecialCharEscapeTest
    {

        [Test]
        public function testEscapeCharsOnElements():void
        {
            var target:NameOrdered = new NameOrdered();
            target.test2 = "EscapeChar <b>OK</b>";
            target.test3 = "EscapeChar2 <b>OK</b>";
            target.reference = "<test </meeee>";
            target.list = ["Alt escape test <juice />", "nik", "test4<", "<test5>"];
            var xml:XML = FxBEngine.instance.getXmlSerializer().serialize(target) as XML;
            Assert.assertEquals("Escape Char element is wrong", "EscapeChar <b>OK</b>", (xml.test2[0] as XML).children()[0]);
            Assert.assertEquals("Escape Char 2 element is wrong", "EscapeChar2 <b>OK</b>", xml.@test3);
            Assert.assertEquals("Reference has wrong escape chars", "<test </meeee>", (xml.reference[0] as XML).children()[0]);
            Assert.assertEquals("Array member has wrong escape chars", "Alt escape test <juice />", xml.list[0].testerElem[0].children()[0]);
            Assert.assertEquals("Array member has wrong escape chars", "nik", xml.list[0].testerElem[1].children()[0]);
            Assert.assertEquals("Array member has wrong escape chars", "test4<", xml.list[0].testerElem[2].children()[0]);
            Assert.assertEquals("Array member has wrong escape chars", "<test5>", xml.list[0].testerElem[3].children()[0]);
        }
    }
}