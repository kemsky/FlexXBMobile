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
    import avmplus.R;

    import com.googlecode.flexxb.annotation.parser.MetaDescriptor;
    import com.googlecode.flexxb.core.XmlDescriptionContext;
    import com.googlecode.flexxb.serializer.BaseSerializer;
    import flash.utils.Dictionary;
    import mx.logging.ILogger;
    import mx.logging.Log;

    /**
     * @private
     * This Factory will return an annotation instance based on the type required. Since each
     * annotation has a specific serializer, it will also provide the serializer instance to be
     * used when processing a field. Since they are stateless, serializers do not need to be
     * instanciated more than once.
     *
     * @author Alexutz
     *
     */
    public final class AnnotationFactory
    {
        private static const LOG:ILogger = Log.getLogger("com.googlecode.flexxb.annotation.contract.AnnotationFactory");

        private static const TRUE:Object = {};

        private var annotationMap:Dictionary = new Dictionary();
        private var annotationIsClass:Dictionary = new Dictionary();
        private var annotationIsMember:Dictionary = new Dictionary();
        private var annotationIsGlobal:Dictionary = new Dictionary();
        private var annotationSerializer:Dictionary = new Dictionary();
        private var annotationClass:Dictionary = new Dictionary();
        private var annotationContext:Dictionary = new Dictionary();

        /**
         * Constructor
         *
         */
        public function AnnotationFactory()
        {
        }

        /**
         * Check if there is an annotation with the given name registered in the factory.
         * @param metaName annotation name
         * @return true if an annotation with this name is registered, false otherwise
         *
         */
        public function isRegistered(metaName:String):Boolean
        {
            return annotationMap[metaName] != null;
        }

        /**
         *
         * @param metaName
         * @return
         *
         */
        public function isClassAnnotation(metaName:String):Boolean
        {
            return annotationIsClass[metaName] != null;
        }

        /**
         *
         * @param metaName
         * @return
         *
         */
        public function isMemberAnnotation(metaName:String):Boolean
        {
            return annotationIsMember[metaName] != null;
        }

        /**
         *
         * @param metaName
         * @return
         *
         */
        public function isGlobalAnnotation(metaName:String):Boolean
        {
            return annotationIsGlobal[metaName] != null;
        }

        /**
         * Register a new annotation and its serializer. If it finds a registration with the
         * same name and <code>overrideExisting </code> is set to <code>false</code>, it will disregard the current attempt and keep the old value.
         * @param name the name of the annotation to be registered
         * @param annotationClazz annotation class type
         * @param serializerClass instance of the serializer that will handle this annotation
         * @param context
         * @param overrideExisting
         *
         */
        public function registerAnnotation(name:String, annotationClazz:Class, serializerClass:Class, context:XmlDescriptionContext, overrideExisting:Boolean = false):void
        {
            if (overrideExisting || !annotationMap[name])
            {
                var json:Object = R.describe(annotationClazz, R.INTERFACES | R.TRAITS);

                annotationIsClass[name] = null;
                annotationIsMember[name] = null;
                annotationIsGlobal[name] = null;

                for each (var interf:Object in json.traits.interfaces)
                {
                    if("com.googlecode.flexxb.annotation.contract::IClassAnnotation" == interf)
                    {
                        annotationIsClass[name] = TRUE;
                    }
                    else if("com.googlecode.flexxb.annotation.contract::IMemberAnnotation" == interf)
                    {
                        annotationIsMember[name] = TRUE;
                    }
                    else if("com.googlecode.flexxb.annotation.contract::IGlobalAnnotation" == interf)
                    {
                        annotationIsGlobal[name] = TRUE;
                    }
                }

                annotationMap[name] = TRUE;
                annotationSerializer[name] = serializerClass != null ? new serializerClass(context) as BaseSerializer : null;
                annotationClass[name] = annotationClazz;
                annotationContext[name] = context;
            }
        }

        /**
         * Get serializer associated with the annotation
         * @param annotation target annotation
         * @return the serializer object or null if the annotation name is not registered
         */
        public function getSerializer(annotation:BaseAnnotation):BaseSerializer
        {
            return annotation ? annotationSerializer[annotation.annotationName] : null;
        }

        public function deserialize(serializedData:XML, annotation:Annotation):*
        {
            if(annotation != null)
            {
                var serializer:BaseSerializer = annotationSerializer[annotation.annotationName];

                if(serializer != null)
                {
                    return serializer.deserialize(serializedData, annotation);
                }
            }

            return null;
        }

        public function serialize(object:*, annotation:Annotation, serializedData:XML):XML
        {
            if(annotation != null)
            {
                var serializer:BaseSerializer = annotationSerializer[annotation.annotationName];

                if(serializer != null)
                {
                    return serializer.serialize(object, annotation, serializedData);
                }
            }

            return null;
        }

        public function getSerializerMap():Dictionary
        {
            return annotationSerializer;
        }

        /**
         * Get the annotation representing the xml field descriptor
         * @param field
         * @param descriptor
         * @return
         */
        public function getAnnotation(descriptor:MetaDescriptor, owner:XmlClass):BaseAnnotation
        {
            if (descriptor != null)
            {
                var annotationClass:Class = annotationClass[descriptor.metadataName];
                if (annotationClass != null)
                {
                    return new annotationClass(descriptor) as BaseAnnotation;
                }
            }
            return null;
        }

        public function getClassAnnotationName(memberMetadataName:String):String
        {
            if (annotationIsMember[memberMetadataName] != null)
            {
                var context:XmlDescriptionContext = annotationContext[memberMetadataName];
                if (context)
                {
                    for (var key:* in annotationMap)
                    {
                        if (annotationIsClass[key] != null && annotationContext[key] == context)
                        {
                            return key;
                        }
                    }
                    throw new Error("No class annotation defined in the description context for metadata named " + memberMetadataName);
                }
                throw new Error("Could not find a description context for metadata named " + memberMetadataName + ". Please make sure it is defined within your description context.");
            }
            return "";
        }
    }
}