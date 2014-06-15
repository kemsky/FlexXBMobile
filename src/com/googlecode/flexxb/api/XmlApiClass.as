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
    import com.googlecode.flexxb.annotation.contract.XmlClass;
    import com.googlecode.flexxb.annotation.contract.XmlConstants;
    import com.googlecode.flexxb.annotation.contract.AccessorType;
    import com.googlecode.flexxb.annotation.contract.Constants;

    import flash.utils.Dictionary;

    use namespace flexxb_api_internal;

    [XmlClass(alias="XmlClass")]
    [ConstructorArg(reference="type")]
    [ConstructorArg(reference="alias")]
    /**
     * API wrapper for a class type. Allows programatically defining all the
     * elements that would normally be specified via annotations.
     * @author Alexutz
     *
     */
    public class XmlApiClass extends FxClass
    {
        /**
         *
         */
        [XmlAttribute]
        /**
         * Class alias
         * @default
         */
        public var alias:String;
        /**
         *
         */
        [XmlAttribute]
        /**
         * Namespace prefix
         * @default
         */
        public var prefix:String;
        /**
         *
         */
        [XmlAttribute]
        /**
         * Namespace uri
         * @default
         */
        public var uri:String;
        /**
         *
         */
        [XmlAttribute]
        /**
         * Flag signaling whether the class members are ordered or not in the xml processing stages
         * @default
         */
        public var ordered:Boolean;
        /**
         *
         */
        [XmlAttribute]
        /**
         *
         * @default
         */
        public var useNamespaceFrom:String;
        /**
         *
         */
        [XmlAttribute]
        /**
         * Name of the field which will be considered as an identifier for the class instance
         * @default
         */
        public var idField:String;
        /**
         *
         */
        [XmlAttribute]
        /**
         * Name of the field which is considered to be the default value
         * @default
         */
        public var defaultValueField:String;
        /**
         * Class namespace list
         */
        flexxb_api_internal var namespaces:Dictionary;

        /**
         * Constructor
         * @param    type class type
         * @param    alias class alias
         */
        public function XmlApiClass(type:Class = null, alias:String = null)
        {
            super(type);
            this.alias = alias;
        }

        /**
         * Set the default namespace for this class
         * @param value
         *
         */
        public function set defaultNamespace(value:Namespace):void
        {
            if (value)
            {
                uri = value.uri;
                prefix = value.prefix;
            }
        }

        /**
         * Add a namespace to the class namespace list
         * @param ns target namespace
         * @return reference to the target namespace
         * @throws error if the namespace is already registered in the class' namespace list
         * @see FxNamesapce
         */
        internal function addNamespace(ns:XmlApiNamespace):XmlApiNamespace
        {
            if (ns)
            {
                if (namespaces)
                {
                    var existing:XmlApiNamespace = namespaces[ns.prefix];
                    if (existing)
                    {
                        if (existing.uri != ns.uri)
                        {
                            throw new Error("A namespace already exists with the same prefix but a different uri!\n Existing namespace: " + existing + "\nNamespace to add: " + ns);
                        }
                        return existing;
                    }
                }
                else
                {
                    namespaces = new Dictionary();
                }
                namespaces[ns.prefix] = ns;
            }
            return ns;
        }

        /**
         * Remove a namespace from the class namespace list
         * @param ns target namespace
         *
         */
        internal function removeNamespace(ns:XmlApiNamespace):void
        {
            if (ns && namespaces)
            {
                for each(var member:XmlApiMember in members)
                {
                    if (member.nameSpace && member.nameSpace.prefix == ns.prefix)
                    {
                        return;
                    }
                }
                delete namespaces[ns.prefix];
            }
        }

        /**
         * Add a field mapped to an xml attribute
         * @param fieldName name of the target field
         * @param fieldType type of the target field
         * @param access field access type
         * @param alias field alias in the xml mapping
         * @return FxAttribute instance
         * @see FxAttribute
         * @see AccessorType
         *
         */
        public function addAttribute(fieldName:String, fieldType:Class, access:AccessorType = null, alias:String = null):XmlApiAttribute
        {
            var attribute:XmlApiAttribute = XmlApiAttribute.create(fieldName, fieldType, access, alias);
            addMember(attribute);
            return attribute;
        }

        /**
         * Add a field mapped to an xml element
         * @param fieldName name of the target field
         * @param fieldType type of the target field
         * @param access field access type
         * @param alias field alias in the xml mapping
         * @return FxElement instance
         * @see FxElement
         * @see AccessorType
         *
         */
        public function addElement(fieldName:String, fieldType:Class, access:AccessorType = null, alias:String = null):XmlApiElement
        {
            var element:XmlApiElement = XmlApiElement.create(fieldName, fieldType, access, alias);
            addMember(element);
            return element;
        }

        /**
         * Add an array field mapped to an xml element
         * @param fieldName name of the target field
         * @param fieldType type of the target field (Array, ArrayCollection, ListCollectionView etc.)
         * @param access field access type
         * @param alias field alias in the xml mapping
         * @return FxArray instance
         * @see FxArray
         * @see AccessorType
         *
         */
        public function addArray(fieldName:String, fieldType:Class, access:AccessorType = null, alias:String = null):XmlApiArray
        {
            var array:XmlApiArray = XmlApiArray.create(fieldName, fieldType, access, alias);
            addMember(array);
            return array;
        }

        public override function getGlobalAnnotations():Array
        {
            var nsList:Array = [];
            for (var nsKey:* in namespaces)
            {
                nsList.push(namespaces[nsKey]);
            }
            return nsList;
        }

        protected override function onMemberAdded(member:FxMember):void
        {
            addNamespace(XmlApiMember(member).nameSpace);
        }

        public override function getMetadataName():String
        {
            return XmlClass.ANNOTATION_NAME;
        }

        public override function getMappingValues():Dictionary
        {
            var values:Dictionary = super.getMappingValues();
            values[XmlConstants.ALIAS] = alias;
            values[XmlConstants.NAMESPACE_PREFIX] = prefix;
            values[XmlConstants.NAMESPACE_URI] = uri;
            values[Constants.ORDERED] = ordered;
            values[XmlConstants.USE_CHILD_NAMESPACE] = useNamespaceFrom;
            values[Constants.ID] = idField;
            values[XmlConstants.VALUE] = defaultValueField;
            return values;
        }

        public override function toString():String
        {
            return "XmlClass[type: " + type + ", alias:" + alias + "]";
        }
    }
}