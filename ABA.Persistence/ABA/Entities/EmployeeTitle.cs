using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class EmployeeTitle
    {
        public EmployeeTitle()
        {
            Employees = new HashSet<Employee>();
        }

        public int EmployeeTitleId { get; set; }
        public string Name { get; set; }

        public virtual ICollection<Employee> Employees { get; set; }
    }
}
