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
    import com.googlecode.flexxb.annotation.parser.ClassMetaDescriptor;
    import com.googlecode.flexxb.annotation.parser.MetaDescriptor;
    import com.googlecode.flexxb.error.DescriptorParsingError;

    import flash.utils.Dictionary;

    /**
     * Defines the class constructor. Notifies the owner XmlClass whether the
     * described type has a default constructor or not.
     * @author Alexutz
     *
     */
    public class Constructor
    {
        private var owner:XmlClass;

        private var fieldMap:Dictionary = new Dictionary();

        public var parameterFields:Array = [];

        public var isDefault:Boolean = true;

        /**
         * Constructor
         *
         */
        public function Constructor(owner:XmlClass)
        {
            this.owner = owner;
        }

        public function hasParameterField(fieldAnnotation:XmlMember):Boolean
        {
            return !isDefault && fieldMap[fieldAnnotation.name.localName];
        }

        public function parse(descriptor:ClassMetaDescriptor):void
        {
            var arguments:Array = descriptor.getConfigItemsByName(ConstructorArgument.ANNOTATION_CONSTRUCTOR_ARGUMENT);
            // multiple annotations on the same field are returned in reverse order with describeType
            var args:int = 0;
            for (var i:int = arguments.length - 1; i >= 0; i--)
            {
                var argument:ConstructorArgument = descriptor.factory.getAnnotation(arguments[i] as MetaDescriptor, owner) as ConstructorArgument;
                if (!argument)
                {
                    throw new DescriptorParsingError(owner.type, "<<Constructor>>", "Null argument.");
                }
                if (fieldMap[argument.referenceField] != null)
                {
                    throw new DescriptorParsingError(owner.type, argument.referenceField, "Argument " + argument.referenceField + " already exists.");
                }
                args++;
                var fieldAnnotation:XmlMember = owner.getMember(argument.referenceField);
                if (!fieldAnnotation)
                {
                    throw new DescriptorParsingError(owner.type, argument.referenceField, "Annotation for referred field does not exist");
                }
                fieldMap[argument.referenceField] = fieldAnnotation;
                parameterFields.push(fieldAnnotation);
            }

            isDefault = args == 0;
        }
    }
}