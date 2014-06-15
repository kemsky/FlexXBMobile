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
package com.googlecode.flexxb.converter
{

    /**
     * Interface defining how strings can be converted to
     * specific objects and viceversa.
     * @author aCiobanu
     *
     */
    public interface IConverter
    {
        /**
         *
         * @return Object type
         *
         */
        function get type():Class;

        /**
         * Get the string representation of the specified object
         * @param item Target object
         * @return String representation of the specified object
         *
         */
        function toString(item:Object):String;

        /**
         * Get the object whose representation is the specified value
         * @param value String parameter from which the object is created
         * @return Object whose representation is the specified value
         *
         */
        function fromString(value:String):Object;
    }
}