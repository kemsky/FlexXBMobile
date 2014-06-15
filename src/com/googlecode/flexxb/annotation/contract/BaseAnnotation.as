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
     * This is the base class for all annotations. It implements the most
     * basic contract, IAnnotation, and offers the means of retrieving the
     * metadata attributes and their values from the type descriptor. This
     * information is passed inthe constructor via a MetaDescriptor object
     * and one must override the protected methd parse in order to apply
     * the necesary attributes on their own annotations. This mechanism
     * makes the annotations to not require direct access to the xml
     * descriptor of the type being introspected.
     * @author Alexutz
     *
     */
    public class BaseAnnotation
    {
        public var annotationName:String;

        public var version:String;

        /**
         * @private
         */
        public function BaseAnnotation(descriptor:MetaDescriptor = null)
        {
            if (descriptor != null)
            {
                parse(descriptor);
            }
        }

        /**
         * Set the version of the current annotation
         * @param value version value
         *
         */
        protected final function setVersion(value:String):void
        {
            version = value ? value : Constants.DEFAULT;
        }

        /**
         * Analyze field/class descriptor to extract base informations like field's name and type.
         * Override this method in subclasses to add custom parsing of values extracted from the
         * annotation via the MetaDescriptor instance.
         * @param descriptor MetaDescriptor instance holding the key-value pairs of existing attributes
         * and their values as present in the metadata instrospection
         *
         */
        protected function parse(descriptor:MetaDescriptor):void
        {
            setVersion(descriptor.version);
        }
    }
}