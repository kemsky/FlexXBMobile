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
     * Enumeration defining field acces types. A class field can be accessed
     * in readonly, writeonly or readwrite modes.
     * @author Alexutz
     *
     */
    public class AccessorType
    {
        /**
         * read only
         */
        public static const READ_ONLY:AccessorType = new AccessorType("readonly");
        /**
         * write only
         */
        public static const WRITE_ONLY:AccessorType = new AccessorType("writeonly");
        /**
         * read write
         */
        public static const READ_WRITE:AccessorType = new AccessorType("readwrite");

        /**
         * Obtain an AccessorType instance from a string value. If the value is
         * invalid the READ_WRITE instance will be returned by default.
         * @param value
         * @return
         *
         */
        public static function fromString(value:String):AccessorType
        {
            switch (value)
            {
                case "readonly":
                    return READ_ONLY;
                    break;
                case "writeonly":
                    return WRITE_ONLY;
                    break;
                case "readwrite":
                    return READ_WRITE;
                    break;
                default:
                    return READ_WRITE;
            }
        }

        private static var initialized:Boolean = false;

        {
            initialized = true;
        }

        private var name:String;

        /**
         * Constructor
         * @param    name
         * @private
         */
        public function AccessorType(name:String)
        {
            if (initialized)
            {
                throw new Error("Use static fields instead.");
            }
            this.name = name;
        }

        /**
         * Check if the type is read only
         * @return true id type is read only, false otherwise
         *
         */
        public function isReadOnly():Boolean
        {
            return READ_ONLY == this;
        }

        /**
         * Check if the type is write only
         * @return true id type is write only, false otherwise
         *
         */
        public function isWriteOnly():Boolean
        {
            return WRITE_ONLY == this;
        }

        /**
         * Check if the type is read-write
         * @return true id type is read-write, false otherwise
         *
         */
        public function isReadWrite():Boolean
        {
            return READ_WRITE == this;
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