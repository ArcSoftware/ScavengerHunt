using System;
using System.Linq;
using ArcSoftware.ScavengerHunt.Data.DbModels.EfModels;
using ArcSoftware.ScavengerHunt.Data.Repo;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace ArcSoftware.ScavengerHunt.Web.Controllers.Api
{
    [Route("api/log")]
    [ApiController]
    [AllowAnonymous]
    public class LogController : ApiControllerBase
    {
        private readonly IStoredProcs _sp;

        public LogController(IConfiguration config, IRepository repo, IStoredProcs sp) 
            : base(config, repo, sp)
        {
            _sp = sp;
        }


        [HttpGet("[action]")]
        public IActionResult GetLogs([FromHeader]string apiKey, DateTime? startDate, DateTime? endDate, int? userKey)
        {
            try
            {
                var logs = _sp.GetSpApiLogs(startDate, endDate);
                return logs.Any() ? (IActionResult)Ok(logs) : NotFound("No logs found in range provided.");
            }
            catch (Exception e)
            {
                LogApiException(userKey, e);
                return BadRequest(e.Message);
            }
        }

        [HttpPost("[action]")]
        public IActionResult Log([FromHeader]string apiKey, ApiLog log)
        {
            try
            {
                _sp.PostApiLog(log);
                return Ok("Logged.");
            }
            catch (Exception e)
            {
                LogApiException(log.UserKey, e);
                return BadRequest(e.Message);
            }
        }
    }
}
