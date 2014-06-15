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
    import avmplus.RMember;
    import avmplus.RObject;

    /**
     * This interface defines the api structure and access points
     * @author Alexutz
     *
     */
    public interface IFlexXBApi
    {
        /**
         * Register a type descriptor that is defined by the api components. This is especially
         * useful when not having access to source code.
         * @param apiDescriptor
         *
         */
        function processTypeDescriptor(apiDescriptor:FxClass):void;

        /**
         * Register the type descriptors by the mmeans of an xml file. The content is converted
         * to api components then they are processed to register the type described in the xml file.
         * @param xml
         *
         */
        function processDescriptorsFromXml(xml:XML):void;

        /**
         *
         * @param apiClass
         * @return
         *
         */
        function buildTypeDescriptor(apiClass:FxClass):RObject;

        /**
         *
         * @param member
         * @return
         *
         */
        function buildFieldDescriptor(member:FxMember):RMember;
    }
}