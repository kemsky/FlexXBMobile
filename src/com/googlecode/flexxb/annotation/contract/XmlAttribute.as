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
     * <p>Usage: <code>[XmlAttribute(alias="attribute", ignoreOn="serialize|deserialize", order="order_index",
     * namespace="NameSpace_Prefix", default="DEFAULT_VALUE", idref="true|false", version="versionName")]</code></p>
     * @author aCiobanu
     *
     */
    public final class XmlAttribute extends XmlMember
    {
        /**
         * Annotation's name
         */
        public static const ANNOTATION_NAME:String = "XmlAttribute";

        /**
         * Constructor
         * @param descriptor xml descriptor from which to parse the data
         * @param classDescriptor owner XmlClass object
         *
         */
        public function XmlAttribute(descriptor:MetaDescriptor = null)
        {
            super(descriptor);

            annotationName = ANNOTATION_NAME;
        }
    }
}