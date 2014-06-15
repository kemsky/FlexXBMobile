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
    import com.googlecode.flexxb.annotation.parser.MetaDescriptor;

    /**
     *
     * @author Alexutz
     *
     */
    public class XmlNamespace extends BaseAnnotation implements IGlobalAnnotation
    {
        public var uri:String;

        public var prefix:String;

        private var _owner:XmlClass;

        public function XmlNamespace(descriptor:MetaDescriptor = null)
        {
            super(descriptor);
            annotationName = XmlConstants.ANNOTATION_NAMESPACE;
        }

        public function get classAnnotation():XmlClass
        {
            return _owner;
        }

        protected override function parse(descriptor:MetaDescriptor):void
        {
            super.parse(descriptor);
            uri = descriptor.attributes[XmlConstants.NAMESPACE_URI];
            prefix = descriptor.attributes[XmlConstants.NAMESPACE_PREFIX];
        }
    }
}