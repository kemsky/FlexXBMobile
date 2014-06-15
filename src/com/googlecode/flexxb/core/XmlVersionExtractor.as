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
     * This class is used to determine the version of an incoming document. The version
     * is considerent consistent throughout the entire document and as such the engine
     * will extract it once per received document. By default, the version extractor
     * searches for an attribute named "version".<br/>
     * If you require another kind of processing for versions you should extend this
     * class and override the <code>getVersion</code> method which returns a String and
     * accepts the xml document as source
     * @author Alexutz
     *
     */
    public class XmlVersionExtractor implements IVersionExtractor
    {
        private var isElement:Boolean;

        private var versionTagName:String;

        /**
         * Constructor
         * @param versionTagName name of the version tag
         * @param isElement boolean flag signaling whether the version is represented as an element or an attribute
         *
         */
        public function XmlVersionExtractor(versionTagName:String = "version", isElement:Boolean = false)
        {
            this.versionTagName = versionTagName;
            this.isElement = isElement;
        }

        /**
         * Method that returns the version string al located in the source xml document. Override this
         * method to implement different extraction algorithms.
         * @param source xml document
         * @return string value representing the document's version
         *
         */
        public function getVersion(source:Object):String
        {
            var version:String;
            if (isElement)
            {
                version = (source as XML).child(versionTagName);
            }
            else
            {
                version = (source as XML).@[versionTagName];
            }
            return version;
        }
    }
}