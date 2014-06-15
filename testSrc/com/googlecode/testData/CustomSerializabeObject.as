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
    import com.googlecode.flexxb.interfaces.ISerializable;

    public class CustomSerializabeObject implements ISerializable
    {
        public var test:String;

        public function CustomSerializabeObject()
        {
        }

        public function get id():String
        {
            return null;
        }

        public function serialize():XML
        {
            return <testObject>
                <testField>{test}</testField>
            </testObject>;
        }

        public function get thisType():Class
        {
            return CustomSerializabeObject;
        }

        public function deserialize(serializedData:XML):*
        {
            var xmlData:XML = serializedData as XML;
            test = xmlData.testField;
            return this;
        }

        public function getIdValue(serializedData:XML):String
        {
            return null;
        }
    }
}