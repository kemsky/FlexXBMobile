package com.googlecode.flexxb.annotation.parser
{
    import com.googlecode.flexxb.annotation.contract.AccessorType;
    import com.googlecode.flexxb.annotation.contract.AnnotationFactory;
    import com.googlecode.flexxb.annotation.contract.XmlClass;
    import com.googlecode.flexxb.error.DescriptorParsingError;
    import avmplus.Types;

    import mx.collections.Sort;
    import mx.collections.SortField;

    public final class MetaParser
    {
        private var factory:AnnotationFactory;
        private var name:QName;
        private var type:Class;

        public function MetaParser(factory:AnnotationFactory)
        {
            this.factory = factory;
        }

        /**
         *
         * @param json
         * @return array of IClassAnnotation implementor instances, one for each version dicovered in the descriptor
         * @see com.googlecode.flexxb.annotation.IClassAnnotation
         * @throws com.googlecode.flexxb.error.DescriptorParsingError
         *
         */
        public function parseDescriptor(json:Object):Array
        {
            var classes:Object = {};
            processClassDescriptors(json, classes);
            var field:Object;
            for each (field in json.traits.variables)
            {
                processMemberDescriptors(field, classes, name, type);
            }
            for each (field in json.traits.accessors)
            {
                processMemberDescriptors(field, classes, name, type);
            }
            var result:Array = [];
            var descriptor:ClassMetaDescriptor;
            var classAnnotation:XmlClass;
            for (var key:* in classes)
            {
                descriptor = classes[key];
                classAnnotation = factory.getAnnotation(descriptor, null) as XmlClass;
                if (classAnnotation.ordered)
                {
                    var sort:Sort = new Sort();
                    sort.fields = [new SortField("order", false, false, true)].concat(classAnnotation.getAdditionalSortFields());
                    classAnnotation.sort = sort;
                }
                result.push(classAnnotation);
            }
            name = null;
            type = null;
            return result;
        }

        private function processClassDescriptors(json:Object, classMap:Object):void
        {
            var classType:String = json.name;
            name = new QName(null, classType.substring(classType.lastIndexOf(":") + 1));
            type = Types.getDefinitionByName(classType) as Class;
            var metas:Array = json.traits.metadata;
            var descriptors:Array = [];
            var descriptor:MetaDescriptor;
            for each(var meta:Object in metas)
            {
                descriptor = parseMetadata(meta);
                if (!descriptor)
                {
                    continue;
                }
                if (factory.isMemberAnnotation(descriptor.metadataName))
                {
                    throw new DescriptorParsingError(type, "", "Member type metadata found on class level. You should only define class and global metadatas at class level. Class metadata representant must implement IClassAnnotation; Global metadata representant must implement IGlobalAnnotation");
                }
                descriptor.fieldName = name;
                descriptor.fieldType = type;
                //we have global anotations
                if (factory.isGlobalAnnotation(descriptor.metadataName))
                {
                    descriptors.push(descriptor);
                    continue;
                }
                //we have class annotations
                if (classMap[descriptor.version])
                {
                    throw new DescriptorParsingError(type, "", "Two class type metadatas found with the same version (" + descriptor.version + ")");
                }
                classMap[descriptor.version] = descriptor;
            }
            var owner:ClassMetaDescriptor;

            //we need to assign the global descriptors to their proper class annotations
            for each(descriptor in descriptors)
            {
                owner = classMap[descriptor.version];
                if (owner)
                {
                    owner.config.push(descriptor);
                }
                else
                {
                    throw new DescriptorParsingError(owner.fieldType, descriptor.fieldName.localName, "Could not find a class annotation with the version" + meta.version);
                }
            }
        }

        private function processMemberDescriptors(field:Object, classMap:Object, className:QName, classType:Class):void
        {
            var descriptors:Array = parseField(field);
            var owner:ClassMetaDescriptor;
            var ownerName:String;
            for each(var meta:MetaDescriptor in descriptors)
            {
                owner = classMap[meta.version];
                if (owner == null && (ownerName = getOwnerName(meta)))
                {
                    owner = new ClassMetaDescriptor(factory);
                    owner.metadataName = ownerName;
                    owner.fieldType = classType;
                    owner.fieldName = className;
                    classMap[meta.version] = owner;
                }
                if (owner)
                {
                    owner.members.push(meta);
                }
                else
                {
                    throw new DescriptorParsingError(classType, meta.fieldName.localName, "Could not find a class annotation with the version" + meta.version);
                }
            }
        }

        public function parseMetadata(json:Object):MetaDescriptor
        {
            var metadataName:String = json.name;
            var descriptor:MetaDescriptor;
            //Need to make sure we're not parsing any bogus annotation
            if (factory.isRegistered(metadataName))
            {
                descriptor = getDescriptorInstance(metadataName);
                descriptor.metadataName = json.name;
                for each(var argument:Object in json.value)
                {
                    descriptor.attributes[argument.key] = argument.value;
                }
            }
            return descriptor;
        }

        private function getDescriptorInstance(metadataName:String):MetaDescriptor
        {
            if (factory.isClassAnnotation(metadataName))
            {
                return new ClassMetaDescriptor(factory);
            }
            return new MetaDescriptor(factory);
        }

        public function parseField(json:Object):Array
        {
            var descriptors:Array = [];
            var name:QName = new QName(json.uri ? json.uri : "", json.name);
            var accessType:AccessorType = AccessorType.fromString(json.access);
            var type:Class;
            try
            {
                type = Types.getDefinitionByName(json.type) as Class;
            } catch (e:Error)
            {
                throw e;
            }
            var metas:Array = json.metadata;
            var descriptor:MetaDescriptor;
            for each(var meta:Object in metas)
            {
                descriptor = parseMetadata(meta);
                if (descriptor)
                {
                    if (!factory.isMemberAnnotation(descriptor.metadataName))
                    {
                        throw new DescriptorParsingError(type, "", "Non-Member type metadata found on field level. You should only define class and global metadatas at class level. The member metadata must implement IMemberAnnotation.");
                    }
                    descriptor.fieldName = name;
                    descriptor.fieldType = type;
                    descriptor.fieldAccess = accessType;
                    descriptors.push(descriptor);
                }
            }
            return descriptors;
        }

        private function getOwnerName(meta:MetaDescriptor):String
        {
            return factory.getClassAnnotationName(meta.metadataName);
        }
    }
}