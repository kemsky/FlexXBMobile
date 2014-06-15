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
     * This interface defines a cache provider recognised by FlexXB engine.
     * @author Alexutzutz
     *
     */
    public interface ICacheProvider
    {
        /**
         * Determines whether an object with the given id is aleady cached.
         * @param id the id under which the object should have been cached
         * @param clasz the class of the object
         * @return true if there is an object cached under the given id and class.
         *
         */
        function isInCache(id:String, clasz:Class):Boolean;

        /**
         * Get an instance of the specified type and with the specified id
         * from the cache
         * @param id object identifier
         * @param clasz object class
         * @return instance defined by id and type if it exists, null otherwise
         *
         */
        function getFromCache(id:String, clasz:Class):*;


        function put(id:String, itemm:*, clasz:Class):void;

        /**
         * Gets a new instance of the specified object class. The constructor may
         * require arguments which are supplied with the parameters list.<br/>
         * After the instance is created it will be placed into the cache.
         * @param clasz object class
         * @param id object identifier
         * @param parameters parameter list to be used when calling the constructor
         * @return newly created instance
         *
         */
        function getNewInstance(clasz:Class, id:String, parameters:Array = null):*;

        /**
         * Clears the cache for all the objects with given class.
         * If no class is specified, then all cache is cleared.
         * @param typeList List of types for which the cache will be flushed. ALL instances will be flushed if null or empty
         */
        function clearCache(...typeList):void;
    }
}