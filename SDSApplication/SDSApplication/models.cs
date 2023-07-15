using Microsoft.Maui.Controls.Maps;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SDSApplication
{
    public class UserItem
    {
        public Guid id { get; set; }
        public decimal balance { get; set; }
    }

    public class TransactionItem
    {
        public int id { get; set; }
        public Guid userId { get; set; }
        public DateTime dateTime { get; set; }
        public decimal amount { get; set; }
    }

    public class Locks
    {
        public Guid id { get; set; }
        public Guid owner_id { get; set; }
        public string state { get; set; }
    }

    public class ParkingProcessItem
    {
        public int id { get; set; }
        public Guid userId { get; set; }
        public Guid lockId { get; set; }
        public DateTime startTime { get; set; }
        public DateTime endTime { get; set; }
        public TimeSpan duration { get; set; }
        public decimal cost { get; set; }
    }
}
