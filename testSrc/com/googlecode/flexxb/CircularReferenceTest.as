/**
 *   FlexXBTest
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
package com.googlecode.flexxb
{
    import com.googlecode.flexxb.core.FxBEngine;
    import com.googlecode.flexxb.api.XmlApiClass;
    import com.googlecode.testData.Company;
    import com.googlecode.testData.Department;
    import com.googlecode.testData.DepartmentEmployee;

    import flash.events.Event;

    import org.flexunit.assertThat;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.notNullValue;

    public final class CircularReferenceTest
    {
        private var cycleDetectedCount:Number;

        public function CircularReferenceTest()
        {
        }

        [Before]
        public function setup():void
        {
            cycleDetectedCount = 0;
        }

        [Test]
        public function validateCollisionDetection():void
        {
            var department:Department = new Department();
            department.id = 14;
            department.name = "R&D";
            var employee:DepartmentEmployee = new DepartmentEmployee();
            employee.name = "John Doe";
            employee.department = department;
            department.employees = [employee];
            employee = new DepartmentEmployee();
            employee.name = "Mike Chambers";
            employee.department = department;
            department.employees.push(employee);
            department.addEventListener(Department.CYCLE_DETECTED, onCycleDetected);
            var xml:XML = new FxBEngine().getXmlSerializer().serialize(department) as XML;
            assertThat(cycleDetectedCount, equalTo(2));
        }

        [Test]
        public function circularReferenceTest():void
        {
            var company:Company = new Company();
            company.departments = [];
            company.employees = [];

            var department:Department;
            department = new Department();
            department.id = 14;
            department.name = "R&D";
            company.departments.push(department);

            var employee:DepartmentEmployee;
            employee = new DepartmentEmployee();
            employee.name = "Johnny Quest";
            employee.department = department;
            company.employees.push(employee);

            employee = new DepartmentEmployee();
            employee.name = "Johnny Bravo";
            employee.department = department;
            company.employees.push(employee);

            department = new Department();
            department.id = 11;
            department.name = "Marketing";
            company.departments.push(department);

            employee = new DepartmentEmployee();
            employee.name = "GI Joe";
            employee.department = department;
            company.employees.push(employee);

            var engine:FxBEngine = new FxBEngine();
            var clasz:XmlApiClass = new XmlApiClass(DepartmentEmployee);
            clasz.addAttribute("name", String);
            clasz.addElement("department", Department).idref = true;
            engine.api.processTypeDescriptor(clasz);
            var xml:XML = engine.getXmlSerializer().serialize(company) as XML;
            var clone:Company = engine.getXmlSerializer().deserialize(xml);

            assertThat(clone.departments.length, equalTo(2));
            assertThat(clone.employees.length, equalTo(3));
            assertThat(DepartmentEmployee(clone.employees[0]).department, notNullValue());
            assertThat(DepartmentEmployee(clone.employees[0]).department, equalTo(clone.departments[0]));
            assertThat(DepartmentEmployee(clone.employees[1]).department, equalTo(clone.departments[0]));
            assertThat(DepartmentEmployee(clone.employees[2]).department, equalTo(clone.departments[1]));
        }

        private function onCycleDetected(event:Event):void
        {
            cycleDetectedCount++;
        }
    }
}