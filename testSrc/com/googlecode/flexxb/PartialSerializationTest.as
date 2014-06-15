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
    import com.googlecode.testData.Mock;
    import com.googlecode.testData.Mock3;

    import org.flexunit.Assert;

    /**
     *
     * @author aCiobanu
     *
     */
    public class PartialSerializationTest
    {

        [Test]
        public function testPartialSerialization():void
        {
            var target:Mock = new Mock();
            target.aField = "test";
            target.link = new Mock3();
            target.link.id = 325;
            target.link.version = 2;
            var xml:XML = FxBEngine.instance.getXmlSerializer().serialize(target) as XML;
            var mk3:XML = xml.child(new QName(new Namespace("http://www.test.com/xmlns/pp/v1"), "mock3"))[0];
            Assert.assertTrue(mk3.length() > 0);
            Assert.assertEquals("Link id is wrong", "325", mk3.@id);
            Assert.assertEquals("Link attribute is wrong", "", mk3.@attribute.toString());
            Assert.assertEquals("Link version is wrong", "", mk3.objectVersion.toString());
        }
    }
}