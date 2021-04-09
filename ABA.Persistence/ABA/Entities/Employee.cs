using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class Employee
    {
        public Employee()
        {
            Licenses = new HashSet<License>();
        }

        public string EmployeeIdnp { get; set; }
        public int EmployeeTitleId { get; set; }
        public int PoliceSectorId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }

        public virtual EmployeeTitle EmployeeTitle { get; set; }
        public virtual ICollection<License> Licenses { get; set; }
    }
}
