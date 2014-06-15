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
package com.googlecode.flexxb.error
{
    /**
     * Error thrown when the FlexXB engine encounters problems parsing the type descriptor xml
     * @author Alexutz
     *
     */
    public class DescriptorParsingError extends Error
    {
        /**
         *
         */
        public static const DESCRIPTOR_PARSING_ERROR_ID:int = 0;

        private var _type:Class;

        private var _fieldName:String;

        /**
         *
         * @param type
         * @param field
         * @param message
         *
         */
        public function DescriptorParsingError(type:Class, field:String, message:String = "")
        {
            super(message, DESCRIPTOR_PARSING_ERROR_ID);
            _type = type;
            _fieldName = field;
        }

        /**
         *
         * @return
         *
         */
        public function get type():Class
        {
            return _type;
        }

        /**
         *
         * @return
         *
         */
        public function get field():String
        {
            return _fieldName;
        }

        /**
         *
         * @return
         *
         */
        public function toString():String
        {
            var error:String = "Error encountered while processing the descriptor ";
            if (type)
            {
                error += "for type " + type;
            }
            if (field)
            {
                error += " (field " + field + ")";
            }
            if (message)
            {
                error += ":\n" + message;
            }
            return error;
        }
    }
}