using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SQLChallenge.Models
{

    public class WorkOrder
    {
        public int Id { get; set; }
        public string WorkOrderNumber { get; set; }
        public DateTime CreatedAt { get; set; }
        public int LineId { get; set; }
        public int ProductId { get; set; }
        public int Quantity { get; set; }
        public string Status { get; set; }

        public Line Line { get; set; }
        public Product Product { get; set; }
    }
}
