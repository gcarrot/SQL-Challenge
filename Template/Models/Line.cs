using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SQLChallenge.Models
{
    public class Line
    {
        public int Id { get; set; }
        public string LineName { get; set; }
        public string Location { get; set; }

        public List<WorkOrder> WorkOrders { get; set; }
    }
}
