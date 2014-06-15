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
    import com.googlecode.flexxb.annotation.parser.ClassMetaDescriptor;
    import com.googlecode.flexxb.annotation.parser.MetaDescriptor;
    import com.googlecode.flexxb.error.DescriptorParsingError;
    import flash.utils.Dictionary;
    import mx.collections.ISort;
    import mx.collections.SortField;
    import mx.logging.ILogger;
    import mx.logging.Log;

    /**
     *
     * <p>Usage: <code>[XmlClass(alias="MyClass", useNamespaceFrom="elementFieldName",
     * idField="idFieldName", prefix="my", uri="http://www.your.site.com/schema/",
     * defaultValueField="fieldName", ordered="true|false", version="versionName")]</code></p>
     * @author aCiobanu
     *
     */
    public final class XmlClass extends Annotation implements IClassAnnotation
    {
        private static const LOG:ILogger = Log.getLogger("com.googlecode.flexxb.annotation.contract.XmlClass");

        public static const ANNOTATION_NAME:String = "XmlClass";

        public static const SORT:Array = [new SortField("alias", true, false, false)];

        [ArrayElementType("com.googlecode.flexxb.annotation.contract.XmlMember")]
        public var members:Array = [];

        private var _sort:ISort;

        private var id:String;

        public var idField:XmlMember;

        private var defaultValue:String;

        public var valueField:Annotation;

        public var childNameSpaceFieldName:String;

        public var ordered:Boolean;

        public var useOwnNamespace:Boolean;

        public var constructor:Constructor;

        private var namespaces:Dictionary = new Dictionary();

        private var membersMap:Dictionary = new Dictionary();

        public function XmlClass(descriptor:ClassMetaDescriptor = null)
        {
            constructor = new Constructor(this);
            if(descriptor != null)
            {
                descriptor.owner = this;
            }

            super(descriptor);
            annotationName = ANNOTATION_NAME;
        }

        public function getMember(memberFieldName:String):XmlMember
        {
            return membersMap[memberFieldName];
        }

        public function getAdditionalSortFields():Array
        {
            return SORT.concat();
        }

        protected override function parse(descriptor:MetaDescriptor):void
        {
            super.parse(descriptor);

            var desc:ClassMetaDescriptor = descriptor as ClassMetaDescriptor;
            id = desc.attributes[Constants.ID];
            childNameSpaceFieldName = desc.attributes[XmlConstants.USE_CHILD_NAMESPACE];
            useOwnNamespace = childNameSpaceFieldName == null || childNameSpaceFieldName.length == 0;
            ordered = desc.getBoolean(Constants.ORDERED);
            defaultValue = desc.attributes[XmlConstants.VALUE];

            processNamespaces(desc);

            setNameSpace(getNamespace(descriptor));

            for each(var meta:MetaDescriptor in desc.members)
            {
                addMember(desc.factory.getAnnotation(meta, this) as XmlMember);
            }

            constructor.parse(desc);

            memberAddFinished();
        }

        private function addMember(annotation:XmlMember):void
        {
            if (annotation && !isFieldRegistered(annotation))
            {
                if (annotation.hasNamespaceRef)
                {
                    annotation.setNameSpace(getRegisteredNamespace(annotation.namespaceRef));
                }
                else
                {
                    annotation.setNameSpace(nameSpace);
                }
                if (annotation is XmlArray)
                {
                    var xmlArray:XmlArray = XmlArray(annotation);
                    if (xmlArray.hasMemberNamespaceRef)
                    {
                        xmlArray.setMemberNamespace(getRegisteredNamespace(xmlArray.memberNamespaceRef));
                    }
                }
                members.push(annotation);
                membersMap[annotation.name.localName] = annotation;
                if (annotation.name.localName == id)
                {
                    idField = annotation;
                }
                if (annotation.alias == defaultValue)
                {
                    valueField = annotation;
                    //set member default value
                    annotation.isDefaultValue = true;
                }
            }
        }

        private function memberAddFinished():void
        {
            //Flex SDK 4 hotfix: we need to put the default field first, if it exists,
            // otherwise the default text will be added as a child of a previous element
            var member:XmlMember;
            var length:Number = members.length;
            for (var i:int = 0; i < length; i++)
            {
                member = members[i] as XmlMember;
                if (member.isDefaultValue)
                {
                    members.splice(i, 1);
                    members.splice(0, 0, member);
                    break;
                }
            }
        }

        private function processNamespaces(descriptor:ClassMetaDescriptor):void
        {
            var nss:Array = descriptor.getConfigItemsByName(XmlConstants.ANNOTATION_NAMESPACE);
            if (nss.length > 0)
            {
                var ns:Namespace;
                for each(var nsDesc:MetaDescriptor in nss)
                {
                    ns = getNamespace(nsDesc);
                    namespaces[ns.prefix] = ns;
                }
            }
        }

        private function getRegisteredNamespace(ref:String):Namespace
        {
            var namespace:Namespace = namespaces[ref];
            if (!namespace)
            {
                throw new DescriptorParsingError(type, "", "Namespace reference <<" + ref + ">> could not be found. Make sure you typed the prefix correctly and the namespace is registered as annotation of the containing class.");
            }
            return namespace as Namespace;
        }

        private function getNamespace(descriptor:MetaDescriptor):Namespace
        {
            var prefix:String = descriptor.attributes[XmlConstants.NAMESPACE_PREFIX];
            var uri:String = descriptor.attributes[XmlConstants.NAMESPACE_URI];
            if (uri == null || uri.length == 0)
            {
                try
                {
                    if (prefix)
                    {
                        return getRegisteredNamespace(prefix);
                    }
                } catch (e:Error)
                {
                    LOG.error("getRegisteredNamespace failed", e.getStackTrace());
                }
                return null;
            }
            else if (prefix != null && prefix.length > 0)
            {
                return new Namespace(prefix, uri);
            }
            return new Namespace(uri);
        }

        private function isFieldRegistered(annotation:Annotation):Boolean
        {
            for each (var member:Annotation in members)
            {
                if (member.name == annotation.name)
                {
                    return true;
                }
            }
            return false;
        }

        public function get sort():ISort
        {
            return _sort;
        }

        public function set sort(value:ISort):void
        {
            _sort = value;
            if(sort != null)
            {
                sort.sort(members);
            }
        }
    }
}