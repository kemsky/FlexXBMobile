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
     * Defines a constructor argument. This annotaton is used when a class has a
     * non default constructor. In order to maintain the business restrictions, FlexXB
     * will determine the values of the arguments based on the received xml and call
     * the constructor with those values.
     * <p/>An argument has a reference; the reference is the name of the class field
     * whose value it represents. A non default constructor will most often configure
     * some of the object's fields when called. Since the only available data is the
     * incoming xml, arguments must specify the field the the constructor will modify
     * with the received value.
     * <p/><b>The class field referenced in the argument must have an annotation defined
     *  for it</b>
     * @author Alexutz
     *
     */
    public class ConstructorArgument extends BaseAnnotation implements IGlobalAnnotation
    {
        public static const ANNOTATION_CONSTRUCTOR_ARGUMENT:String = "ConstructorArg";

        public var referenceField:String;

        public var optional:Boolean;

        private var _owner:XmlClass;

        /**
         * Constructor
         *
         */
        public function ConstructorArgument(descriptor:MetaDescriptor = null)
        {
            super(descriptor);
            _owner = descriptor ? descriptor.owner : null;
            annotationName = ANNOTATION_CONSTRUCTOR_ARGUMENT;
        }

        public function get classAnnotation():XmlClass
        {
            return _owner;
        }

        protected override function parse(descriptor:MetaDescriptor):void
        {
            super.parse(descriptor);
            referenceField = descriptor.attributes[Constants.REF];
            optional = descriptor.getBoolean(Constants.OPTIONAL);
        }
    }
}