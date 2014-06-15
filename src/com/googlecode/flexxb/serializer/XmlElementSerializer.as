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
    import com.googlecode.flexxb.annotation.contract.XmlClass;
    import com.googlecode.flexxb.annotation.contract.XmlElement;
    import com.googlecode.flexxb.annotation.contract.XmlMember;
    import com.googlecode.flexxb.core.XmlDescriptionContext;
    import com.googlecode.flexxb.util.XmlUtils;
    import com.googlecode.flexxb.util.cdata;
    import mx.logging.ILogger;
    import mx.logging.Log;

    /**
     * Insures serialization/deserialization for object field decorated with the XmlElement annotation
     * @author Alexutz
     *
     */
    public class XmlElementSerializer extends XmlMemberSerializer
    {
        private static const LOG:ILogger = Log.getLogger("com.googlecode.flexxb.serializer.XmlElementSerializer");

        /**
         * Constructor
         *
         */
        public function XmlElementSerializer(context:XmlDescriptionContext)
        {
            super(context);
        }

        protected override function serializeObject(object:*, annotation:XmlMember, parentXml:XML):void
        {
            var child:XML = XmlUtils.template.copy();

            var xmlElement:XmlElement = XmlElement(annotation);

            if (object == null)
            {
                if (xmlElement.nillable)
                {
                    child.addNamespace(XmlUtils.xsiNamespace);
                    child.@[XmlUtils.xsiNil] = "true";
                }
            }
            else if (simpleTypes[annotation.type] == null)
            {
                if (annotation.isIDRef)
                {
                    child.appendChild(serializer.getObjectId(object));
                }
                else
                {
                    child = serializer.serialize(object, xmlElement.serializePartialElement, annotation.version);
                }
            }
            else if (annotation.type == XML)
            {
                child.appendChild(new XML(object));
            }
            else
            {
                var stringValue:String = serializer.objectToString(object, annotation.type);
                try
                {
                    if (xmlElement.wrapCDATA)
                    {
                        child.appendChild(cdata(stringValue));
                    }
                    else
                    {
                        child.appendChild(stringValue);
                    }
                } catch (error:Error)
                {
                    child.appendChild(escapeValue(stringValue));
                }
            }

            if (annotation.useOwnerAlias)
            {
                var name:QName = context.getXmlName(object, annotation.version);
                if (name)
                {
                    child.setName(name);
                }
            }
            else if (annotation.xmlName)
            {
                child.setName(annotation.xmlName);
            }
            //If the setXsiType flag is set then we should add an xsi:type attribuute to
            //the child being created now. Means we expect a derived class object.
            if (xmlElement.setXsiType)
            {
                child.addNamespace(XmlUtils.xsiNamespace);
                var childAnnotation:XmlClass = serializer.descriptorStore.getDescriptor(object, annotation.version);
                if (childAnnotation.hasNamespaceDeclaration)
                {
                    //if child has namespace, then xsi type needs to include it
                    child.addNamespace(childAnnotation.xmlName);
                    child.@[XmlUtils.xsiType] = childAnnotation.nameSpace.prefix + ":" + childAnnotation.alias;
                }
                else
                {
                    child.@[XmlUtils.xsiType] = childAnnotation.alias;
                }
            }
            parentXml.appendChild(child);
        }

        protected override function deserializeObject(xmlData:XML, xmlName:QName, element:XmlMember):*
        {
            var xmlElement:XmlElement = XmlElement(element);

            // AFAIK we can have a null xmlName only when getRuntimeType is true and the element
            //has a virtual path so the engine can detect the wrapper
            var type:Class = xmlElement.type;

            if (xmlElement.getRuntimeType)
            {
                if (xmlElement.isPath)
                {
                    if (xmlData.children().length() > 0)
                    {
                        xmlName = context.getXmlName(context.getIncomingType(xmlData.children()[0]));
                    }
                    else
                    {
                        signalMissingField();
                        return null;
                    }
                }
                else
                {
                    //??? Don't know yet what should happen in this case
                }
            }
//            if (Log.isDebug())
//            {
//                LOG.debug("Deserializing element <<{0}>> to field {1}", xmlName, xmlElement.name);
//            }
            var list:XMLList = xmlData.child(xmlName);
            var xml:XML;
            if (list.length() > 0)
            {
                xml = list[0];
            }
            else
            {
                if (xmlElement.defaultSetValue)
                {
                    xml = new XML(xmlElement.defaultSetValue);
                }
                else
                {
                    signalMissingField();
                    return null;
                }
            }
            if (xmlElement.isIDRef)
            {
                serializer.idResolver.addResolutionTask(serializer.currentObject, xmlElement.name, xml.toString());
                return null;
            }

            if (xmlElement.nillable && xml.@[XmlUtils.xsiNil] == "true")
            {
                return null;
            }

            if (xmlElement.getRuntimeType)
            {
                type = context.getIncomingType(list[0]);
                if (!type)
                {
                    type = element.type;
                }
            }
            return simpleTypes[type] == null ? serializer.deserialize(xml, type, xmlElement.getFromCache, xmlElement.version) : serializer.xmlToObject(xml, type);
        }
    }
}