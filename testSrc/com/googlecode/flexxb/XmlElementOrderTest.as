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
    public class XmlElementOrderTest
    {
        [Test]
        public function testNameOrder():void
        {
            var test:NameOrdered = new NameOrdered();
            test.test1 = 3;
            test.test2 = "valoare";
            test.reference = "ref";
            var xml:XML = FxBEngine.instance.getXmlSerializer().serialize(test) as XML;
            Assert.assertEquals("ChildOrder not ok for first child", "reference", (xml.children()[0] as XML).name().toString());
            Assert.assertEquals("ChildOrder not ok for second child", "test2", (xml.children()[1] as XML).name().toString());
            Assert.assertEquals("ChildOrder not ok for third child", "TestOk", (xml.children()[2] as XML).name().toString());
            Assert.assertEquals("ChildOrder not ok for third child", "variable", (xml.children()[3] as XML).name().toString());
        }
    }
}