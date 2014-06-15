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
     * This is the base class for a field xml annotation.
     * <p> It obtains basic informations about the field:
     * <ul><li>Field name</li>
     *     <li>Field type</li>
     *     <li>Alias (the name under which the field will be used in the xml reprezentation)</li>
     * </ul>
     * </p>
     * @author aCiobanu
     *
     */
    public class Annotation extends BaseAnnotation
    {
        public var name:QName;
        public var type:Class;

        public var alias:String = "";
        public var useOwnerAlias:Boolean;
        public var isPath:Boolean;
        public var hasNamespaceDeclaration:Boolean;

        public var xmlName:QName;

        public var nameSpace:Namespace;

        public var namespaceRef:String;

        [ArrayElementType("QName")]
        public var qualifiedPathElements:Array;

        /**
         * Constructor
         * @param descriptor
         *
         */
        public function Annotation(descriptor:MetaDescriptor = null)
        {
            super(descriptor);
        }

        /**
         * Set the annotation namepsace
         *
         */
        public function setNameSpace(value:Namespace):void
        {
            nameSpace = value;
            if (isPath)
            {
                var path:QName;
                for (var i:int = 0; i < qualifiedPathElements.length; i++)
                {
                    path = qualifiedPathElements[i] as QName;
                    qualifiedPathElements[i] = new QName(value, path.localName);
                }
            }
            isPath =  qualifiedPathElements && qualifiedPathElements.length > 0;

            hasNamespaceDeclaration = nameSpace && nameSpace.uri && nameSpace.uri.length > 0;

            if (namespaceRef == "")
            {
                nameSpace = null;
            }

            xmlName = new QName(nameSpace, alias == "" ? name : alias);
        }

        /**
         * @private
         * @param value name to be set
         *
         */
        protected function setAlias(value:String):void
        {
            if (value && value.indexOf(XmlConstants.ALIAS_PATH_SEPARATOR) > 0)
            {
                var elems:Array = value.split(XmlConstants.ALIAS_PATH_SEPARATOR);
                qualifiedPathElements = [];
                var localName:String;
                for (var i:int = 0; i < elems.length; i++)
                {
                    localName = elems[i] as String;
                    if (localName && localName.length > 0)
                    {
                        if (i == elems.length - 1)
                        {
                            internalSetAlias(localName);
                            break;
                        }
                        qualifiedPathElements.push(new QName(nameSpace, localName));
                    }
                }
            }
            else
            {
                internalSetAlias(value);
            }

            isPath =  qualifiedPathElements && qualifiedPathElements.length > 0;

            xmlName = new QName(nameSpace, alias == "" ? name : alias);
        }

        private function internalSetAlias(value:String):void
        {
            alias = value;
            if (!alias || alias.length == 0)
            {
                alias = name.localName;
            }
            useOwnerAlias = alias == XmlConstants.ALIAS_ANY;
        }

        protected override function parse(descriptor:MetaDescriptor):void
        {
            super.parse(descriptor);
            name = descriptor.fieldName;
            type = descriptor.fieldType;
            setAlias(descriptor.attributes[XmlConstants.ALIAS]);

            namespaceRef = descriptor.attributes[XmlConstants.NAMESPACE];
            if (namespaceRef == "")
            {
                nameSpace = null;
            }

            hasNamespaceDeclaration = nameSpace && nameSpace.uri && nameSpace.uri.length > 0;

            xmlName = new QName(nameSpace, alias == "" ? name : alias);
        }
    }
}