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

    [XmlClass(alias="MOck2Replacement", idField="id")]
    public class Mock3 extends Mock2
    {
        [XmlAttribute]
        public var attribute:Boolean;
        [XmlElement(alias="objectVersion")]
        public var version:Number;
        [XmlArray]
        public var list:Array = [1, 2, 3];

        public function Mock3()
        {
            super();
        }
    }
}