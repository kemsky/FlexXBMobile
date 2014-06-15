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
package com.googlecode.flexxb.core
{
    import com.googlecode.flexxb.cache.ICacheProvider;

    /**
     * This class defines the settings the FlexXB Core and serialization contexts accept in
     * order to control processing. You may override this class to add more settings that
     * will be used in your serialization contexts and serializers.
     * @author Alexutz
     *
     */
    public class Configuration
    {
        /**
         * Constructor
         *
         */
        public function Configuration()
        {
        }
        /**
         * Serializing persistable objects can be done by including only the fields
         * whose values have been changed.
         */
        public var onlySerializeChangedValueFields:Boolean = false;

        /**
         * Set this flag to true if you want the engine to ignore missing content. By default this field is set on false.
         * By default FlexXB considers a missing serialized content representing a field value as being null and sets null as a value
         * for the appropriate field in the  ActionScript object. This is particularly usefull when you need to perform subsequent
         * calls in order to get pieces of data that will in the end construct the final object. By default, after each call, the
         * missing fields in the serialized data will be set to null and such the object will only have the values specified in the last call.
         * Set this flag to true in order to ignore missing values and not set null into the appropiate fields.
         */
        public var ignoreMissingContent:Boolean = false;

        /**
         * Determine the type of the object the response will be deserialised into
         * by the namespace defined in the received xml.
         * @default true
         */
        public var getResponseTypeByNamespace:Boolean = true;
        /**
         * Determine the type of the object the response will be deserialised into
         * by the root element name of the received xml.
         * @default true
         */
        public var getResponseTypeByTagName:Boolean = true;
        /**
         * Determine the type of the object the response will be deserialised into
         * by the xsi:type attribute present in the xml element representing the object.
         * @default false
         */
        public var getResponseTypeByXsiType:Boolean = false;
        /**
         * Set this flag to true if you want special chars to be escaped in the xml.
         * If set to false, text containing special characters will be enveloped in a CDATA tag.
         * This option applies to xml elements. For xml attributes special chars are automatically
         * escaped.
         */
        public var escapeSpecialChars:Boolean = false;

        /**
         * Flag signaling the presence or not of a cache provider. It is a
         * quick determination of the use of a caching mechanism.
         * @return true if cache is used, false otherwise
         *
         */
        public var allowCaching:Boolean;

        /**
         * Flag signaling whether the engine should attempt to automatically
         * determine the version of the received serialized document. This setting
         * is overridden by specifying a non empty version value when
         * deserializing the serialized document.
         * @return true if detection is auto, false otherwise
         *
         */
        public var autoDetectVersion:Boolean;

        /**
         * Reference to an ICacheProvider implementor. Use this field to instruct the engine to use
         * an object caching mechanism.
         */
        public var cacheProvider:ICacheProvider;
        /**
         * Reference to a version extractor instance used to determine automatically the version of
         * an serialized document.
         */
        private var _versionExtractor:IVersionExtractor;


        public function setCacheProvider(value:ICacheProvider):void
        {
            cacheProvider = value;
            allowCaching = value != null;
        }

        public function get versionExtractor():IVersionExtractor
        {
            return _versionExtractor;
        }

        public function set versionExtractor(value:IVersionExtractor):void
        {
            _versionExtractor = value;
            autoDetectVersion = value != null;
        }
    }
}