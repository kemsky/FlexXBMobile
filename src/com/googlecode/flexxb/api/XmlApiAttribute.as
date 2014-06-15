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
    import com.googlecode.flexxb.annotation.contract.AccessorType;

    [XmlClass(alias="XmlAttribute")]
    [ConstructorArg(reference="field")]
    [ConstructorArg(reference="alias")]
    public class XmlApiAttribute extends XmlApiMember
    {
        public static const INCOMING_XML_NAME:String = "XmlAttribute";

        /**
         *
         * @param name
         * @param type
         * @param accessType
         * @param alias
         * @return
         *
         */
        public static function create(name:String, type:Class, accessType:AccessorType = null, alias:String = null):XmlApiAttribute
        {
            var field:FxField = new FxField(name, type, accessType);
            var attribute:XmlApiAttribute = new XmlApiAttribute(field, alias);
            return attribute;
        }

        /**
         *
         * @param field
         * @param alias
         *
         */
        public function XmlApiAttribute(field:FxField = null, alias:String = null)
        {
            super(field, alias);
        }

        public override function getMetadataName():String
        {
            return "XmlAttribute";
        }

        /**
         * Get string representation of the current instance
         * @return string representing the current instance
         */
        public function toString():String
        {
            return "XmlAttribute[field: " + fieldName + ", type:" + fieldType + "]";
        }
    }
}