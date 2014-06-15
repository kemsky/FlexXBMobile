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
    import avmplus.Types;
    import flash.system.ApplicationDomain;
    import flash.utils.Dictionary;


    public class ObjectCache implements ICacheProvider
    {
        private var cacheMap:Dictionary = new Dictionary();

        public function ObjectCache()
        {
            cacheMap = new Dictionary();
        }

        public function isInCache(id:String, clasz:Class):Boolean
        {
            return cacheMap[clasz] && cacheMap[clasz][id] != null;
        }

        public function getFromCache(id:String, clasz:Class):*
        {
            if (cacheMap[clasz])
            {
                return cacheMap[clasz][id];
            }
            else
            {
                return null;
            }
        }

        public function getNewInstance(clasz:Class, id:String, parameters:Array = null):*
        {
            if (clasz)
            {
                var item:Object = parameters ? getInstance(clasz, parameters) : new clasz();

                if (id != null)
                {
                    var map:Dictionary = cacheMap[clasz];
                    if (map == null)
                    {
                        map = new Dictionary();
                        cacheMap[clasz] = map;
                    }
                    map[id] = item;
                }
            }
            return item;
        }

        /**
         * Put an object in the cache
         * @param id the id under which the object will be cached
         * @param item the object itself
         * @return if the object was succesfuly cached.
         *
         */
        public function putObject(id:String, item:Object):void
        {
            if (id && item)
            {
                var qualifiedName:String = Types.getQualifiedClassName(item);
                var clasz:Class = ApplicationDomain.currentDomain.getDefinition(qualifiedName) as Class;
                if (!cacheMap[clasz])
                {
                    cacheMap[clasz] = new Dictionary();
                }
                cacheMap[clasz][id] = item;
            }
        }

        public function put(id:String, item:*, clasz:Class):void
        {
            if (!cacheMap[clasz])
            {
                cacheMap[clasz] = new Dictionary();
            }
            cacheMap[clasz][id] = item;
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
                cacheMap = new Dictionary();
            }
        }

        private function getInstance(clasz:Class, args:Array = null):*
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