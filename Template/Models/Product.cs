using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SQLChallenge.Models
{

    public class Product
    {
        public int Id { get; set; }
        public string ProductCode { get; set; }
        public string ProductName { get; set; }
        public string Category { get; set; }

        public List<WorkOrder> WorkOrders { get; set; }
    }
}
