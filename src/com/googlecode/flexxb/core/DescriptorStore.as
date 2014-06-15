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
    import avmplus.R;

    import com.googlecode.flexxb.annotation.contract.AnnotationFactory;
    import com.googlecode.flexxb.annotation.contract.XmlClass;
    import com.googlecode.flexxb.annotation.parser.MetaParser;
    import com.googlecode.flexxb.interfaces.ISerializable;
    import avmplus.Types;

    import flash.utils.Dictionary;

    /**
     *
     * @author aCiobanu
     *
     */
    public final class DescriptorStore
    {
        /**
         * @private
         */
        private var descriptorCache:Dictionary = new Dictionary();
        /**
         * @private
         */
        private var parser:MetaParser;

        private var _factory:AnnotationFactory;

        public function DescriptorStore(theFactory:AnnotationFactory)
        {
            parser = new MetaParser(theFactory);
            _factory = theFactory;
        }

        public function get factory():AnnotationFactory
        {
            return _factory;
        }

        public function getDescriptor(item:*, version:String = ""):XmlClass
        {
            var className:String = Types.getQualifiedClassName(item);

            var store:ResultStore = descriptorCache[className];

            if (store == null)
            {
                store = put(item, className);
            }

            return store.getDescriptor(version);
        }

        public function getClassReferenceByCriteria(field:String, value:String, version:String = ""):Class
        {
            var descriptor:Object;
            for each (var store:ResultStore in descriptorCache)
            {
                descriptor = store.getDescriptor(version);
                if (descriptor && descriptor.hasOwnProperty(field) && descriptor[field] == value)
                {
                    return XmlClass(descriptor).type;
                }
            }
            return null;
        }

        /**
         * Determine whether the object is custom serializable or not
         * @param object
         * @return true if the object is custom serialisable, false otherwise
         *
         */
        public function isCustomSerializable(item:Object):Boolean
        {
            var className:String = Types.getQualifiedClassName(item);

            var store:ResultStore = descriptorCache[className];
            if (store == null)
            {
                store = put(item, className);
            }

            return store.reference != null;
        }

        /**
         * Get the reference instance defined for a custom serializable type
         * @param clasz
         * @return object type instance
         *
         */
        public function getCustomSerializableReference(clasz:Class):ISerializable
        {
            var className:String = Types.getQualifiedClassName(clasz);
            return getDefinition(clasz, className).reference as ISerializable;
        }

        /**
         *
         * @param xmlDescriptor
         * @param type
         *
         */
        public function registerDescriptor(xmlDescriptor:Object, type:Class):void
        {
            var className:String = Types.getQualifiedClassName(type);
            if (hasDescriptorDefined(className))
            {
                return;
            }
            putDescriptorInCache(xmlDescriptor, className, false);
        }

        private function describe(json:Object):Array
        {
            //get class annotation
            var descriptors:Array = parser.parseDescriptor(json);
            return descriptors;
        }

        private function hasDescriptorDefined(className:String):Boolean
        {
            return descriptorCache[className] != null;
        }

        private function getDefinition(object:Object, className:String):ResultStore
        {
            if (descriptorCache[className] == null)
            {
                put(object, className);
            }
            return descriptorCache[className];
        }

        private function put(object:*, className:String):ResultStore
        {
            var json:Object = R.describe(object,  R.ACCESSORS | R.VARIABLES | R.METADATA | R.TRAITS | R.INTERFACES | R.CONSTRUCTOR);

            var customSerializable:Boolean;
            for each (var interf:String in json.traits.interfaces)
            {
                if (interf == "com.googlecode.flexxb.interfaces::ISerializable")
                {
                    customSerializable = true;
                    break;
                }
            }
            return putDescriptorInCache(json, className, customSerializable);
        }

        private function putDescriptorInCache(descriptor:Object, className:String, customSerializable:Boolean):ResultStore
        {
            var xmlClasses:Array;
            var referenceObject:Object;
            if (customSerializable)
            {
                var cls:Class = Types.getDefinitionByName(className) as Class;
                referenceObject = new cls();
            }
            else
            {
                xmlClasses = describe(descriptor);
            }
            var resultStore:ResultStore = new ResultStore(xmlClasses, customSerializable, referenceObject);
            descriptorCache[className] = resultStore;
            return resultStore;
        }
    }
}

import com.googlecode.flexxb.annotation.contract.XmlClass;
import com.googlecode.flexxb.annotation.contract.Constants;

import flash.utils.Dictionary;

/**
 *
 * @author Alexutz
 * @private
 */
internal class ResultStore
{
    /**
     * @private
     */
    private var descriptors:Dictionary;
    /**
     * @private
     */
    public var customSerializable:Boolean;
    /**
     * @private
     */
    public var reference:Object;

    /**
     * @private
     * @param descriptor
     * @param customSerializable
     * @param reference
     *
     */
    public function ResultStore(descriptors:Array, customSerializable:Boolean, reference:Object)
    {
        this.customSerializable = customSerializable;
        this.reference = reference;
        this.descriptors = new Dictionary();
        for each(var descriptor:XmlClass in descriptors)
        {
            this.descriptors[(descriptor.version ? descriptor.version : Constants.DEFAULT)] = descriptor;
        }
    }

    /**
     * Get the descriptor associated to the version supplied. If none is found
     * the default descriptor will be returned
     * @param version version value
     * @return IClassAnnotation implementor instance
     *
     */
    public function getDescriptor(version:String):XmlClass
    {
        var annotationVersion:String = version;
        if (!descriptors[annotationVersion])
        {
            annotationVersion = Constants.DEFAULT;
        }
        return descriptors[annotationVersion];
    }
}