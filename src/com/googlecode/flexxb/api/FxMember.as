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
    import com.googlecode.flexxb.annotation.contract.AccessorType;
    import com.googlecode.flexxb.annotation.contract.Constants;
    import com.googlecode.flexxb.annotation.contract.Stage;
    import com.googlecode.flexxb.error.ApiError;

    import flash.utils.Dictionary;

    import mx.logging.ILogger;
    import mx.logging.Log;

    use namespace flexxb_api_internal;

    /**
     * API member annotation wrapper. This is the base for member annotation
     * API description. It references the field from the parent type and base
     * attributes that all members will share: version and ignore flags.<br/>
     * All member annotations have a version in order to handle different
     * representations of the same object that may appear as appplication
     * develoment evolves. Also, some fields may be ignored in different stages
     * of the processing: serialize or deserialize.
     * @author Alexutz
     *
     */
    public class FxMember implements IFxMetaProvider
    {
        private static const log:ILogger = Log.getLogger("com.googlecode.flexxb.api.FxMember");

        [XmlAttribute]
        public var ignoreOn:Stage = null;

        [XmlAttribute]
        public var version:String = "";

        [XmlElement(alias="*")]
        public var field:FxField;

        internal var owner:FxClass;

        public function FxMember(field:FxField = null)
        {
            this.field = field;
        }

        public function get fieldName():String
        {
            return field.name;
        }

        public function get fieldType():Class
        {
            return field.type;
        }

        public function get fieldAccessType():AccessorType
        {
            return field.accessType;
        }

        public function getMetadataName():String
        {
            return "";
        }

        public function getMappingValues():Dictionary
        {
            var values:Dictionary = new Dictionary();
            if (ignoreOn)
            {
                values[Constants.IGNORE_ON] = ignoreOn;
            }
            values[Constants.VERSION] = version;
            return values;
        }

        protected final function getOwner():FxClass
        {
            return owner;
        }
    }
}