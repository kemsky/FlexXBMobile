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
    import flash.utils.Dictionary;

    /**
     *
     * @author User
     *
     */
    public interface IFxMetaProvider
    {
        /**
         * Get the name of the metadata this class describes
         * @return metadata name
         *
         */
        function getMetadataName():String;

        /**
         * Get a dictionary with key-value pairs representing the
         * annotation attribute names and their values. This map
         * is used by the API to construct the actual descriptors
         * used by FlexXB to process the objects and serialized data
         * @return Dictionary instance
         *
         */
        function getMappingValues():Dictionary;
    }
}