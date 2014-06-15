/**
 *   FlexXB
 *   Copyright (C) 2008-2012 Alex Ciobanu
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.googlecode.flexxb.cache
{
    import com.googlecode.flexxb.util.Instanciator;
    import avmplus.Types;
    import flash.utils.Dictionary;

    /**
     * This is the cache for object instances. It maintains a pool for each
     * object type. It works a bit differently... objects in pool are used
     * then released to be used by others. While an object is in use it cannot
     * be reasigned to other. Once the user is done with the instance, it must
     * call releaseInstance method.
     * <p/> ObjectPool does not use an id. Objects are assigned baed on the used
     * state. If all available objects are in use then a new instance will be
     * created. If there is an object released, it will be passed on for use.
     * That's why sometimes it is required to clean the objects after use. This
     * is where the IPooledObject interface comes to use by exposing the clear
     * method which should be implemented by the objects that require some
     * cleanup before being reused.
     * @author aCiobanu
     *
     */
    public final class ObjectPool implements ICacheProvider
    {
        private static const _instance:ObjectPool = new ObjectPool();
        /**
         * Easy access instance
         * @return
         *
         */
        public static function get instance():ObjectPool
        {
            return _instance;
        }

        private var cacheMap:Dictionary;

        public function ObjectPool()
        {
            cacheMap = new Dictionary();
        }

        public function isInCache(id:String, type:Class):Boolean
        {
            var store:TypeCache = cacheMap[type] as TypeCache;
            return store && store.hasItemsAvailable();
        }

        public function getFromCache(id:String, type:Class):*
        {
            if (!type)
            {
                throw new Error("Invalid type");
            }
            var store:TypeCache = cacheMap[type] as TypeCache;
            if (store)
            {
                return store.getInstance();
            }
            return null;
        }

        public function getNewInstance(clasz:Class, id:String, parameters:Array = null):*
        {
            var item:Object;
            if (clasz)
            {
                item = Instanciator.getInstance(clasz, parameters);
                putObject(id, clasz, item);
            }
            return item;
        }

        /**
         * Mark the view instance as unused
         * @param instanceList
         *
         */
        public function releaseInstance(instance:Object):void
        {
            if (!instance) return;
            var type:Object;
            if (instance is IPooledObject)
            {
                IPooledObject(instance).clear();
                type = IPooledObject(instance).type;
            }
            else
            {
                type = Types.getDefinitionByName(Types.getQualifiedClassName(instance));
            }
            var store:TypeCache = cacheMap[type] as TypeCache;
            if (store)
            {
                store.releaseInstance(instance);
            }
        }

        /**
         * Tell the cache the display of the attributes started so it will
         * at the starting position in the object cache and return object
         * instances until it runs out. After that new instances will be
         * created and added in the cache
         * @param args list of types
         *
         */
        public function beginNewSequence(...args):void
        {
            var store:TypeCache;
            if (args && args.length > 0)
            {
                for each(var type:Object in args)
                {
                    store = cacheMap[type] as TypeCache;
                    if (store)
                    {
                        store.resetIndex();
                    }
                }
            }
            else
            {
                for each(store in cacheMap)
                {
                    store.resetIndex();
                }
            }
        }

        public function clearCache(...typeList):void
        {
            if (typeList && typeList.length > 0)
            {
                for each(var type:Object in typeList)
                {
                    if (cacheMap[type])
                    {
                        delete cacheMap[type];
                    }
                }
            }
            else
            {
                for (var key:* in cacheMap)
                {
                    delete cacheMap[key];
                }
            }
        }

        private function putObject(id:String, clasz:Class, object:Object):void
        {
            var store:TypeCache = cacheMap[clasz] as TypeCache;
            if (!store)
            {
                store = new TypeCache(clasz);
                cacheMap[clasz] = store;
            }
            store.putObject(id, object);
        }


        public function put(id:String, itemm:*, clasz:Class):void
        {
            throw new Error("not implemented");
        }
    }
}