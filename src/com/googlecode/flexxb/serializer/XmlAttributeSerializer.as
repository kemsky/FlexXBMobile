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
    import com.googlecode.flexxb.annotation.contract.XmlMember;
    import com.googlecode.flexxb.core.XmlDescriptionContext;
    import mx.logging.ILogger;
    import mx.logging.Log;

    /**
     * Insures serialization/deserialization for object field decorated with the XmlAttribute annotation
     * @author Alexutz
     *
     */
    public final class XmlAttributeSerializer extends XmlMemberSerializer
    {

        private static const LOG:ILogger = Log.getLogger("com.googlecode.flexxb.serializer.XmlAttributeSerializer");

        /**
         * Constructor
         *
         */
        public function XmlAttributeSerializer(context:XmlDescriptionContext)
        {
            super(context);
        }

        protected override function serializeObject(object:*, attribute:XmlMember, parentXml:XML):void
        {
            var value:String;
            if (simpleTypes[attribute.type] == null && attribute.isIDRef)
            {
                value = serializer.getObjectId(object);
            }
            else
            {
                value = serializer.objectToString(object, attribute.type);
            }
            parentXml.@[attribute.xmlName] = value;
        }

        protected override function deserializeObject(xmlData:XML, xmlName:QName, attribute:XmlMember):*
        {
//            if (Log.isDebug())
//            {
//                LOG.debug("Deserializing attribute <<{0}>> to field {1}", xmlName, attribute.name);
//            }
            var valueXML:XMLList = xmlData.attribute(xmlName);
            var value:String = "";
            if (valueXML.length() > 0)
            {
                value = valueXML[0];
            }
            else
            {
                signalMissingField();
                value = attribute.defaultSetValue;
            }
            var result:Object;
            if (attribute.isIDRef)
            {
                serializer.idResolver.addResolutionTask(serializer.currentObject, attribute.name, value);
            }
            else
            {
                result = serializer.stringToObject(value, attribute.type);
            }
            return result;
        }
    }
}