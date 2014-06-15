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
    import com.googlecode.flexxb.core.Configuration;
    import com.googlecode.flexxb.core.MissingFieldDataException;
    import com.googlecode.flexxb.core.SerializationCore;
    import com.googlecode.flexxb.core.XmlDescriptionContext;
    import com.googlecode.flexxb.util.cdata;

    import flash.utils.Dictionary;
    import flash.xml.XMLNode;
    import flash.xml.XMLNodeType;

    /**
     *
     * @author Alexutz
     *
     */
    public class BaseSerializer
    {
        protected static const missingFieldDataException:MissingFieldDataException = new MissingFieldDataException();

        protected var context:XmlDescriptionContext;

        protected var configuration:Configuration;

        protected var simpleTypes:Dictionary;

        protected var serializer:SerializationCore;

        public function BaseSerializer(context:XmlDescriptionContext)
        {
            this.context = context;
            this.configuration = context.configuration;
            this.simpleTypes = context.getSimpleTypes();
            this.serializer = context.serializer;
        }

        /**
         * Serialize an object into a serialization format
         * @param object Object to be serialized
         * @param annotation Annotation containing the conversion parameters
         * @param serializedData Serialized data written so far
         * @serializer
         * @return Generated serialized data
         *
         */
        public function serialize(object:*, annotation:Annotation, serializedData:XML):XML
        {
            return null;
        }

        /**
         * Deserialize an xml into the appropiate AS3 object
         * @param xmlData Xml to be deserialized
         * @param annotation Annotation containing the conversion parameters
         * @serializer
         * @return Generated object
         *
         */
        public function deserialize(serializedData:XML, annotation:Annotation):*
        {
            return null;
        }

        protected final function signalMissingField():void
        {
            if (configuration.ignoreMissingContent)
            {
                throw missingFieldDataException;
            }
        }

        protected final function escapeValue(value:*):XML
        {
            if (configuration.escapeSpecialChars)
            {
                return new XML(new XMLNode(XMLNodeType.TEXT_NODE, value));
            }
            else
            {
                return cdata(value);
            }
        }
    }
}