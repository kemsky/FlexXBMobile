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
     * This is the interface for objects used by the object cache. Using this interface will give
     * the implementor objects the ability to get their cleanup method called when they are returned
     * to the cache. The object Cache can store any type of objects, regardless whether they implement
     * IPooledObject or not.
     * @author aCiobanu
     *
     */
    public interface IPooledObject
    {
        /**
         * Easy access to the object type
         * @return
         *
         */
        function get type():Object;

        /**
         * Called when the object is released from UI use and back into the object cache
         */
        function clear():void;
    }
}