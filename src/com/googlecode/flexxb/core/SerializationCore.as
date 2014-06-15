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
    import com.googlecode.flexxb.annotation.contract.Annotation;
    import com.googlecode.flexxb.annotation.contract.AnnotationFactory;
    import com.googlecode.flexxb.annotation.contract.Stage;
    import com.googlecode.flexxb.annotation.contract.XmlClass;
    import com.googlecode.flexxb.annotation.contract.XmlMember;
    import com.googlecode.flexxb.converter.IConverter;
    import com.googlecode.flexxb.interfaces.ICycleRecoverable;
    import com.googlecode.flexxb.interfaces.ISerializable;
    import avmplus.Types;
    import com.googlecode.flexxb.util.isNaNFast;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import mx.logging.ILogger;
    import mx.logging.Log;

    /**
     * @private
     * @author Alexutz
     *
     */
    public final class SerializationCore extends EventDispatcher
    {
        private static const LOG:ILogger = Log.getLogger("com.googlecode.flexxb.core.SerializationCore");

        private static const TRUE:Object = {};
        private var _simpleTypes:Dictionary = new Dictionary();
        private var classMap:Dictionary = new Dictionary();
        private var classNameMap:Dictionary = new Dictionary();

        public var idResolver:PropertyResolver;
        public var descriptorStore:DescriptorStore;
        public var configuration:Configuration;
        public var collisionDetector:ElementStack;
        public var factory:AnnotationFactory;
        public var context:XmlDescriptionContext;

        /**
         * Constructor
         *
         */
        public function SerializationCore(context:XmlDescriptionContext, descriptorStore:DescriptorStore)
        {
            _simpleTypes[Number] = TRUE;
            _simpleTypes[int] = TRUE;
            _simpleTypes[uint] = TRUE;
            _simpleTypes[String] = TRUE;
            _simpleTypes[Boolean] = TRUE;
            _simpleTypes[Date] = TRUE;
            _simpleTypes[XML] = TRUE;
            _simpleTypes[Class] = TRUE;

            this.context = context;
            this.configuration = context.configuration;
            this.factory = descriptorStore.factory;

            this.descriptorStore = descriptorStore;

            this.collisionDetector = new ElementStack();
            this.idResolver = new PropertyResolver();
        }


        public function get currentObject():Object
        {
            return collisionDetector.getCurrent();
        }

        /**
         * Convert an object to a serialized representation.
         * @param object object to be converted.
         * @param version
         * @param partial
         * @return serialized data representation of the given object
         */
        public final function serialize(object:*, partial:Boolean = false, version:String = ""):XML
        {
            if (object == null)
            {
                return null;
            }

            var serializedData:XML;

            object = pushObject(object, partial);

            if (descriptorStore.isCustomSerializable(object))
            {
                serializedData = ISerializable(object).serialize();
            }
            else
            {
                var classDescriptor:XmlClass = descriptorStore.getDescriptor(object, version);
                serializedData = factory.serialize(object, classDescriptor, null);
                var annotation:XmlMember;
                if (partial && classDescriptor.idField)
                {
                    doSerialize(object, classDescriptor.idField, serializedData);
                }
                else
                {
                    for each (annotation in classDescriptor.members)
                    {
                        if (annotation.writeOnly || annotation.ignoreOn == Stage.SERIALIZE)
                        {
                            continue;
                        }
                        doSerialize(object, annotation, serializedData);
                    }
                }
            }

            collisionDetector.pop();

            return serializedData;
        }

        public function getObjectId(object:Object):String
        {
            var classDescriptor:XmlClass = descriptorStore.getDescriptor(object);
            if (classDescriptor.idField)
            {
                return object[classDescriptor.idField.name];
            }
            return "";
        }

        private function pushObject(obj:Object, partial:Boolean):Object
        {
            var collisionDetected:Boolean = !collisionDetector.push(obj);
            if (collisionDetected)
            {
                if (partial)
                {
                    collisionDetector.pushNoCheck(obj);
                }
                else if (obj is ICycleRecoverable)
                {
                    obj = ICycleRecoverable(obj).onCycleDetected(collisionDetector.getCurrent());
                    obj = pushObject(obj, partial);
                }
                else
                {
                    throw new Error("Cycle detected!");
                }
            }
            return obj;
        }

        /**
         *
         * @param object
         * @param annotation
         * @param serializedData
         *
         */
        private function doSerialize(object:Object, annotation:Annotation, serializedData:XML):void
        {
            var target:Object = object[annotation.name];

            if ((target != null && !isNaNFast(target, annotation.type)) || (annotation is XmlMember && XmlMember(annotation).isRequired))
            {
                factory.serialize(target, annotation, serializedData);
            }
        }

        /**
         * Convert a serialized data to an AS3 object counterpart
         * @param serializedData data to be deserialized
         * @param objectClass object class
         * @param getFromCache
         * @param version
         * @return object of type objectClass
         *
         */
        public final function deserialize(serializedData:XML, objectClass:Class = null, getFromCache:Boolean = false, version:String = ""):*
        {
            if (serializedData)
            {
                if (!objectClass)
                {
                    objectClass = context.getIncomingType(serializedData);
                }
                if (objectClass)
                {
                    var result:*;
                    var itemId:String;
                    var foundInCache:Boolean;
                    var classDescriptor:XmlClass;
                    var isCustomSerializable:Boolean = descriptorStore.isCustomSerializable(objectClass);

                    if (isCustomSerializable)
                    {
                        itemId = descriptorStore.getCustomSerializableReference(objectClass).getIdValue(serializedData);
                    }
                    else
                    {
                        classDescriptor = descriptorStore.getDescriptor(objectClass);
                        if (factory.getSerializer(classDescriptor.idField))
                        {
                            try
                            {
                                itemId = String(factory.deserialize(serializedData, classDescriptor.idField));
                            } catch (e:MissingFieldDataException)
                            {
                            }
                        }
                    }

                    //get object from cache
                    if (configuration.allowCaching && itemId)
                    {
                        result = configuration.cacheProvider.getFromCache(itemId, objectClass);
                        if(result != null)
                        {
                            if (getFromCache)
                            {
                                return result;
                            }
                            else
                            {
                                result = configuration.cacheProvider.getFromCache(itemId, objectClass);
                                foundInCache = result != null;
                            }
                        }
                    }


                    if (!isCustomSerializable)
                    {
                        classDescriptor = descriptorStore.getDescriptor(objectClass, version);
                    }

                    if (!foundInCache)
                    {
                        //if object is auto processed, get constructor arguments declarations
                        var contructorArgs:Array;
                        if (!isCustomSerializable && !classDescriptor.constructor.isDefault)
                        {
                            contructorArgs = [];
                            for each (var member:XmlMember in classDescriptor.constructor.parameterFields)
                            {
                                //On deserialization, when using constructor arguments, we need to process them even though the ignoreOn
                                //flag is set to deserialize stage.
                                contructorArgs.push(factory.deserialize(serializedData, member));
                            }
                        }
                        //create object instance
                        if (configuration.allowCaching)
                        {
                            result = configuration.cacheProvider.getNewInstance(objectClass, itemId, contructorArgs);
                        }
                        else
                        {
                            result = contructorArgs ? getInstance(objectClass, contructorArgs) : new objectClass();
                        }
                    }

                    if (itemId)
                    {
                        idResolver.bind(itemId, result);
                    }

                    collisionDetector.pushNoCheck(result);

                    //update object fields
                    if (isCustomSerializable)
                    {
                        var tmp:Object = ISerializable(result).deserialize(serializedData);
                        //if they return null then it suks. Keep the original reference See Issue 47: http://code.google.com/p/flexxb/issues/detail?id=47
                        if (tmp != null)
                        {
                            result = tmp as ISerializable;
                        }
                    }
                    else
                    {
                        //iterate through anotations
                        for each (var annotation:XmlMember in classDescriptor.members)
                        {
                            if (annotation.readOnly || classDescriptor.constructor.hasParameterField(annotation))
                            {
                                continue;
                            }
                            if (annotation.ignoreOn == Stage.DESERIALIZE)
                            {
                                // Let's keep the old behavior for now. If the ignoreOn flag is set on deserialize,
                                // the field's value is set to null.
                                // TODO: check if this can be removed
                                result[annotation.name] = null;
                            }
                            else
                            {
                                try
                                {
                                    result[annotation.name] = factory.deserialize(serializedData, annotation);
                                } catch (e:MissingFieldDataException)
                                {
                                    //catch this and continue silently because it is thrown only when a field's data is
                                    //missing from the serialized source and ignoreMissingField flag is set to true.
                                }
                            }
                        }
                    }
                    collisionDetector.pop();

                    return result;
                }
            }
            return null;
        }

        public function beginSerialize():void
        {
            collisionDetector.beginDocument();
        }

        public function endSerialize():void
        {
            collisionDetector.endDocument();
        }

        public function beginDeserialise():void
        {
            idResolver.beginDocument();
            collisionDetector.beginDocument();
        }

        public function endDeserialise():void
        {
            idResolver.endDocument();
            collisionDetector.endDocument();
        }


        public function registerSimpleTypeConverter(converter:IConverter, overrideExisting:Boolean = false):Boolean
        {
            if (converter == null || converter.type == null)
            {
                return false;
            }
            if (!overrideExisting && classMap && classMap[converter.type])
            {
                return false;
            }
            classMap[converter.type] = converter;
            var className:String = Types.getQualifiedClassName(converter.type);
            classNameMap[className] = converter;
            _simpleTypes[className] = TRUE;
            return true;
        }

        public function get simpleTypes():Dictionary
        {
            return _simpleTypes;
        }

        public final function stringToObject(value:String, clasz:Class):*
        {
            var converter:IConverter = classMap[clasz];
            if (converter != null)
            {
                return converter.fromString(value);
            }
            if (value == null)
                return null;
            if (clasz == Boolean)
            {
                return (value && value.toLowerCase() == "true");
            }
            if (clasz == Date)
            {
                if (value == "")
                {
                    return null;
                }
                var date:Date = new Date();
                date.setTime(Date.parse(value));
                return date;
            }
            return clasz(value);
        }

        public final function objectToString(object:*, clasz:Class):String
        {
            var converter:IConverter = classMap[clasz];
            if (converter != null)
            {
                return converter.toString(object);
            }
            if (clasz == String)
            {
                return object;
            }
            try
            {
                return object.toString();
            } catch (e:Error)
            {
                //should we do something here? I guess not
            }
            return "";
        }

        public final function xmlToObject(value:XML, clasz:Class):*
        {
            var converter:IConverter = classMap[clasz];

            if (converter != null)
            {
                var string:String;
                if(clasz == XML)
                {
                    string = value.toXMLString();
                    string = string.substring(string.indexOf(">") + 1, string.lastIndexOf("<") - 1)
                }
                else
                {
                    string = value.toString();
                }
                return converter.fromString(string);
            }
            else if (value == null)
            {
                return null;
            }
            else if (clasz == String)
            {
                return value.toString();
            }
            else if (clasz == Boolean)
            {
                return value.toString().toLowerCase() == "true";
            }
            else if (clasz == Date)
            {
                if (value == "")
                {
                    return null;
                }
                var date:Date = new Date();
                date.setTime(Date.parse(value.text().toString()));
                return date;
            }

            return clasz(value);
        }


        private function getInstance(clasz:Class, args:Array = null):Object
        {
            if (!args)
            {
                args = [];
            }
            switch (args.length)
            {
                case 0:
                    return new clasz();
                case 1:
                    return new clasz(args[0]);
                case 2:
                    return new clasz(args[0], args[1]);
                case 3:
                    return new clasz(args[0], args[1], args[2]);
                case 4:
                    return new clasz(args[0], args[1], args[2], args[3]);
                case 5:
                    return new clasz(args[0], args[1], args[2], args[3], args[4]);
                case 6:
                    return new clasz(args[0], args[1], args[2], args[3], args[4], args[5]);
                case 7:
                    return new clasz(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
                case 8:
                    return new clasz(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
                case 9:
                    return new clasz(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
                case 10:
                    return new clasz(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
                default:
                    return null;
            }
        }
    }
}