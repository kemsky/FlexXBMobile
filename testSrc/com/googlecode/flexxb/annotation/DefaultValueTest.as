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
package com.googlecode.flexxb.annotation
{
    import com.googlecode.flexxb.core.FxBEngine;
    import com.googlecode.testData.DefaultValueTestObj;

    import org.flexunit.Assert;

    public class DefaultValueTest
    {
        [Test]
        public function testDefaultValue():void
        {
            var v:DefaultValueTestObj;
            var xml:XML =
                    <DefaultValueTestObj>
                        <min>3</min>
                    </DefaultValueTestObj>;
            v = FxBEngine.instance.getXmlSerializer().deserialize(xml, DefaultValueTestObj);
            Assert.assertEquals("String field wrong", "MyValue", v.string);
            Assert.assertEquals("min field wrong", 3, v.min);
            Assert.assertEquals("max field wrong", 5, v.max);
        }
    }
}