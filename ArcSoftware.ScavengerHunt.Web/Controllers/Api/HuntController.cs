using System;
using ArcSoftware.ScavengerHunt.Data.DbModels.EfModels;
using ArcSoftware.ScavengerHunt.Data.Repo;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System.Linq;
using ArcSoftware.ScavengerHunt.Data.Enums;

namespace ArcSoftware.ScavengerHunt.Web.Controllers.Api
{
    [Route("api/company")]
    [ApiController]
    [Authorize]
    [AllowAnonymous]
    public class HuntController : ApiControllerBase
    {
        private readonly IRepository _repo;
        private readonly IStoredProcs _sp;

        public HuntController(IConfiguration config, IRepository repo, IStoredProcs sp) : base(config, repo, sp)
        {
            _repo = repo;
            _sp = sp;
        }

        [HttpGet("[action]")]
        public IActionResult GetAllHunts()
        {
            try
            {
                var ret = _repo.GetItems<Hunt>(i => i.IsActive);

                return ret.Any() ? (IActionResult)Ok(ret) : NotFound("No Hunts Found.");
            }
            catch (Exception e)
            {
                LogApiException(null, e);
                return BadRequest(e.Message);
            }
        }

        [HttpGet("[action]")]
        public IActionResult GetAllChallenges(int huntKey)
        {
            try
            {
                var hunt = _repo.GetItem<Hunt>(i => i.Id == huntKey);
                if (hunt == null) throw new Exception($"Hunt ({huntKey}) not found.");

                hunt.LastLoadDate = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow,
                    TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time"));
                _repo.Update<Hunt>(hunt);

                var ret = _repo.GetItems<Challenge>(i => i.HuntKey == huntKey && i.IsActive);

                return ret.Any() ? (IActionResult)Ok(ret) : NotFound("No Challenges found for this Hunt.");
            }
            catch (Exception e)
            {
                LogApiException(null, e);
                return BadRequest(e.Message);
            }
        }

        [HttpPost("[action]")]
        public IActionResult CreateHunt(int userKey, string huntName)
        {
            try
            {
                var hunt = new Hunt(huntName, userKey);

                _repo.Create<Hunt>(hunt);
                LogInfo(userKey, LoggingSeverity.Info, $"User created a new Hunt - {hunt}");

                return Ok("Hunt Created");
            }
            catch (Exception e)
            {
                LogApiException(userKey, e);
                return BadRequest(e.Message);
            }
        }

        [HttpPost("[action]")]
        public IActionResult CreateChallenge(int userKey, Challenge challenge)
        {
            if (challenge == null) throw new ArgumentNullException(nameof(challenge));

            try
            {
                var hunt = _repo.GetItem<Hunt>(i => i.Id == challenge.HuntKey);
                if (hunt == null) throw new Exception($"Hunt ({challenge.HuntKey}) not found.");

                _repo.Create<Challenge>(challenge);
                LogInfo(userKey, LoggingSeverity.Info, $"User created a new Challenge - {challenge}");

                return Ok("Reason Created");
            }
            catch (Exception e)
            {
                LogApiException(userKey, e);
                return BadRequest(e.Message);
            }
        }
    }
}
