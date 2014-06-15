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
    import com.googlecode.flexxb.annotation.contract.AnnotationFactory;

    /**
     * This interface defines a core that handles a specific way of serializing/deserializing
     * and object. It makes use of a serialization context to inject all the particularities
     * of a specific serialization format. Also, within the context serializers and converters
     * are registered.
     * @author Alexutz
     *
     */
    public interface IFlexXB
    {
        /**
         * Get a reference to the context initiating this serializer
         * @return Description context instance
         *
         */
        function get context():XmlDescriptionContext;

        /**
         * Get a reference to the configuration object
         * @return instance of type <code>com.googlecode.flexxb.Configuration</code>
         *
         */
        function get configuration():Configuration;

        /**
         * Do an early processing of types involved in the communication process if one
         * wants to bypass the lazy processing method implemented by the serializer.
         * @param args types to be processed
         *
         */
        function processTypes(...args):void;

        /**
         * Add a listener to an event being raised by the serialization process to signal various stages.
         * <br/>There are four stages being signaled through events: preserialize, postserialize, predeserialize
         * and postdeserialize.
         * @param type event type
         * @param listener listener function
         * @param priority priority
         * @param useWeakReference
         *
         */
        function addEventListener(type:String, listener:Function, priority:int = 0, useWeakReference:Boolean = false):void;

        /**
         * Remove a registered listener for a stage event
         * @param type event type
         * @param listener listener function
         *
         */
        function removeEventListener(type:String, listener:Function):void;

        /**
         * Convert an object to a serialized representation(string - XML - or byte array).
         * @param object object to be converted.
         * @param partial serialize the object in partial mode (only the object's id field)
         * @param version
         * @return serialized representation of the given object
         *
         */
        function serialize(object:*, partial:Boolean = false, version:String = ""):XML;

        /**
         * Convert a serialized data (string or byte) to an AS3 object counterpart
         * @param source serialized content to be deserialized
         * @param objectClass object class
         * @param getFromCache get the object from the model object cache if it exists, without processing the serialized data
         * @param version
         * @return object of type objectClass
         *
         */
        function deserialize(source:XML, objectClass:Class = null, getFromCache:Boolean = false, version:String = ""):*;

        function get factory():AnnotationFactory;
    }
}