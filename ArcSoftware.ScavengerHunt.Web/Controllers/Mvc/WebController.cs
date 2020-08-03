using System.Diagnostics;
using ArcSoftware.ScavengerHunt.Web.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace ArcSoftware.ScavengerHunt.Web.Controllers.Mvc
{
    public class WebController : Controller
    {
        private readonly ILogger<WebController> _logger;

        public WebController(ILogger<WebController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            return View("ApiLogView");
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
