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
package com.googlecode.flexxb.interfaces
{
    /**
     * Optional interface that can be implemented by FlexXB bound objects to handle
     * cycles in the object graph.
     * <p/>Normally a cycle in the object graph causes the engine to throw an error.
     * This is not always a desired behavior.Implementing this interface allows the
     * user application to change this behavior.
     *
     * @author Alexutz
     *
     */
    public interface ICycleRecoverable
    {
        /**
         * Called when a cycle is detected by the engine to nominate a new
         * object to be serialized instead.
         * @param parentCaller reference to the parent object referencing the current one
         * @return the object to be serialized instead of <code>this</code> or null to
         * instruct the engine to behave as if the object does not implement this interface.
         *
         */
        function onCycleDetected(parentCaller:Object):Object;
    }
}