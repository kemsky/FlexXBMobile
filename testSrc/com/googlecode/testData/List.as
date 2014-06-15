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

    public class List
    {
        [XmlArray(alias="nums", type="int", memberName="n")]
        public var nums:Array = new Array();

        [XmlArray(alias="items", type="String")]
        public var items:Array = new Array();

        [XmlArray(alias="nbrs", type="int")]
        public var numbers:Array = new Array();

        public function List()
        {
        }
    }
}