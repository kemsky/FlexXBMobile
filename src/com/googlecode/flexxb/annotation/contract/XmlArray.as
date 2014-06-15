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
    import com.googlecode.flexxb.error.DescriptorParsingError;
    import avmplus.Types;
    import mx.utils.StringUtil;

    /**
     * <p>Usage: <code>[XmlArray(alias="element", memberName="NameOfArrayElement", getFromCache="true|false",
     * type="my.full.type" ignoreOn="serialize|deserialize", serializePartialElement="true|false",
     * order="order_index", namespace="Namespace_Prefix", idref="true|false",
     * setXsiType="true|false", version="versionName")]</code></p>
     * @author aCiobanu
     *
     */
    public final class XmlArray extends XmlElement
    {
        public static const ANNOTATION_NAME:String = "XmlArray";

        public var memberType:Class;

        public var memberName:QName;

        public var hasMemberNamespaceRef:Boolean;

        public var memberNamespaceRef:String;

        public var memberNamespace:Namespace;

        public function XmlArray(descriptor:MetaDescriptor = null)
        {
            super(descriptor);
            annotationName = ANNOTATION_NAME;
        }

        /**
         * Get the optional namespace for member
         * @return
         *
         */
        public function setMemberNamespace(value:Namespace):void
        {
            memberNamespace = value;
            if (memberName)
            {
                memberName = new QName(value, memberName.localName);
            }
        }


        protected override function parse(metadata:MetaDescriptor):void
        {
            super.parse(metadata);
            memberType = determineElementType(metadata);
            memberNamespaceRef = metadata.attributes[XmlConstants.MEMBER_NAMESPACE];
            hasMemberNamespaceRef = memberNamespaceRef && StringUtil.trim(memberNamespaceRef).length > 0;
            var arrayMemberName:String = metadata.attributes[XmlConstants.MEMBER_NAME];
            if (arrayMemberName)
            {
                var ns:Namespace = memberNamespace ? memberNamespace : nameSpace;
                memberName = new QName(ns, arrayMemberName);
            }
        }

        private function determineElementType(metadata:MetaDescriptor):Class
        {
            var type:Class;
            //handle the vector type. We need to check for it first as it will override settings in the member type
            var classType:String = Types.getQualifiedClassName(metadata.fieldType);
            if (classType.indexOf("__AS3__.vec::Vector") == 0)
            {
                if (classType.lastIndexOf("<") > -1)
                {
                    classType = classType.substring(classType.lastIndexOf("<") + 1, classType.length - 1);
                }
            }
            else
            {
                classType = metadata.attributes[XmlConstants.TYPE];
            }
            if (classType)
            {
                try
                {
                    type = Types.getDefinitionByName(classType) as Class;
                } catch (e:Error)
                {
                    throw new DescriptorParsingError(ownerClass.type, memberName.localName, "Member type <<" + classType + ">> can't be found as specified in the metadata. Make sure you spelled it correctly");
                }
            }
            return type;
        }
    }
}