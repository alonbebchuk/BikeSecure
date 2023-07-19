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
    }

    public class TransactionItem
    {
        public int id { get; set; }
        public Guid userId { get; set; }
        public DateTime dateTime { get; set; }
        public decimal amount { get; set; }
    }

    public class LockItem
    {
        public Guid id { get; set; }
        public int stationId { get; set; }
        public Guid lockKey { get; set; }
        public Guid userId { get; set; }
        public string state { get; set; }
    }

    public class ParkingHistoryProcessItem
    {
        public int id { get; set; }
        public Guid userId { get; set; }
        public Guid lockId { get; set; }
        public DateTime startTime { get; set; }
        public DateTime endTime { get; set; }
        public int duration { get; set; }
        public decimal cost { get; set; }
    }

    public class CurrentParkingProcessItem
    {
        public int id { get; set; }
        public Guid userId { get; set; }
        public Guid lockId { get; set; }
        public DateTime startTime { get; set; }
        public int duration { get; set; }
    }
}
