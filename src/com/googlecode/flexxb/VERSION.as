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
package com.googlecode.flexxb
{

    /**
     *
     * @author Alexutz
     *
     */
    public final class VERSION
    {
        /**
         *
         * @return
         *
         */
        public static function get Version():String
        {
            return "2.3.0";
        }

        /**
         *
         * @return
         *
         */
        public static function get Name():String
        {
            return "FlexXB";
        }

        /**
         *
         * @return
         *
         */
        public static function get Link():String
        {
            return "http://code.google.com/p/flexxb";
        }

        public function VERSION()
        {
            throw new Error("Do not instanciate this class");
        }

    }
}