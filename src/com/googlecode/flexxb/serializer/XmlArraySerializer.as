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
package com.googlecode.flexxb.serializer
{
    import com.googlecode.flexxb.annotation.contract.XmlArray;
    import com.googlecode.flexxb.annotation.contract.XmlClass;
    import com.googlecode.flexxb.annotation.contract.XmlMember;
    import com.googlecode.flexxb.core.XmlDescriptionContext;
    import avmplus.Types;
    import com.googlecode.flexxb.util.XmlUtils;
    import mx.collections.ArrayCollection;
    import mx.collections.ArrayList;
    import mx.collections.ListCollectionView;
    import mx.logging.ILogger;
    import mx.logging.Log;

    /**
     * Insures serialization/deserialization for object field decorated with the XmlArray annotation.
     * @author Alexutz
     *
     */
    public final class XmlArraySerializer extends XmlMemberSerializer
    {

        private static const LOG:ILogger = Log.getLogger("com.googlecode.flexxb.serializer.XmlArraySerializer");

        /**
         *Constructor
         *
         */
        public function XmlArraySerializer(context:XmlDescriptionContext)
        {
            super(context);
        }

        protected override function serializeObject(object:*, annotation:XmlMember, parentXml:XML):void
        {
            var result:XML = XmlUtils.template.copy();
            var xmlArray:XmlArray = annotation as XmlArray;
            var child:XML;
            if (object is ArrayList)
            {
                object = object.source;
            }

            //todo this is incorrect if getRuntimeType is set
            var elementType:Class = xmlArray.memberType;
            if(elementType == null && object != null && object.length > 0 && object[0] != null)
            {
                elementType = object[0] != null ? object[0].constructor: null;
            }

            for each (var member:Object in object)
            {
                if (xmlArray.isIDRef)
                {
                    child = new XML(serializer.getObjectId(member));
                    if (xmlArray.memberName)
                    {
                        var temp:XML = XmlUtils.template.copy();
                        temp.setName(xmlArray.memberName);
                        temp.appendChild(child);
                        child = temp;
                    }
                }
                else if ((elementType == null && member!= null && simpleTypes[Types.getDefinitionByName(Types.getQualifiedClassName(member)) as Class] == null)||
                        elementType != null && simpleTypes[elementType] == null)
                {
                    child = serializer.serialize(member, xmlArray.serializePartialElement, annotation.version);
                    if (xmlArray.memberName)
                    {
                        if (annotation.hasNamespaceDeclaration)
                        {
                            //need to set a qualified name for the member element
                            var xmlMemberName:QName = new QName(annotation.nameSpace.uri, xmlArray.memberName.localName);
                            child.setName(xmlMemberName);
                        }
                        else
                        {
                            child.setName(xmlArray.memberName);
                        }
                    }
                }
                else
                {
                    var stringValue:String = serializer.objectToString(member, xmlArray.memberType);
                    var xmlValue:XML;
                    try
                    {
                        xmlValue = new XML(stringValue);
                    }
                    catch (error:Error)
                    {
                        xmlValue = escapeValue(stringValue);
                    }

                    if (xmlArray.memberName)
                    {
                        child = XmlUtils.template.copy();
                        child.setName(xmlArray.memberName);
                        child.appendChild(xmlValue);
                    }
                    else
                    {
                        child = xmlValue;
                    }
                }
                //If the setXsiType flag is set then we should add an xsi:type attribuute to
                //the child being created now. Means we expect a derived class object.
                if (XmlArray(annotation).setXsiType)
                {
                    child.addNamespace(XmlUtils.xsiNamespace);
                    var childAnnotation:XmlClass = serializer.descriptorStore.getDescriptor(member, annotation.version) as XmlClass;
                    if (childAnnotation.hasNamespaceDeclaration)
                    {
                        //if child has namespace, then xsi type needs to include it
                        child.addNamespace(childAnnotation.nameSpace);
                        child.@[XmlUtils.xsiType] = childAnnotation.nameSpace.prefix + ":" + childAnnotation.alias;
                    }
                    else
                    {
                        child.@[XmlUtils.xsiType] = childAnnotation.alias;
                    }
                }
                result.appendChild(child);
            }
            if (xmlArray.useOwnerAlias)
            {
                for each (var subChild:XML in result.children())
                {
                    parentXml.appendChild(subChild);
                }
            }
            else
            {
                result.setName(xmlArray.xmlName);
                parentXml.appendChild(result);
            }
        }

        protected override function deserializeObject(xmlData:XML, xmlName:QName, element:XmlMember):*
        {
            var result:Object = new element.type();

            var array:XmlArray = element as XmlArray;

            var xmlArray:XMLList;
            //get the xml list representing the array
            if (array.useOwnerAlias)
            {
                if (array.memberName)
                {
                    xmlName = array.memberName;
                    xmlArray = xmlData.child(xmlName);
                }
                else if (array.memberType)
                {
                    xmlName = context.getXmlName(array.memberType);
                    xmlArray = xmlData.child(xmlName);
                }
                else
                {
                    xmlArray = xmlData.children();
                }
            }
            else
            {
                xmlName = array.xmlName;
                xmlArray = xmlData.child(xmlName);
                if (xmlArray.length() > 0)
                {
                    xmlArray = xmlArray.children();
                }
                else
                {
                    xmlArray = null;
                }
            }
            //extract the items from xml, build the result array and return it

            //todo better way for empty collections
            if (!xmlArray /*|| xmlArray.length() == 0*/)
            {
                signalMissingField();
                return result;
            }
            var list:Array = [];
            if (!array.memberName && xmlArray.length() == 1 && xmlArray[0].nodeKind() == "text")
            {
                // we need to handle differently the case in which we have items of simple type
                // and have no item name defined
                var values:Array = xmlArray[0].toString().split("\n");
                for each (var value:String in values)
                {
                    list.push(simpleTypes[array.memberType] == null ? serializer.deserialize(new XML(value), array.memberType, array.getFromCache, array.version) :  serializer.stringToObject(value, array.memberType));
                }
            }
            else
            {
                var type:Class = array.memberType;
                for each (var xmlChild:XML in xmlArray)
                {
                    if (array.getRuntimeType)
                    {
                        type = context.getIncomingType(xmlChild);
                        if (!type)
                        {
                            type = array.memberType;
                        }
                    }
                    if (array.isIDRef)
                    {
                        serializer.idResolver.addResolutionTask(list, null, xmlChild.toString());
                    }
                    else
                    {
                        var member:Object = simpleTypes[type] == null ? serializer.deserialize(xmlChild, type, array.getFromCache, array.version) : serializer.xmlToObject(xmlChild, type);
                        if (member != null)
                        {
                            list.push(member);
                        }
                    }
                }
            }

            if (element.type == Array)
            {
                result.push.apply(null, list);
            }
            else if (element.type == ArrayCollection || element.type == ArrayList)
            {
                result.source = list;
            }
            else if (result is ListCollectionView)
            {
                result.list = new ArrayList(list);
            }
            else if (Types.getQualifiedClassName(element.type).indexOf("__AS3__.vec::Vector") == 0)
            {
                result.push.apply(null, list);
            }
            else
            {
                throw new Error("Unsupported type: " + Types.getQualifiedClassName(result))
            }

            return result;
        }
    }
}
