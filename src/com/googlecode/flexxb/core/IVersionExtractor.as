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
    /**
     * This interface is used to determine the version of an incoming document. The version
     * is considerent consistent throughout the entire document and as such the engine
     * will extract it once per received document.
     * @author Alexutz
     *
     */
    public interface IVersionExtractor
    {
        /**
         * Method that returns the version string al located in the source document. Override this
         * method to implement different extraction algorithms.
         * @param source document
         * @return string value representing the document's version
         *
         */
        function getVersion(source:Object):String;
    }
}