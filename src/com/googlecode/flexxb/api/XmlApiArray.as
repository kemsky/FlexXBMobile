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
    import com.googlecode.flexxb.annotation.contract.XmlArray;
    import com.googlecode.flexxb.annotation.contract.XmlConstants;
    import com.googlecode.flexxb.annotation.contract.AccessorType;
    import avmplus.Types;

    import flash.utils.Dictionary;

    [XmlClass(alias="XmlArray")]
    [ConstructorArg(reference="field")]
    [ConstructorArg(reference="alias")]
    public class XmlApiArray extends XmlApiElement
    {
        public static const INCOMING_XML_NAME:String = "XmlArray";

        public static function create(name:String, type:Class, accessType:AccessorType = null, alias:String = null):XmlApiArray
        {
            var field:FxField = new FxField(name, type, accessType);
            var array:XmlApiArray = new XmlApiArray(field, alias);
            return array;
        }

        [XmlAttribute]
        public var memberName:String;

        [XmlAttribute]
        public var memberType:Class;

        protected var _memberNameSpace:XmlApiNamespace;

        public function XmlApiArray(field:FxField = null, alias:String = null)
        {
            super(field, alias);
        }

        [XmlElement]
        public final function get memberNameSpace():XmlApiNamespace
        {
            return _memberNameSpace;
        }

        public final function set memberNameSpace(value:XmlApiNamespace):void
        {
            _memberNameSpace = value;
            if (getOwner())
            {
                if (value)
                {
                    _memberNameSpace = XmlApiClass(getOwner()).addNamespace(value);
                }
                else
                {
                    XmlApiClass(getOwner()).removeNamespace(value);
                }
            }
        }

        public function setMemberNamespace(ns:Namespace):void
        {
            memberNameSpace = XmlApiNamespace.create(ns);
        }

        public override function getMetadataName():String
        {
            return XmlArray.ANNOTATION_NAME;
        }

        public override function getMappingValues():Dictionary
        {
            var values:Dictionary = super.getMappingValues();
            if (memberName)
            {
                values[XmlConstants.MEMBER_NAME] = memberName;
            }
            if (memberType is Class)
            {
                values[XmlConstants.TYPE] = Types.getQualifiedClassName(memberType);
            }
            return values;
        }

        /**
         * Get string representation of the current instance
         * @return string representing the current instance
         */
        public override function toString():String
        {
            return "Array[field: " + fieldName + ", type:" + fieldType + "]";
        }
    }
}