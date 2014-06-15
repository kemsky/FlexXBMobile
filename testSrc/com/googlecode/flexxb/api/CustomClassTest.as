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
package com.googlecode.flexxb.api
{
    import com.googlecode.flexxb.core.FxBEngine;

    public class CustomClassTest
    {

        [Test]
        public function testPanelSerialization():void
        {
            var xml:XML =
                    <FlexXBAPI>
                        <Descriptors>
                            <XmlClass type="com.googlecode.flexxb.api.FetchPanel">
                                <Members>
                                    <XmlAttribute>
                                        <Field name="x" type="int"/>
                                        <!-- To serialize their positions. -->
                                    </XmlAttribute>
                                    <XmlAttribute>
                                        <Field name="y" type="int"/>
                                    </XmlAttribute>
                                </Members>
                            </XmlClass>
                        </Descriptors>
                    </FlexXBAPI>;
            var engine:FxBEngine = new FxBEngine();
            engine.api.processDescriptorsFromXml(xml);
            var pipe:PipeLine = new PipeLine();
            pipe.name = "test";
            pipe.panels = [];
            var panel:FetchPanel = new FetchPanel();
            panel.x = 2;
            panel.y = 2;
            pipe.panels.push(panel);
            panel = new FetchPanel();
            panel.x = 2;
            panel.y = 2;
            pipe.panels.push(panel);
            xml = engine.getXmlSerializer().serialize(pipe) as XML;
        }
    }
}