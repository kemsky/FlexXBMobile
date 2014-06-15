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

    /**
     * This enumeration defines the preocessing directions supported by the
     * FlexXBEngine: serialize and deserialize
     * @author Alexutz
     *
     */
    public final class Stage
    {
        private static const SERIALIZE_NAME:String = "serialize";

        public static const SERIALIZE:Stage = new Stage(SERIALIZE_NAME);

        private static const DESERIALIZE_NAME:String = "deserialize";

        public static const DESERIALIZE:Stage = new Stage(DESERIALIZE_NAME);

        /**
         * Obtain a Stage instance from a string value.
         * @param value string representation
         * @return Stage instance if the value is valid, <code>null</code> otherwise
         *
         */
        public static function fromString(value:String):Stage
        {
            if (value == DESERIALIZE_NAME)
            {
                return DESERIALIZE;
            }
            if (value == SERIALIZE_NAME)
            {
                return SERIALIZE;
            }
            return null;
        }

        private static var initialized:Boolean = false;
        {
            initialized = true;
        }

        private var name:String;

        /**
         * @private
         *
         */
        public function Stage(name:String)
        {
            if (initialized)
            {
                throw new Error("Use static fields instead.");
            }
            this.name = name;
        }

        /**
         * Get a string representation of the current instance
         * @return
         *
         */
        public function toString():String
        {
            return name;
        }
    }
}