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
package com.googlecode.flexxb.annotation.contract
{
    import com.googlecode.flexxb.annotation.parser.MetaDescriptor;

    /**
     * Usage: <code>[XmlElement(alias="element", getFromCache="true|false",
     * ignoreOn="serialize|deserialize", serializePartialElement="true|false",
     * order="order_index", getRuntimeType="true|false", namespace="Namespace_Prefix",
     * default="DEFAULT_VALUE", idref="true|false", setXsiType="true|false",
     * version="versionName")]</code>
     * @author aCiobanu
     *
     */
    public class XmlElement extends XmlMember
    {
        public static const ANNOTATION_NAME:String = "XmlElement";

        public var serializePartialElement:Boolean;

        public var getFromCache:Boolean;

        public var getRuntimeType:Boolean;

        public var setXsiType:Boolean;

        public var nillable:Boolean;

        public var wrapCDATA:Boolean;

        /**
         * Constructor
         * @param descriptor
         * @param xmlClass
         *
         */
        public function XmlElement(descriptor:MetaDescriptor = null)
        {
            super(descriptor);
            annotationName = ANNOTATION_NAME;
        }

        protected override function parse(metadata:MetaDescriptor):void
        {
            super.parse(metadata);
            serializePartialElement = metadata.getBoolean(XmlConstants.SERIALIZE_PARTIAL_ELEMENT);
            getFromCache = metadata.getBoolean(XmlConstants.GET_FROM_CACHE);
            getRuntimeType = metadata.getBoolean(XmlConstants.GET_RUNTIME_TYPE);
            setXsiType = metadata.getBoolean(XmlConstants.SET_XSI_TYPE);
            nillable = metadata.getBoolean(XmlConstants.NILLABLE);
            wrapCDATA = metadata.getBoolean(XmlConstants.WRAP_CDATA);
            isRequired = isRequired || nillable;
        }
    }
}