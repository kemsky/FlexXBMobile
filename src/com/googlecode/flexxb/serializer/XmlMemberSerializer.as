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
    import com.googlecode.flexxb.annotation.contract.Annotation;
    import com.googlecode.flexxb.annotation.contract.XmlElement;
    import com.googlecode.flexxb.annotation.contract.XmlMember;
    import com.googlecode.flexxb.core.SerializationCore;
    import com.googlecode.flexxb.core.XmlDescriptionContext;
    import com.googlecode.flexxb.util.XmlUtils;
    import com.googlecode.flexxb.util.cdata;

    /**
     *
     * @author Alexutz
     *
     */
    internal class XmlMemberSerializer extends BaseSerializer
    {
        public function XmlMemberSerializer(context:XmlDescriptionContext)
        {
            super(context);
        }

        public override function serialize(object:*, annotation:Annotation, serializedData:XML):XML
        {
            var element:XmlMember = annotation as XmlMember;
            var parentXml:XML = serializedData as XML;


            var location:XML = parentXml;

            if (element.isPath)
            {
                location = XmlUtils.setPathElement(element, parentXml);
            }

            if (element.isDefaultValue)
            {
                //wrapCDATA was not checked here
                if(element is XmlElement && XmlElement(element).wrapCDATA)
                {
                    location.appendChild(cdata(serializer.objectToString(object, element.type)));
                }
                else
                {
                    location.appendChild(serializer.objectToString(object, element.type));
                }
                return null;
            }

            if (element.hasNamespaceRef && element.nameSpace != element.ownerClass.nameSpace && XmlUtils.mustAddNamespace(element.nameSpace, parentXml))
            {
                parentXml.addNamespace(element.nameSpace);
            }

            serializeObject(object, element, location);

            return location;
        }

        /**
         *
         * @param object
         * @param annotation
         * @param serializer
         * @return
         *
         */
        protected function serializeObject(object:*, annotation:XmlMember, parentXml:XML):void
        {
        }

        public override function deserialize(serializedData:XML, annotation:Annotation):*
        {
            var element:XmlMember = annotation as XmlMember;
            var xmlData:XML = serializedData as XML;

            var xmlElement:XML;

            if (element.isPath)
            {
                xmlElement = XmlUtils.getPathElement(element, xmlData);
            }
            else
            {
                xmlElement = xmlData;
            }

            if (xmlElement == null)
            {
                signalMissingField();
                return null;
            }

            if (element.isDefaultValue)
            {
                for each (var child:XML in xmlElement.children())
                {
                    if (child.nodeKind() == "text")
                    {
                        return serializer.stringToObject(child.toString(), element.type); //fixed CDATA deserialization
                    }
                }
            }

            var xmlName:QName;
            if (element.useOwnerAlias)
            {
                xmlName = context.getXmlName(element.type);
            }
            else
            {
                xmlName = element.xmlName;
            }

            var value:Object = deserializeObject(xmlElement, xmlName, element);
            return value;
        }

        protected function deserializeObject(xmlData:XML, xmlName:QName, annotation:XmlMember):*
        {
            return null;
        }
    }
}