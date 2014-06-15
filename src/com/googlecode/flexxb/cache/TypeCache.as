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
    /**
     * This is the actual store for the object instances.
     * @author aCiobanu
     * @private
     */
    internal final class TypeCache
    {
        /**
         * Type of objects being stored
         */
        public var type:Class;
        /**
         * @private
         */
        private var objectStore:Array = [];
        /**
         * @private
         */
        private var objectUsage:Array = [];
        /**
         * @private
         */
        private var currentIndex:int = 0;

        /**
         * Constructor
         * @param type the object type
         *
         */
        public function TypeCache(type:Class)
        {
            this.type = type;
        }

        /**
         * Get an object instance stored in cache that is not marked as used.
         * Returns null if such an instance is not found.
         * @return
         *
         */
        public function getInstance():Object
        {
            var object:Object;
            if (objectStore && currentIndex < objectStore.length)
            {
                objectUsage[currentIndex] = true;
                object = objectStore[currentIndex];
                while (objectUsage[++currentIndex])
                {
                }
            }
            return object;
        }

        /**
         * Mark the instance as unused so other clients may take hold of it and use it in dsplay
         * @param instance
         *
         */
        public function releaseInstance(instance:Object):void
        {
            if (!instance) return;
            var index:int = objectStore.indexOf(instance, currentIndex);
            if (index == -1)
            {
                index = objectStore.indexOf(instance);
            }
            if (index > -1)
            {
                objectUsage[index] = false;
                if (currentIndex > index)
                {
                    currentIndex = index;
                }
            }
        }

        /**
         * Signal the store that the cache index should be resetted
         * thus instances would come from it again and only created if
         * all stored ones get used up
         *
         */
        public function resetIndex():void
        {
            currentIndex = 0;
            var loop:int = 0;
            while (loop < objectUsage.length)
            {
                objectUsage[loop++] = false;
            }
        }

        /**
         *
         * @return
         *
         */
        public function hasItemsAvailable():Boolean
        {
            return objectStore && currentIndex < objectStore.length;
        }

        /**
         * Clear the cache
         *
         */
        public function clear():void
        {
            currentIndex = 0;
            objectStore = [];
            objectUsage = [];
        }

        /**
         * @private
         * @param id
         * @param object
         *
         */
        internal function putObject(id:String, object:Object):void
        {
            objectStore.push(object)
            objectUsage.push(true);
            currentIndex++;
        }
    }
}