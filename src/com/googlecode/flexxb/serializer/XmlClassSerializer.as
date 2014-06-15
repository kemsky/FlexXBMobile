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
    import com.googlecode.flexxb.annotation.contract.XmlClass;
    import com.googlecode.flexxb.annotation.contract.XmlMember;
    import com.googlecode.flexxb.core.XmlDescriptionContext;
    import com.googlecode.flexxb.util.XmlUtils;
    import mx.logging.ILogger;
    import mx.logging.Log;

    /**
     *
     * @author Alexutz
     *
     */
    public final class XmlClassSerializer extends BaseSerializer
    {

        private static const LOG:ILogger = Log.getLogger("com.googlecode.flexxb.serializer.XmlClassSerializer");

        public function XmlClassSerializer(context:XmlDescriptionContext)
        {
            super(context);
        }

        public override function serialize(object:*, annotation:Annotation, serializedData:XML):XML
        {
            var xmlClass:XmlClass = annotation as XmlClass;
//            if (Log.isDebug())
//            {
//                LOG.debug("Serializing object of type {0}", xmlClass.name);
//            }
            var xml:XML = XmlUtils.template.copy();
            var cursor:XML = xml;
            if (xmlClass.isPath)
            {
                cursor = XmlUtils.setPathElement(xmlClass, xml);
                xml = xml.children()[0];
                cursor.appendChild(XmlUtils.template.copy());
                cursor = cursor.children()[0];
            }
            cursor.setNamespace(xmlClass.nameSpace);
            cursor.setName(new QName(xmlClass.nameSpace, xmlClass.alias));

            if (xmlClass.useOwnNamespace)
            {
                xml.addNamespace(xmlClass.nameSpace);
            }
            else
            {
                var member:XmlMember = xmlClass.getMember(xmlClass.childNameSpaceFieldName);
                if (member)
                {
                    var ns:Namespace = context.getNamespace(object[member.name]);
                    if (ns)
                    {
                        xml.addNamespace(ns);
                    }
                }
            }
            return xml;
        }

        public override function deserialize(serializedData:XML, annotation:Annotation):*
        {
            return null;
        }
    }
}