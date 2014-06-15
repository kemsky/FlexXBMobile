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
    import com.googlecode.flexxb.annotation.contract.Constants;
    import flash.utils.Dictionary;
    import mx.logging.ILogger;
    import mx.logging.Log;

    /**
     * API wrapper for a class type. Allows programatically defining all the
     * elements that would normally be specified via annotations.
     * @author Alexutz
     *
     */
    public class FxClass implements IFxMetaProvider
    {
        private static const log:ILogger = Log.getLogger("com.googlecode.flexxb.api.FxClass");

        [XmlAttribute]
        public var version:String = "";

        [XmlArray(alias="ConstructorArguments", type="com.googlecode.flexxb.api.FxConstructorArgument")]
        [ArrayElementType("com.googlecode.flexxb.api.FxConstructorArgument")]
        public var constructorArguments:Array;

        [XmlAttribute]
        public var type:Class;

        private var _members:Array = [];

        /**
         * Constructor
         * @param type class type
         * @param alias class alias
         */
        public function FxClass(type:Class = null)
        {
            this.type = type;
        }

        [XmlArray(alias="Members", getRuntimeType="true")]
        [ArrayElementType("com.googlecode.flexxb.api.FxMember")]
        public final function get members():Array
        {
            return _members;
        }

        public final function set members(value:Array):void
        {
            _members = value;
            for each(var member:FxMember in value)
            {
                member.owner = this;
                onMemberAdded(member);
            }
        }

        public function getMetadataName():String
        {
            return "";
        }

        public function getMappingValues():Dictionary
        {
            var values:Dictionary = new Dictionary();
            values[Constants.VERSION] = version;
            return values;
        }

        /**
         *
         * @return
         *
         */
        public function getGlobalAnnotations():Array
        {
            return null;
        }

        /**
         * Add a constructor argument. Arguments are used in order to correctly instantiate objects upon deserialization
         * taking into account default and parameterized constructor.
         * @param fieldName field name
         * @param optional Flag signaling whether the argument is optional or not (eg. default valued parameters)
         *
         */
        public final function addArgument(fieldName:String, optional:Boolean = false):void
        {
            if (!constructorArguments)
            {
                constructorArguments = [];
            }
            constructorArguments.push(new FxConstructorArgument(fieldName, optional));
        }

        /**
         *
         * @param name
         * @return
         *
         */
        protected final function hasMember(name:String):Boolean
        {
            for each (var member:FxMember in members)
            {
                if (member.fieldName == name)
                {
                    return true;
                }
            }
            return false;
        }

        /**
         * Add a class member
         * @param member class member (subclass of FxMember)
         *
         */
        public final function addMember(member:FxMember):void
        {
            if (hasMember(member.fieldName))
            {
                throw new Error("Field <" + member.fieldName + "> has already been defined for class type " + type);
            }
            member.owner = this;
            members.push(member);
            onMemberAdded(member);
        }

        /**
         * Get string representation of the current instance
         * @return string representing the current instance
         */
        public function toString():String
        {
            return "Class[type: " + type + "]";
        }

        /**
         *
         * @param member
         *
         */
        protected function onMemberAdded(member:FxMember):void
        {
        }
    }
}