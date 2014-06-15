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
    import com.googlecode.flexxb.annotation.contract.XmlConstants;
    import flash.utils.Dictionary;

    [XmlClass(alias="Namespace")]
    [ConstructorArg(reference="prefix")]
    [ConstructorArg(reference="uri")]
    public final class XmlApiNamespace implements IFxMetaProvider
    {
        [XmlAttribute]
        public var prefix:String;

        [XmlAttribute]
        public var uri:String;

        public function XmlApiNamespace(prefix:* = null, uri:* = null)
        {
            this.prefix = prefix;
            this.uri = uri;
        }

        public function getMetadataName():String
        {
            return "Namespace";
        }

        public function getMappingValues():Dictionary
        {
            var values:Dictionary = new Dictionary();
            values[XmlConstants.NAMESPACE_PREFIX] = prefix;
            values[XmlConstants.NAMESPACE_URI] = uri;
            return values;
        }

        /**
         * Get string representation of the current instance
         * @return string representing the current instance
         */
        public function toString():String
        {
            return "Namespace[ prefix: " + prefix + ", uri: " + uri + "]";
        }

        public static function create(ns:Namespace):XmlApiNamespace
        {
            if (ns)
            {
                return new XmlApiNamespace(ns.prefix, ns.uri);
            }
            return null;
        }
    }
}