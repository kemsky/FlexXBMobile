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
package com.googlecode.testData
{

    [Bindable]
    [XmlClass(alias="MyClass", prefix="test", uri="http://www.test.com/xmlns/pp/v1")]
    [XmlClass(alias="V2", version="v2", prefix="ulala", uri="www.me.com")]
    [Namespace(prefix="me", uri="www.me.com")]
    public class Mock
    {
        [XmlAttribute(alias="stuff")]
        public var aField:String = "a";
        [XmlAttribute(ignoreOn="serialize")]
        public var date:Date;
        [XmlAttribute(version="v2")]
        [XmlElement(alias="objVersion", namespace="me")]
        public var version:int = 4;
        [XmlElement(version="v2", alias="v2Tested")]
        [XmlElement(alias="mock3", serializePartialElement="true")]
        public var link:Mock3;
        [XmlElement(serializePartialElement="true")]
        public var reference:Object;
        [XmlElement()]
        public var classType:Class;
        [XmlArray(alias="data", type="com.googlecode.testData.Mock")]
        public var result:Array;

        internal var internalTest:String;

        [XmlElement]
        public function get readOnly():String
        {
            return "YES";
        }

        [XmlElement()]
        public function set writeOnly(value:String):void
        {
            trace("Mock - writeOnly");
        }

        public var someExcludedField:Boolean;

        [Argument(ref="version", optional="false")]
        public function Mock()
        {
        }
    }
}