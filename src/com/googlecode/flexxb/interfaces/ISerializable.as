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
package com.googlecode.flexxb.interfaces
{

    /**
     * Interface for an object that requires custom serialization/deserialization into/from
     * a serialization format (XML, JSON, AMF etc.). Use this interface to instruct the engine
     * to delegate the serialization/deserialization task to the object itself.
     * @author aciobanu
     *
     *
     */
    public interface ISerializable extends IIdentifiable
    {
        /**
         * Serialize current object into a serialization format
         */
        function serialize():XML;

        /**
         * Deserialize this object from its serialized representation.
         * @param source serialized data source
         */
        function deserialize(source:XML):*;

        /**
         * Extract the object's identifier from the serialized source if
         * such an identifier exists.
         * @param source serialized data source
         * @return string representing object's identifier
         *
         */
        function getIdValue(source:XML):String;
    }
}